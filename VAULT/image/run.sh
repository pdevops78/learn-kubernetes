vault login $VAULT_TOKEN
 vault kv get $SECRET_NAME |sed -n -e '/= Data =/,$p' | grep -Ev '= Data =|^key|^--'| awk '{print "export "$1"="$2}' >/tmp/data
 cat /tmp/data

