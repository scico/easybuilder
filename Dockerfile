FROM docker.io/scico/easylmod:centos7

ENV EBDIR /opt/apps

ENV LMOD_VER 7.0.5  
ENV EASYBUILD_VERSION 3.0.0 
 
ENV EASYBUILD_PREFIX ${EBDIR}
ENV EASYBUILD_MODULES_TOOL Lmod

MAINTAINER Lars Melwyn <melwyn (at) scico.io>

USER root
RUN  yum -y update && yum -y install yum-plugin-ovl && yum -y install rpm-build libibverbs python-keyring zlib-devel openssl-devel libibverbs-devel unzip && yum clean all

USER apps

WORKDIR ${EBDIR}
RUN curl -O https://raw.githubusercontent.com/hpcugent/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  && \
chmod u+x bootstrap_eb.py && source /etc/profile.d/modules.sh && module load lmod/${LMOD_VER} && /opt/apps/bootstrap_eb.py ${EBDIR}

RUN source /etc/profile.d/modules.sh && module use -a ${EBDIR}/modules/all && module load EasyBuild 
WORKDIR /home/apps
RUN echo "module use -a "${EBDIR}"/modules/all" >> /home/apps/.bashrc && \
    echo "module load EasyBuild/"${EASYBUILD_VERSION} >> /home/apps/.bashrc  

CMD /bin/bash
