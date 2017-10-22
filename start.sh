#!/bin/bash

# die on error
set -e

echo "hashing passwords"
# awk because it output the "file name", which is blank and ends up with a
# trailing " - "
HASHED_STATS_PASSWORD=$(echo -n "$STATS_PASSWORD$STATS_USER" | md5sum | awk '{ print $1 }')
HASHED_CLIENT_PASSWORD=$(echo -n "$CLIENT_PASSWORD$CLIENT_USER" | md5sum | awk '{ print $1 }')

echo "writing /etc/pgbouncer/userlist.txt"
cat << EOF > /etc/pgbouncer/userlist.txt
"$STATS_USER" "md5$HASHED_STATS_PASSWORD"
"$CLIENT_USER" "md5$HASHED_CLIENT_PASSWORD"
EOF

# write a pgbouncer config from the template, substituting environment
# variables for placeholders in code
echo "writing /etc/pgbouncer/pgbouncer.ini"
DATABASE_CONFIGURATION="$CLIENT_DBNAME = host=$SERVER_HOST port=$SERVER_PORT dbname=$SERVER_DBNAME user=$SERVER_USER password=$SERVER_PASSWORD" envsubst < pgbouncer.template.ini > /etc/pgbouncer/pgbouncer.ini

# KICK IT
echo "starting pgbouncer"
pgbouncer /etc/pgbouncer/pgbouncer.ini
