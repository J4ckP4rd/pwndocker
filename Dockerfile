FROM phusion/baseimage:latest
MAINTAINER skysider <skysider@163.com>

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    net-tools \
    libffi-dev \
    libssl-dev \
    python3-pip \
    python-pip \
    python-capstone \
    ruby2.3 \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    netcat \
    socat \
    git \
    patchelf \
    vim \
    man \
    file --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN pip3 install --no-cache-dir \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    p2pipe

RUN pip install --no-cache-dir \
    ropgadget \
    pwntools \
    zio \
    angr && \
    pip install --upgrade pwntools

RUN gem install \
    one_gadget && \
    rm -rf /var/lib/gems/2.3.*/cache/*

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && sed -i s/sudo//g setup.sh && \
    chmod +x setup.sh && ./setup.sh

RUN git clone https://github.com/skysider/LibcSearcher.git LibcSearcher && \
    cd LibcSearcher && git submodule update --init --recursive && \
    python setup.py develop && cd libc-database && ./get || ls

RUN git clone https://github.com/aquynh/capstone && \
    cd capstone && ./make.sh && \
    cd cstool && cp cstool /usr/local/bin/

RUN git clone https://github.com/keystone-engine/keystone && \
    cd keystone && mkdir build && cd build && ../make-share.sh && \
    cd kstool && cp kstool /usr/local/bin/
    
RUN wget https://gist.githubusercontent.com/J4ckP4rd/b2a1a3da5697c292d14985d048e88b5b/raw/3850c712ccdbd75a65991f15f706ec8077fc7522/.vimrc -O ~/.vimrc

COPY linux_server linux_server64 /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64

WORKDIR /ctf/work/

ENTRYPOINT ["/bin/bash"]
