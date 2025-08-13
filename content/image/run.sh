mkdir -p /usr/share/nginx/html
while true; do
  echo "<h1> Hello World </h1>:${date}" >/usr/share/nginx/html/index.html
done
