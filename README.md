# rstudio
RStudio for docker

# build
docker build . -t rstudio

# run
docker run --name rstudio -e PASSWORD=password  -p 8787:8787 -v "$(pwd)/persistent":/home/rstudio/r-docker-tutorial  rstudio

docker run --name rstudio -p 8787:8787 -v "$(pwd)/persistent":/home/rstudio/r-docker-tutorial rstudio
