cd server
docker build -t backend-service .
cd ..
cd docker/nginx
docker build -t nginx-service .
cd ../..
cd docker/compose
docker compose up -d