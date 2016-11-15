FROM ubuntu
RUN apt-get update && apt-get install -y \
	octave \
	inkscape \
	git \
	 && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/rrueedi/metabomatching-pre.git /mm-tp/
RUN cp -r /mm-tp/fos /usr/share/fonts/truetype/
RUN fc-cache -f -v
WORKDIR /mm-tp/
ENTRYPOINT ["octave-cli","metabomatching_docker.m"]
