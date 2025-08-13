mkdir -p /usr/share/nginx/html
while true; do
  echo "<h1> Hello World -${date}</h1>" >/usr/share/nginx/html/index.html
done
