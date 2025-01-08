
docker build -t backend-service ./server

docker build -t nginx-service ./docker/nginx

docker compose -f ./docker/compose/docker-compose.yml up -d
