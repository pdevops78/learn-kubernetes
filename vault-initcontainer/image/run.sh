vault login $VAULT_TOKEN
 vault kv get $SECRET_NAME |sed -n -e '/= Data =/,$p' | grep -Ev '= Data =|^Key|^--'| awk '{print "export "$1"="$2}' >/tmp/data.txt
 cat /tmp/data.txt

# vault kv get common/common | sed -n -e '/= Data =/,$p' | grep -Ev '= Data =|^key|^---'| awk '{print "export "$1"="$2}'
