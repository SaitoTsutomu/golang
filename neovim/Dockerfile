FROM tsutomu7/python

ADD init.tgz ~/.config/nvim
RUN sudo apt-get update --fix-missing && \
    sudo apt-get install -y --no-install-recommends ca-certificates \
        golang git software-properties-common gcc make && \
    sudo add-apt-repository ppa:neovim-ppa/unstable && \
    sudo apt-get update --fix-missing && \
    sudo apt-get install -y neovim && \
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
    pip install --no-cache-dir neovim && \
    vi +PlugInstall +qa && \
    rm -rf /var/lib/apt/lists/*
ENV GOPATH=/go \
    PATH=/go/bin:$PATH
CMD ["bash"]
