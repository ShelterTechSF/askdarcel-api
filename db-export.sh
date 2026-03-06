#!/usr/bin/env bash

set -euo pipefail
set -v

# This dumps CSV files for each table we're exporting to a `dump/` directory.
# This script also assumes that you have a dump of the DB named dump.sql that is
# used to reload this temporary DB

if [[ $# -ne 1 ]]; then
  echo "Exactly one argument required: the database.sql dump"
  exit 1
fi

dump=$1

DOCKER=${DOCKER:-docker}
echo $DOCKER

# $DOCKER create -v $PWD:/mnt/host --name psql-hacks -e POSTGRES_HOST_AUTH_METHOD=trust postgres
# $DOCKER start psql-hacks

rm -rf dump
mkdir -p dump
$DOCKER exec psql-hacks dropdb -U postgres postgres --if-exists
$DOCKER exec psql-hacks createdb -U postgres postgres
$DOCKER exec -i psql-hacks psql -U postgres < $dump

# Drop tables that we don't want to export
$DOCKER exec psql-hacks psql -U postgres -c "DROP TABLE accessibilities, admins, ar_internal_metadata, bookmarks, categories_keywords, categories_sites, change_requests, documents, documents_services, eligibility_relationships, feedbacks, field_changes, folders, group_permissions, groups, instructions, keywords, keywords_resources, keywords_services, news_articles, permissions, resources_sites, reviews, saved_searches, schema_migrations, sites, synonym_groups, synonyms, texting_recipients, textings, user_groups, users, volunteers"
# Empty tables but have foreign keys from other tables that point to them
$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE phones DROP COLUMN contact_id;
ALTER TABLE services DROP COLUMN contact_id;
ALTER TABLE resources DROP COLUMN contact_id;
DROP TABLE contacts;
"
$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE services DROP COLUMN funding_id;
ALTER TABLE resources DROP COLUMN funding_id;
DROP TABLE fundings;
"
$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE phones DROP COLUMN language_id;
DROP TABLE languages;
"
$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE services DROP COLUMN program_id;
DROP TABLE programs;
"

# This column needs to be dropped earlier because we need to avoid violating a
# foreign key constraint with the larger query below. We don't want this column
# anyway.
$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE services
  DROP COLUMN boosted_category_id
  ;
"

# Our415 top-level categories
# 'Arts, Culture & Identity', 'Children''s Care', 'Education', 'Family Support', 'Health & Wellness', 'Sports & Recreation', 'Youth Workforce & Life Skills'
# These happen to have consecutive IDs of 356 through 362
$DOCKER exec psql-hacks psql -U postgres -c "
WITH top_level_categories AS (
  SELECT categories.id FROM categories
    WHERE categories.name in ('Arts, Culture & Identity', 'Children''s Care', 'Education', 'Family Support', 'Health & Wellness', 'Sports & Recreation', 'Youth Workforce & Life Skills')
),
-- Low level categories that are children of the top_level_categories
low_level_categories_to_keep AS (
  SELECT child.id FROM categories AS child
    INNER JOIN category_relationships AS cr ON (cr.child_id = child.id)
    INNER JOIN categories AS parent ON (cr.parent_id = parent.id)
    WHERE parent.id IN (SELECT * FROM top_level_categories)
),
-- Delete any category that is not one of the top_level_categories or low_level_categories_to_keep
categories_deleted AS (
  DELETE FROM categories AS c
    WHERE c.id NOT IN (SELECT * FROM top_level_categories)
    and c.id NOT IN (SELECT * FROM low_level_categories_to_keep)
    RETURNING c.id
),
services_to_keep AS (
  SELECT s.id FROM categories AS c
    INNER JOIN categories_services AS cs ON (c.id = cs.category_id)
    INNER JOIN services AS s ON (cs.service_id = s.id)
    INNER JOIN resources AS r ON (s.resource_id = r.id)
    WHERE c.id in (SELECT * FROM top_level_categories)
    AND s.status = 1
    AND r.status = 1
),
services_deleted AS (DELETE FROM services WHERE id NOT IN (SELECT * FROM services_to_keep) RETURNING services.id),
resources_deleted AS (
  DELETE FROM resources
    WHERE resources.id NOT IN (SELECT resources.id FROM resources INNER JOIN services ON services.resource_id = resources.id WHERE services.id IN (SELECT * FROM services_to_keep))
    OR resources.status != 1
    RETURNING resources.id
),
schedules_deleted AS (DELETE FROM schedules WHERE schedules.service_id IN (SELECT * FROM services_deleted) RETURNING schedules.id),
notes_deleted AS (DELETE FROM notes WHERE notes.service_id IN (SELECT * FROM services_deleted)),
schedule_days_deleted AS (DELETE FROM schedule_days WHERE schedule_days.schedule_id IN (SELECT * FROM schedules_deleted)),
addresses_deleted AS (DELETE FROM addresses WHERE addresses.resource_id IN (SELECT * FROM resources_deleted)),
phones_deleted AS (DELETE FROM phones WHERE phones.resource_id IN (SELECT * FROM resources_deleted)),
notes_deleted2 AS (DELETE FROM notes WHERE notes.resource_id IN (SELECT * FROM resources_deleted)),
schedules_deleted2 AS (DELETE FROM schedules WHERE schedules.resource_id IN (SELECT * FROM resources_deleted) RETURNING schedules.id),
schedule_days_deleted2 AS (DELETE FROM schedule_days WHERE schedule_days.schedule_id IN (SELECT * FROM schedules_deleted2))
SELECT * FROM categories_deleted;
"

# Delete these stray rows afterwards since we don't actually have a foreign key
# constraint between category_relationships and categories, and so they don't
# need to be part of the giant query above
$DOCKER exec psql-hacks psql -U postgres -c "
DELETE FROM category_relationships
  WHERE category_relationships.parent_id NOT IN (SELECT id FROM categories)
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
DELETE FROM category_relationships
  WHERE category_relationships.child_id NOT IN (SELECT id FROM categories)
  ;
"

# Drop columns

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE addresses
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN address_3,
  DROP COLUMN address_4,
  DROP COLUMN online,
  DROP COLUMN region,
  DROP COLUMN description,
  DROP COLUMN transportation
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE categories_services
  DROP COLUMN feature_rank
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE category_relationships
  DROP COLUMN child_priority_rank
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE categories
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN vocabulary,
  DROP COLUMN featured
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE eligibilities
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN feature_rank
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE notes
  DROP COLUMN created_at,
  DROP COLUMN updated_at
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE phones
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN description,
  DROP COLUMN service_id
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE resources
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN short_description,
  DROP COLUMN verified_at,
  DROP COLUMN status,
  DROP COLUMN certified,
  DROP COLUMN certified_at,
  DROP COLUMN featured,
  DROP COLUMN source_attribution,
  DROP COLUMN internal_note
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE services
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN eligibility,
  DROP COLUMN short_description,
  DROP COLUMN verified_at,
  DROP COLUMN status,
  DROP COLUMN certified,
  DROP COLUMN certified_at,
  DROP COLUMN featured,
  DROP COLUMN source_attribution,
  DROP COLUMN internal_note
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE schedules
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN hours_known
  ;
"

$DOCKER exec psql-hacks psql -U postgres -c "
ALTER TABLE schedule_days
  DROP COLUMN created_at,
  DROP COLUMN updated_at,
  DROP COLUMN day,
  DROP COLUMN open_time,
  DROP COLUMN close_time
  ;
"


# Dump tables as CSV
for table in $($DOCKER exec -w /mnt/host psql-hacks psql -U postgres -t -A -c "SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema');"); do
  $DOCKER exec -w /mnt/host psql-hacks psql -U postgres -c "COPY $table TO '/mnt/host/dump/$table.csv' DELIMITER ',' CSV HEADER;"
done
