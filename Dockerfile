# SES & nRF Dockerfile

FROM ubuntu:22.04

# Setup Dependencies
RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl wget unzip  python3-pip git zip python3 gcc cmake clang-format usbutils netcat && \
	pip3 install nrfutil

# Setup Screen Config
RUN Xvfb :1 -screen 0 1024x768x16 &

# Setup NRF Tools
RUN curl https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-24-0/nrf-command-line-tools-10.24.0_linux-amd64.tar.gz -o nrftools.tar.gz && \
	tar -zxvf nrftools.tar.gz && \
        mkdir /opt/SEGGER && \
        tar xzf JLink_*.tgz -C /opt/SEGGER && \
        mv /opt/SEGGER/JLink* /opt/SEGGER/JLink && \
        cp -r ./nrf-command-line-tools /opt && \
        ln -s /opt/nrf-command-line-tools/bin/nrfjprog /usr/local/bin/nrfjprog && \
        ln -s /opt/nrf-command-line-tools/bin/mergehex /usr/local/bin/mergehex && \
	rm nrftools.tar.gz

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
