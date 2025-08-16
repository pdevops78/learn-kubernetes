source /data/secrets.txt

if [ -z "${DB_HOST}" ]; then
  echo DB_HOST is missing
  exit 1
fi

if [ -z "${NEW_RELIC_APP_NAME}" ]; then
  echo NEW_RELIC_APP_NAME is missing
  exit 1
fi

if [ -z  "${NEW_RELIC_LICENSE_KEY}" ]; then
    echo NEW_RELIC_LICENSE_KEY is missing
    exit 1
fi

git clone https://github.com/pdevops78/expense-backend
cd expense-backend
mysql -h${DB_HOST} -u${rds_name} -p${rds_password} < /app/schema/backend.sql