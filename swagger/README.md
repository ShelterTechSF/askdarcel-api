This directory contains a generated JSON that is used to power the api-docs available at `/api-docs`.

To regenerate it locally, run `bundle exec rails swagger`.  

This command gets run during build so that staging and production are up to date.  This may change in the future since it causes inconsistency between what is in the repo, and what is found in deployed environments.