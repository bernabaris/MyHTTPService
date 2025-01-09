
docker build -t http-app:1.0.0 ./server

docker build -t nginx-service ./docker/nginx

docker save -o http-app.tar http-app:1.0.0
sudo ctr -n k8s.io images import http-app.tar
rm -f http-app.tar



