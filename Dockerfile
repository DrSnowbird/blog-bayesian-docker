FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG INSTALL_DIR=${INSTALL_DIR:-/opt}

ARG TARGET_VER=${TARGET_VER:-0.10}
ARG TARGET_TGZ=${TARGET_TGZ:-blog-${TARGET_VER}.zip}
ARG TARGET_URL=${TARGET_URL:-https://bayesianlogic.github.io/download/${TARGET_TGZ}}
ARG TARGET_HOME=${TARGET_HOME:-${INSTALL_DIR}/blog-${TARGET_VER}}
ENV TARGET_HOME=${TARGET_HOME}

ARG TARGET_EXE=${TARGET_HOME}/bin/blog

############################# 
#### ---- Install Target ----
############################# 
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
ARG SUBLIME_VER=${SUBLIME_VER:-3176}
ARG SUBLIME_TGZ=${SUBLIME_TGZ:-sublime_text_3_build_${SUBLIME_VER}_x64.tar.bz2}
ARG SUBLIME_URL=${SUBLIME_URL:-https://download.sublimetext.com/${SUBLIME_TGZ}}

ARG SUBLIME_DIR=${SUBLIME_DIR:-sublime_text_3}
ENV SUBLIME_DIR=${SUBLIME_DIR}

ARG SUBLIME_EXE=${SUBLIME_EXE:-${INSTALL_DIR}/${SUBLIME_DIR}/sublime_text}
ENV SUBLIME_EXE=${SUBLIME_EXE}

RUN \
    sudo apt-get update -y && \
    sudo apt-get install gtk+3.0 -y && \
    sudo wget -c ${SUBLIME_URL} && \
    sudo tar -vxjf ${SUBLIME_TGZ} && \
    sudo rm ${SUBLIME_TGZ}

RUN ls -al ${INSTALL_DIR}/${SUBLIME_DIR} && \
    ls -al ${TARGET_HOME} && \
    mkdir -p ${HOME}/.config/sublime-text-3/Packages/User ${HOME}/data ${HOME}/workspace && \
    ls -al ${HOME}/.config

COPY editors/blog-for-sublime/blog* ${HOME}/.config/sublime-text-3/Packages/User/
RUN sudo /bin/chown -R ${USER_ID}:${USER_ID} ${HOME}/.config ${HOME}/data ${HOME}/workspace && \
    ls -al ${HOME}/.config/sublime-text-3/Packages/User/ && \
    find ${HOME}/.config 

############################# 
#### ---- Workspace setup ----
############################# 
USER "${USER_NAME}"

VOLUME "${HOME}/data"
VOLUME "${HOME}/workspace"
VOLUME "${HOME}/.config"

WORKDIR ${HOME}/workspace

#ENTRYPOINT "${TARGET_EXE}" "${TARGET_HOME}/example/burglary.blog"

#RUN echo $HOME
CMD "${SUBLIME_EXE}" "${TARGET_HOME}/example/burglary.blog"
