source /tmp/secrets.txt
cat  /tmp/secrets.txt
echo
env

git clone https://github.com/pdevops78/${project_name}-${component}
cd ${project_name}-${component}
echo ${project_name}-${component}

if [ "${db_name}" == 'mysql' ]; then
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

    if [ -z  "${project_name}" ]; then
        echo project_name is missing
        exit 1
    fi

    if [ -z  "${component}" ]; then
        echo component is missing
        exit 1
    fi
    mysql -h${DB_HOST} -u${rds_name} -p${rds_password} <schema/${component}.sql
    echo mysql -h${DB_HOST} -u${rds_name} -p${rds_password} <schema/${component}.sql
fi

if [ "${db_name}" == 'mongo' ]; then
  if [ -z "${DOCUMENTDB}" ]; then
      echo "Environment variable is missing"
      exit 1;
  fi
  if [ -z "${MONGO_URL}" ]; then
      echo "Environment variable is missing"
      exit 1;
  fi
fi



# required to in vault ui , project_name and component