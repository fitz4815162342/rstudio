FROM rocker/rstudio:latest

RUN mkdir -p "/home/rstudio/persistent" && chmod -R 777 "/home/rstudio/persistent"

VOLUME home/rstudio/persistent 

WORKDIR /home/rstudio/persistent


RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev libcairo2-dev libsqlite3-dev libmariadbd-dev \ 
  libmariadb-client-lgpl-dev libpq-dev libssh2-1-dev unixodbc-dev \
  && R -e "source('https://bioconductor.org/biocLite.R')" && install2.r --error \
    --deps TRUE tidyverse dplyr devtools formatR remotes selectr caTools

ENV PATH=$PATH:/opt/TinyTeX/bin/x86_64-linux/

RUN wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb && rm texlive-local.deb \
  && apt-get update && apt-get install -y --no-install-recommends \
  default-jdk fonts-roboto ghostscript libbz2-dev libicu-dev liblzma-dev \
  libhunspell-dev libmagick++-dev librdf0-dev libv8-dev qpdf texinfo ssh nano less \
  && apt-get clean && rm -rf /var/lib/apt/lists/ && install2.r --error tinytex \
  && R -e "tinytex::install_tinytex(dir = '/opt/TinyTeX')" \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && tlmgr install metafont mfware inconsolata tex ae parskip listings \
  && tlmgr path add && Rscript -e "tinytex::r_texmf()" \
  && chown -R root:staff /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  && install2.r --error --repo http://rforge.net PKI \
  && install2.r --error --deps TRUE bookdown rticles rmdshower

RUN R -e "install.packages(c('party', 'partykit', 'gbm', 'data.table', 'mltools', 'dict', 'shiny', 'rmarkdown', 'plotly', 'rhandsontable', 'caret', 'e1071', 'randomForest', 'dplyr'), repos='https://cloud.r-project.org/')"
