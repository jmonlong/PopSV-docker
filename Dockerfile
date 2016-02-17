## Pull base image
FROM bioconductor/release_core

RUN install2.r --error \
    -r "https://cran.rstudio.com" \
    -r "http://www.bioconductor.org/packages/release/bioc" \
    data.table \
    dplyr \
    outliers \
    fdrtool \
    DNAcopy \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

COPY PopSV_1.0.tar.gz .

RUN R CMD INSTALL PopSV_1.0.tar.gz 