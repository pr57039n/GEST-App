docker run -it \
-v $PWD:/e2e \
-w /e2e \
-e CYPRESS_baseUrl=http://172.17.0.1:8000 \
cypress/included:12.0.2 --browser firefox
