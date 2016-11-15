FROM ubuntu:xenial

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

# Stay up-to-date
RUN apt-get update

# Install needed packages
RUN apt-get install -y \
	octave \
	inkscape \
	git

# Clean up
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Install Metabomatching
RUN git clone https://github.com/phnmnl/metabomatching-pre.git /mm-tp/
RUN cp -r /mm-tp/fos /usr/share/fonts/truetype/
RUN fc-cache -f -v

WORKDIR /mm-tp/

# Uncomment the entrypoint in order to use the tool with Galaxy
#ENTRYPOINT ["octave-cli","metabomatching_docker.m"]
