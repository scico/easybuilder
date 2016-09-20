FROM docker.io/scico/easylmod:centos7

ENV EBDIR /opt/apps

ENV LMOD_VER 6.5.2
ENV EASYBUILD_PREFIX ${EBDIR}
ENV EASYBUILD_MODULES_TOOL Lmod

MAINTAINER Lars Melwyn <melwyn (at) scico.io>

USER root
RUN  yum -y install rpm-build bash-completion python-keyring zlib-devel openssl-devel libibverbs-devel unzip && yum clean all

USER apps

WORKDIR ${EBDIR}

RUN curl -O https://raw.githubusercontent.com/hpcugent/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  && \
chmod u+x bootstrap_eb.py && source /etc/profile.d/modules.sh && module load lmod/6.5.2 && /opt/apps/bootstrap_eb.py ${EBDIR}

RUN source /etc/profile.d/modules.sh && module use -a ${EBDIR}/modules/all && module load EasyBuild && eb FPM-1.3.3-Ruby-2.1.6.eb -r

RUN echo "module use -a "${EBDIR}"/modules/all" >> ${EBDIR}/.bashrc && echo "module load EasyBuild/"${EASYBUILD_VER} >> ${EBDIR}/.bashrc 

CMD /bin/bash
