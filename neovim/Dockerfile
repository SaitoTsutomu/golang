FROM tsutomu7/python

ADD init.tgz ~/.config/nvim
USER root
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends ca-certificates \
        golang git software-properties-common gcc make && \
    add-apt-repository ppa:neovim-ppa/unstable && \
    apt-get update --fix-missing && \
    apt-get install -y neovim && \
    update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
    pip install --no-cache-dir neovim && \
    vi +PlugInstall +qa && \
    rm -rf /var/lib/apt/lists/*
USER $USER
ENV GOPATH=/go \
    PATH=/go/bin:$PATH
CMD ["bash"]
