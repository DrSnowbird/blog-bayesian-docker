FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

############################# 
#### ---- Install Target ----
############################# 

ARG INSTALL_DIR=${INSTALL_DIR:-/usr}

ARG TARGET_VER=${TARGET_VER:-0.10}
ARG TARGET_TGZ=${TARGET_TGZ:-blog-${TARGET_VER}.zip}
ARG TARGET_URL=${TARGET_URL:-https://bayesianlogic.github.io/download/${TARGET_TGZ}}
ARG TARGET_HOME=${TARGET_HOME:-${INSTALL_DIR}/blog-${TARGET_VER}}
ENV TARGET_HOME=${TARGET_HOME}

ARG TARGET_EXE=${TARGET_HOME}/bin/blog

WORKDIR ${INSTALL_DIR}

RUN sudo wget -c ${TARGET_URL} && \
    sudo unzip ${TARGET_TGZ} && \
    sudo rm ${TARGET_TGZ}
    
RUN sudo ln -s ${TARGET_EXE} /usr/bin/$(basename ${TARGET_EXE}) && \
    ls -al ${TARGET_HOME} 
    
############################# 
#### ---- Install Sublime ----
############################# 

WORKDIR ${INSTALL_DIR}

# https://download.sublimetext.com/sublime_text_3_build_3176_x64.tar.bz2
# https://download.sublimetext.com/sublime_text_build_4107_x64.tar.xz
ARG SUBLIME_VER=${SUBLIME_VER:-4107}
ARG SUBLIME_TGZ=${SUBLIME_TGZ:-sublime_text_build_${SUBLIME_VER}_x64.tar.xz}
ARG SUBLIME_URL=${SUBLIME_URL:-https://download.sublimetext.com/${SUBLIME_TGZ}}

ARG SUBLIME_DIR=${SUBLIME_DIR:-sublime_text}
ENV SUBLIME_DIR=${SUBLIME_DIR}

ENV SUBLIME_HOME=${INSTALL_DIR}/${SUBLIME_DIR}

ARG SUBLIME_EXE=${SUBLIME_HOME}/sublime_text
ENV SUBLIME_EXE=${SUBLIME_EXE}

RUN sudo apt-get update -y && \
    sudo apt-get install gtk+3.0 -y && \
    sudo wget -c ${SUBLIME_URL} && \
    sudo tar -vxf ${SUBLIME_TGZ} && \
    sudo rm ${SUBLIME_TGZ}

RUN ls -al ${SUBLIME_HOME} && \
    ls -al ${TARGET_HOME} && \
    mkdir -p ${HOME}/.config/sublime-text/Packages/User ${HOME}/data ${HOME}/workspace && \
    ls -al ${HOME}/.config

COPY editors/blog-for-sublime/blog* ${HOME}/.config/sublime-text/Packages/User/
COPY example ${HOME}/example
RUN sudo /bin/chown -R ${USER}:${USER} ${HOME}&& \
    ls -al ${HOME}/.config/sublime-text/Packages/User/ && \
    sudo ln -s /usr/bin/blog ${TARGET_HOME} && \
    #sudo ln -s /usr/bin/sublime_text ${SUBLIME_EXE} && \
    find ${HOME}/.config 

################################ 
#### ---- Entrypoint setup ----#
################################
#### --- Copy Entrypoint script in the container ---- ####
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

############################### 
#### ---- Workspace setup ----#
###############################
VOLUME "${HOME}/data"
VOLUME "${HOME}/workspace"
VOLUME "${HOME}/.config"

USER ${USER}
#WORKDIR ${HOME}
WORKDIR ${SUBLIME_HOME}

#ENTRYPOINT "${TARGET_EXE}" "${TARGET_HOME}/example/burglary.blog"
#CMD "${SUBLIME_EXE}","${TARGET_HOME}/example/burglary.blog"]
#CMD "${SUBLIME_EXE} ${TARGET_HOME}/example/burglary.blog"

#RUN echo $HOME

CMD ["/usr/sublime_text/sublime_text", "/usr/blog-0.10/example/burglary.blog"]
#CMD ["/bin/bash", "-c", "${SUBLIME_EXE}", "${TARGET_HOME}/example/burglary.blog"]
#CMD ["/usr/bin/blog", "/home/developer/example/burglary.blog"]
