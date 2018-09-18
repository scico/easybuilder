FROM docker.io/scico/easylmod:7.5.1804

ENV EB_DIR /opt/apps
ENV EB_VER 3.6.2 
ENV EASYBUILD_MODULES_TOOL Lmod
ENV EASYBUILD_PREFIX=/opt/apps
ENV LMOD_VER 7.8.2  

MAINTAINER Lars Melwyn <melwyn (at) scico.io>

USER apps

WORKDIR ${EB_DIR}
RUN curl -O https://raw.githubusercontent.com/hpcugent/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  && \
           chmod u+x bootstrap_eb.py && source /etc/profile.d/modules.sh && \
           module load lmod && ${EB_DIR}/bootstrap_eb.py ${EB_DIR} 

WORKDIR /home/apps

RUN echo "module use -a "${EB_DIR}"/modules/all" >> /home/apps/.bashrc && \
    echo "module load EasyBuild/"${EB_VER} >> /home/apps/.bashrc  

CMD /bin/bash
