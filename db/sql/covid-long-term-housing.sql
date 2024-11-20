-- Covid Long Term Housing Category
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values 
(1000011, '04-AUG-22', '04-AUG-22', 'Covid-longtermhousing', 't', null, 'f');

-- Covid Long Term Housing Subcategories
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100045, '04-AUG-22', '04-AUG-22', 'I am experiencing homelessness and I need immediate help finding shelter.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100046, '04-AUG-22', '04-AUG-22', 'I am experiencing homelessness (on the street, couchsurfing, or other) and I need long-term housing assistance.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100047, '04-AUG-22', '04-AUG-22', 'I am not currently experiencing homelessness, but I am looking for a long-term affordable housing unit.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100048, '04-AUG-22', '04-AUG-22', 'I am between 18 and 27 years old.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100049, '04-AUG-22', '04-AUG-22', 'I am an adult over 27 years old without children.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100050, '04-AUG-22', '04-AUG-22', 'I am part of a family with children under 18 years old.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100051, '04-AUG-22', '04-AUG-22', 'I am looking to rent a home.', 'f', null, 'f');

insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values
(1100052, '04-AUG-22', '04-AUG-22', 'I am looking to buy a home.', 'f', null, 'f');

insert into category_relationships (parent_id, child_id) values
(1000011, 1100045);

insert into category_relationships (parent_id, child_id) values
(1000011, 1100046);

insert into category_relationships (parent_id, child_id) values
(1000011, 1100047);

insert into category_relationships (parent_id, child_id) values
(1100046, 1100048);

insert into category_relationships (parent_id, child_id) values
(1100046, 1100049);

insert into category_relationships (parent_id, child_id) values
(1100046, 1100045);

insert into category_relationships (parent_id, child_id) values
(1100047, 1100051);

insert into category_relationships (parent_id, child_id) values
(1100047, 1100052);









