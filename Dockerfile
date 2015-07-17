FROM spacediver/python

# By default, squid-deb-proxy 403s unknown sources, so apt shouldn't proxy ppa.launchpad.net
RUN route -n | awk '/^0.0.0.0/ {print $2}' > /tmp/host_ip.txt
RUN echo "HEAD /" | nc `cat /tmp/host_ip.txt` 8000 | grep squid-deb-proxy \
  && (echo "Acquire::http::Proxy \"http://$(cat /tmp/host_ip.txt):8000\";" > /etc/apt/apt.conf.d/30proxy) \
  && (echo "Acquire::http::Proxy::ppa.launchpad.net DIRECT;" >> /etc/apt/apt.conf.d/30proxy) \
  || echo "No squid-deb-proxy detected on docker host"


RUN apt-get update
RUN apt-get install -y python-setuptools python-dev software-properties-common

RUN sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
RUN apt-get update

RUN easy_install pip

RUN pip install ipython==3.1.0
RUN pip install nose==1.3.6
RUN pip install py==1.4.26
RUN pip install pycrypto==2.6.1
RUN pip install pyinotify==0.9.5
RUN pip install pytest==2.7.0
RUN pip install python-termstyle==0.1.10
RUN pip install rednose==0.4.1
RUN pip install requests==2.5.3
RUN pip install six==1.9.0
RUN pip install sniffer==0.3.5
RUN pip install texttable==0.8.3
RUN pip install websocket-client==0.30.0
RUN pip install selenium==2.46.0

RUN apt-get install -y firefox

RUN sudo apt-get install -y xvfb

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

RUN apt-get install -y chromium-chromedriver
#RUN apt-get install -y wget unzip
#RUN wget http://chromedriver.storage.googleapis.com/2.15/chromedriver_linux64.zip
#RUN unzip chromedriver_linux64.zip
#RUN mv chromedriver /usr/bin
#RUN chmod +x /usr/bin/chromedriver
RUN ln -s /usr/lib/chromium-browser/chromedriver /usr/local/bin

USER developer
ENV HOME /home/developer

