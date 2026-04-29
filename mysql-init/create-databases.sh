#!/bin/bash
set -e

# Create all databases from MYSQL_DATABASES or fallback to MYSQL_DATABASE.
DATABASE_LIST="${MYSQL_DATABASES:-$MYSQL_DATABASE}"
if [ -z "$DATABASE_LIST" ]; then
  echo "No databases configured in MYSQL_DATABASES or MYSQL_DATABASE."
  exit 0
fi

IFS=',' read -ra DATABASES <<< "$DATABASE_LIST"
for db in "${DATABASES[@]}"; do
  db_name="$(echo "$db" | xargs)"
  if [ -n "$db_name" ]; then
    echo "Creating database if not exists: $db_name"
    mysql --protocol=socket -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$db_name\`;"
    if [ -n "$MYSQL_USER" ]; then
      echo "Granting privileges on $db_name to $MYSQL_USER"
      mysql --protocol=socket -uroot -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`$db_name\`.* TO '$MYSQL_USER'@'%';"
    fi
  fi
done

if [ -n "$MYSQL_USER" ]; then
  mysql --protocol=socket -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
fi
