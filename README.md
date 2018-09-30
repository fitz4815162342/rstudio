# rstudio
data science with R, Shiny and RStudio

# run
docker run --name rstudio -d -h RStudio -e PASSWORD=password -p 8787:8787 fitz4815162342/rstudio

If you want to share data from a persistent directory on your host into the volume of the container:

docker run --name rstudio --rm -d -h RStudio -e PASSWORD=password -p 8787:8787 -v $(pwd)/persistent:/home/rstudio/persistent fitz4815162342/rstudio
