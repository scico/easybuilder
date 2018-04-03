FROM  docker.io/scico/easylmod:centos7

ENV EBDIR /opt/apps

ENV LMOD_VER 7.7.19
ENV DEFAULT_ALLOW_LOADED_MODULES EasyBuild,FPM,Ruby
ENV EASYBUILD_PREFIX ${EBDIR}
ENV EASYBUILD_MODULES_TOOL Lmod

MAINTAINER Lars Melwyn <melwyn (at) scico.io>

USER root
RUN  yum -y update && yum -y install epel-release yum-plugin-ovl && yum -y install createrepo rpm-build libibverbs python-pep8 python-pip zlib-devel openssl-devel libibverbs-devel unzip  &&  pip install -U keyring && yum clean all 
   
USER apps

WORKDIR ${EBDIR}
RUN curl -O https://raw.githubusercontent.com/hpcugent/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  && \
chmod u+x bootstrap_eb.py && source /etc/profile.d/modules.sh && module load lmod && /opt/apps/bootstrap_eb.py ${EBDIR}

RUN source /etc/profile.d/modules.sh && module use -a ${EBDIR}/modules/all && module load EasyBuild && eb FPM-1.3.3-Ruby-2.1.6.eb -r
WORKDIR /home/apps
RUN echo "module use -a "${EBDIR}"/modules/all" >> /home/apps/.bashrc && \
    echo "module load EasyBuild/"${EASYBUILD_VER} >> /home/apps/.bashrc && \ 
    echo "module load FPM" >> /home/apps/.bashrc 

CMD /bin/bash
