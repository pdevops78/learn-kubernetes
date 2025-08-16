vault login $VAULT_TOKEN
 vault kv get $SECRET_NAME |sed -n -e '/= Data =/,$p' | grep -Ev '= Data =|^Key|^--'| awk '{print "export "$1"="$2}' >/data/secrets
 cat /data/secrets

