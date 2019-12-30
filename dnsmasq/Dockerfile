#######################################################
#
FROM centos:centos7.7.1908

ENV LANG C.UTF-8 LC_ALL=C.UTF-8
ENV uid=101
ENV gid=101
ENV group=app
ENV user=app
ENV home=/home/${user}
ENV chkrun=chkrun.sh

SHELL ["/bin/bash", "-c"]

########################################
ENV crontab=dnsmasq.crontab
COPY ${crontab} /tmp/
COPY ${chkrun}  /tmp/

RUN \
    yum -y update && \
    yum -y install iproute cronie crontabs && \
    groupadd --gid ${gid} ${group} && useradd --system --gid ${gid} --uid ${uid} ${user} && \
    mkdir -p ${home} && chown -R ${user} ${home} && chgrp -R ${group} ${home} && \
    echo 'export PATH="${HOME}/bin:${PATH}"' >> ${home}/.bashrc && \
    mkdir -p ${home}/bin ${home}/etc ${home}/var && \
    chown ${user}  ${home}/bin ${home}/etc ${home}/var && \
    chgrp ${group} ${home}/bin ${home}/etc ${home}/var && \
    cp -p /tmp/${chkrun} ${home}/bin/ && chmod +x ${home}/bin/${chkrun} && \
    rm -f /tmp/${crontab} /tmp/${chkrun}


########################################
ENV dnsmasq_conf=dnsmasq.conf
ENV hosts=hosts.dnsmasq
COPY ${dnsmasq_conf}     /tmp/dnsmasq.conf
COPY ${hosts}            /tmp/hosts
COPY ${crontab} /tmp/root.crontab

RUN \
    yum -y install dnsmasq && \
    cp -p /tmp/dnsmasq.conf /etc/dnsmasq.conf && \
    cp -p /tmp/hosts ${home}/etc/hosts && \
    crontab /tmp/root.crontab && \
    echo "echo nameserver 127.0.0.1 > /etc/resolv.conf" >  ${home}/etc/init.sh && \
    echo "cat ${home}/etc/hosts >> /etc/hosts"          >> ${home}/etc/init.sh && \
    rm -f /tmp/dnsmasq.conf /tmp/hosts /tmp/root.crontab


########################################
CMD /bin/bash ${home}/etc/init.sh && \
    /usr/sbin/crond -n

