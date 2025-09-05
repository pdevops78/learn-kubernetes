vault login $VAULT_TOKEN
vault kv get $SECRET_NAME | sed -n -e '/= Data =/,$p' | grep -Ev '= Data =|^key|^--'|
