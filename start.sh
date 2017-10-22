#!/bin/bash

# die on error
set -e

# write a pgbouncer config from the template, substituting environment
# variables for placeholders in code
echo "writing /etc/pgbouncer/pgbouncer.ini"
envsubst < pgbouncer.template.ini > /etc/pgbouncer/pgbouncer.ini

# KICK IT
echo "starting pgbouncer"
pgbouncer /etc/pgbouncer/pgbouncer.ini
