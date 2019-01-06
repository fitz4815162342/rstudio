FROM rocker/rstudio:latest

RUN mkdir -p "/home/rstudio/persistent" && chmod -R 777 "/home/rstudio/persistent"

VOLUME home/rstudio/persistent 

WORKDIR /home/rstudio/persistent

ENV CRAN_MIRROR https://mran.microsoft.com/snapshot/2017-06-15

RUN apt-get update --fix-missing \
	&& apt-get install -y \
		ca-certificates \
    	libglib2.0-0 \
	 	libxext6 \
	   	libsm6  \
	   	libxrender1 \
		libxml2-dev

RUN apt-get install -y \
    graphviz \
	libgraphviz-dev \
	libpng-dev

# install python3, virtualenv and anaconda
RUN apt-get install -y \
		python3-pip \
		python3-dev \
	&& pip3 install virtualenv


# install anaconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-2018.12-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda update conda
RUN conda update anaconda
RUN conda update --all
#RUN pip install --upgrade pip
RUN pip3 install qiskit numpy scipy scikit-learn pillow h5py tensorflow keras tensorboard graphviz pydot matplotlib seaborn

# install R development packages and reticulate
RUN install2.r --repos ${CRAN_MIRROR}\
		Rcpp \
		devtools \
		roxygen2 \
		knitr \
		rmarkdown \
		yaml \
		reticulate \
		ggplot2 \
		dplyr

# install R packages for tensorflow and keras
RUN install2.r --repos ${CRAN_MIRROR}\
		kerasR \
		png \
	&& R -e 'devtools::install_github("rstudio/tensorflow", ref = "v0.8.2")' # released on 2017-06-12

RUN echo 'options(repos = c(CRAN = "'$CRAN_MIRROR'"), download.file.method = "libcurl")' >> /usr/local/lib/R/etc/Rprofile.site \
	&& echo 'TENSORFLOW_PYTHON = "/opt/conda/bin/python3"' >> /usr/local/lib/R/etc/Renviron \
	&& echo 'RETICULATE_PYTHON = "/opt/conda/bin/python3"' >> /usr/local/lib/R/etc/Renviron


RUN R -e "install.packages(c('leaflet', 'shiny', 'shinydashboard', 'openxlsx', 'RColorBrewer', 'rpart', 'gbm', 'plotly', 'readr', 'magrittr', 'DT'), repos='https://cloud.r-project.org/')"

EXPOSE 8787 

ENTRYPOINT ["/init"]
