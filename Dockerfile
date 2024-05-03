###########################################################
# Dockerfile that builds a Project Zomboid Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

RUN set -x \
    && groupadd -g 1008 -o pzuser \
    && useradd -g 1008 -u 1008 -oms /bin/bash pzuser \
	&& mkdir /opt/pzserver \
    && chown pzuser:pzuser /opt/pzserver

COPY --chown=pzuser:pzuser update_zomboid.txt /home/pzuser/update_zomboid.txt

FROM build_stage AS bullseye-base

USER pzuser
WORKDIR /opt/pzserver
RUN bash "${STEAMCMDDIR}/steamcmd.sh" +runscript /home/pzuser/update_zomboid.txt
ENTRYPOINT ["bash", "/opt/pzserver/start-server.sh"]

EXPOSE 16261/udp
EXPOSE 16262/udp

