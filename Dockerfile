FROM tsutomu7/ubuntu-essential

ENV USER=scientist HOME=/home/scientist \
    PATH=/go/bin:$PATH \
    LANG=C.UTF-8 \
    GOPATH=/go \
    DEBIAN_FRONTEND=noninteractive
ADD init.tgz $HOME/.config/nvim
RUN export uid=1000 gid=1000 pswd=scientist && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends sudo ca-certificates \
        libglib2.0-0 libxext6 libsm6 libxrender1 tzdata busybox wget git \
        golang software-properties-common build-essential python3-dev python3-pip && \
    pip3 --no-cache-dir install -U pip setuptools && \
    groupadd -g $gid $USER && \
    useradd -g $USER -G sudo -m -s /bin/bash $USER && \
    echo "$USER:$pswd" | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER && \
    /bin/busybox --install && \
    cp --remove-destination /usr/share/zoneinfo/Japan /etc/localtime && \
    apt-get --purge autoremove -y tzdata && \
    add-apt-repository ppa:neovim-ppa/unstable && \
    apt-get update --fix-missing && \
    apt-get install -y neovim && \
    apt-get clean && \
    update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
    chown ${uid}:${gid} -R $HOME /usr/local && \
    rm -rf /var/lib/apt/lists/*
USER $USER
WORKDIR $HOME
RUN pip3 --no-cache-dir install neovim && \
    vi +PlugInstall +qa
CMD ["/bin/bash"]
