# rstudio
RStudio for docker

# run
docker run --name rstudio -e PASSWORD=password  -p 8787:8787 fitz4815162342/rstudio

If you want to share data from a persistent directory on your host into the volume of the container:

docker run --name rstudio -e PASSWORD=password -p 8787:8787 -v $(pwd)/persistent:/home/rstudio/persistent -ti fitz4815162342/rstudio /bin/bash
