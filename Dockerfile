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

# install tensorflow
# create virtualenv at /tensorflow and install tensorflow as well as keras
# To use kerasR::plot_model()

RUN apt-get install -y \
    graphviz \
	libgraphviz-dev \
	libpng-dev

RUN mkdir /tensorflow \
	&& virtualenv -p python3.4 --system-site-packages /tensorflow

RUN . /tensorflow/bin/activate \
	&& pip3 install --upgrade \
		h5py \
		pydot \
		graphviz \
		tensorflow \
		tensorboard \
		keras
	
# create conda env and install tensorflow as well as keras
RUN conda create python=3.4.2 -n tensorflow
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN . activate tensorflow \
	&& pip install \
		h5py \
		pydot \
		graphviz \
		tensorflow \
		tensorboard \
		keras

# install R packages for tensorflow and keras
RUN install2.r --repos ${CRAN_MIRROR}\
		kerasR \
		png \
	&& R -e 'devtools::install_github("rstudio/tensorflow", ref = "v0.8.2")' # released on 2017-06-12

RUN echo 'options(repos = c(CRAN = "'$CRAN_MIRROR'"), download.file.method = "libcurl")' >> /usr/local/lib/R/etc/Rprofile.site \
	&& echo 'TENSORFLOW_PYTHON = "/tensorflow/bin/python"' >> /usr/local/lib/R/etc/Renviron \
	&& echo 'RETICULATE_PYTHON = "/tensorflow/bin/python"' >> /usr/local/lib/R/etc/Renviron

# Expose port for tensorboard
RUN mkdir /tensorboard_logs
# Start running tensorboard when container is launched

RUN echo '. /tensorflow/bin/activate' >> /init_tensorboard \
    && echo 'tensorboard --logdir=/tensorboard_logs' >> /init_tensorboard \
	&& chmod +x /init_tensorboard

RUN R -e "install.packages(c('leaflet', 'shinydashboard'), repos='https://cloud.r-project.org/')"

# ENTRYPOINT [".", "/tensorflow/bin/activate"]
# ENTRYPOINT ["/init_tensorboard"]
EXPOSE 6006 
EXPOSE 8787 

# Run rocker/rstudio init
ENTRYPOINT ["/init"]
