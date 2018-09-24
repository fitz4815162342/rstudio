# rstudio
RStudio for docker

# build
docker build . -t rstudio

# run
docker run --name rstudio -e PASSWORD=password  -p 8787:8787 fitz4815162342/rstudio
