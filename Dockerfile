# SES & nRF Dockerfile

FROM ubuntu:22.04

# Setup Dependencies
RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl wget unzip  python3-pip git zip python3 gcc cmake clang-format usbutils netcat && \
	pip3 install nrfutil

# Setup Screen Config
RUN Xvfb :1 -screen 0 1024x768x16 &

# TODO Setup NRF Tools
#RUN curl https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/nRFCommandLineTools1050Linuxamd64.tar.gz -o nrftools.tar.gz && \
#	tar -zxvf nrftools.tar.gz && \
#	apt-get install -yf ./JLink_Linux_V654c_x86_64.deb && \
#	apt-get install -yf ./nRF-Command-Line-Tools_10_5_0_Linux-amd64.deb && \
#	rm nrftools.tar.gz
#ENV PATH="/mergehex:/nrfjprog:$PATH"

# Setup Embedded Studio
RUN curl https://dl.a.segger.com/embedded-studio/Setup_EmbeddedStudio_ARM_v540c_linux_x64.tar.gz -o ses.tar.gz && \
	tar -zxvf ses.tar.gz && \
	DISPLAY=:1 echo yes | $(find arm_segger_* -name "install_segger*") --copy-files-to /ses && \
	rm ses.tar.gz && \
	rm -rf arm_segger_embedded_studio_*

# Setup Nordic SDK
RUN curl https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v15.x.x/nRF5_SDK_15.0.0_a53641a.zip -o nRF5_SDK_15.0.0_a53641a.zip && \
	unzip nRF5_SDK_15.0.0_a53641a.zip && \
	rm nRF5_SDK_15.0.0_a53641a.zip

# Verify Version Requirements 
ADD ./requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

RUN chmod -R 777 /nRF5_SDK_15.0.0_a53641a
# Start Segger Build Program and Bash Shell
CMD ["/bin/bash"]
