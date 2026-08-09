#!/bin/bash

# Path to the fake data SQL file
SQL_FILE="utils/db/sql/fake-data.sql"

# Check if SQL file exists
if [ ! -f "$SQL_FILE" ]; then
    echo "Error: SQL file $SQL_FILE does not exist"
    exit 1
fi

# List available databases to diagnose
echo "Listing available databases:"
PGPASSWORD=postgres psql -h db -U postgres -p 5432 -l

# Populate database
echo "Populating database with fake data from $SQL_FILE..."
PGPASSWORD=postgres psql -h db -U postgres -p 5432 -d askdarcel_development -f "$SQL_FILE"

# Check execution status
if [ $? -eq 0 ]; then
    echo "Database population completed successfully."
else
    echo "Error populating database."
    exit 1
fi``