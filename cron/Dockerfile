#######################################################
#
FROM centos:centos7.7.1908

ENV LANG C.UTF-8 LC_ALL=C.UTF-8
ENV uid=101
ENV gid=101
ENV group=app
ENV user=app
ENV home=/home/${user}
ENV app=testapp
ENV chkrun=chkrun.sh

SHELL ["/bin/bash", "-c"]

########################################
ENV crontab=app.crontab
COPY ${crontab} /tmp/
COPY ${chkrun}  /tmp/
COPY ${app}     /tmp/

RUN \
    yum -y update && \
    yum -y install iproute cronie crontabs && \
    groupadd --gid ${gid} ${group} && useradd --system --gid ${gid} --uid ${uid} ${user} && \
    mkdir -p ${home} && chown -R ${user} ${home} && chgrp -R ${group} ${home} && \
    echo 'export PATH="${HOME}/bin:${PATH}"' >> ${home}/.bashrc && \
    mkdir -p ${home}/bin/ && \
    cp -p /tmp/${chkrun} ${home}/bin/ && chmod +x ${home}/bin/${chkrun} && \
    cp -p /tmp/${app} ${home}/bin/ && chmod +x ${home}/bin/${app} && \
    crontab -u ${user} /tmp/${crontab} && \
    rm -f /tmp/${crontab} /tmp/${chkrun} /tmp/${app}

########################################
CMD /usr/sbin/crond -n

