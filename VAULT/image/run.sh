vault login $VAULT_TOKEN
 vault kv get common/common|sed -n -e '/= Data =/,$p' | grep -Ev '= Data =|^key|^--'| awk '{print "export "$1"="$2}' >/data/secrets.txt

