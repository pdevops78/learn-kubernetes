mkdir -p /usr/share/nginx/html
while true ; do
  echo "<h1>Hello-${date}" >/usr/share/nginx/html/index.html
  sleep 1
done
# in this code container will be in running state for every 1 second and loop not to terminate until manually stops
# if we not mention sleep 1 then container will be in exited status.

#echo Hello >/usr/share/nginx/html/index.html
