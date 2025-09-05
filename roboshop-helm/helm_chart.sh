#helm upgrade -i $1 -f values/$1.yaml ./chart
helm install $1 -f chart/values/$1.yaml ./chart