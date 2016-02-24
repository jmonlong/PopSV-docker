## Pull base image
FROM bioconductor/release_base


#     ______________________   _____ __                                 _________            __ 
#    /  _/ ____/ ____/ ____/  / ___// /_____  _________ _____ ____     / ____/ (_)__  ____  / /_
#    / // /   / / __/ /       \__ \/ __/ __ \/ ___/ __ `/ __ `/ _ \   / /   / / / _ \/ __ \/ __/
#  _/ // /___/ /_/ / /___    ___/ / /_/ /_/ / /  / /_/ / /_/ /  __/  / /___/ / /  __/ / / / /_  
# /___/\____/\____/\____/   /____/\__/\____/_/   \__,_/\__, /\___/   \____/_/_/\___/_/ /_/\__/  
#                                                    /____/                                    
# Banner @ http://goo.gl/VCY0tD

WORKDIR /

#
# Update apt, add FUSE support and basic command line tools
#

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y libfuse-dev fuse curl wget software-properties-common
  
#
# Install Oracle JDK 8
#

RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get upgrade -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y \
    oracle-java8-installer \
    oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# 
# Install latest version of storage client distribution
#

RUN mkdir -p /icgc/icgc-storage-client && \
    cd /icgc/icgc-storage-client && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/dcc-release/org/icgc/dcc/icgc-storage-client/[RELEASE]/icgc-storage-client-[RELEASE]-dist.tar.gz | \
    tar xvz --strip-components 1



## Install Emacs
RUN apt-get update && \
  apt-get install -y emacs


#     ____                _____ _    __
#    / __ \ ____   ____  / ___/| |  / /
#   / /_/ // __ \ / __ \ \__ \ | | / / 
#  / ____// /_/ // /_/ /___/ / | |/ /  
# /_/     \____// .___//____/  |___/   
#              /_/                     
#
# Banner at http://patorjk.com/software/taag/#p=display&h=1&v=2&f=Slant&t=PopSV

## Install required packages
RUN install2.r --error \
    -r "https://cran.rstudio.com" \
    -r "http://www.bioconductor.org/packages/release/bioc" \
    devtools \
    Rsamtools \
    DNAcopy \
    BatchJobs \
  && installGithub.r jmonlong/PopSV \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Set working directory
WORKDIR /root

## Copy useful genome binning (in order to avoid installing heavy BSgenome.Hsapiens.UCSC.hg19)
COPY bins-500bp.RData ./
COPY bins-1kbp.RData ./
COPY bins-2kbp.RData ./
COPY bins-5kbp.RData ./

## Clone GitHub Repo
RUN git clone https://github.com/jmonlong/PopSV.git -b icgc


## Install ESS mode
RUN git clone https://github.com/emacs-ess/ESS.git /root/.emacs.d/lisp/ess
COPY .emacs /root/
