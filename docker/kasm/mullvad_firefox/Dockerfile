ARG BASE_TAG="1.15.0"
FROM kasmweb/ubuntu-focal-desktop:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install wireguard
RUN apt-get update && \
apt-get install -y wireguard-tools iproute2 openresolv procps curl && \
rm -rf /var/lib/apt/lists/* 

COPY wg.conf /etc/wireguard/wg0.conf 

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
