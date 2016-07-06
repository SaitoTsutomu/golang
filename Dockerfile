FROM frolvlad/alpine-glibc

ENV GOPATH=/go \
    LANG=C.UTF-8 \
    PATH=/go/bin:/usr/local/go/bin:/opt/conda/bin:$PATH
RUN set -ex && \
    apk add --no-cache libstdc++ && \
    apk add --no-cache --virtual .build-deps musl-dev bash gcc git go tzdata wget zeromq-dev && \
    export GOLANG_VERSION=1.6.2 && \
    export GOLANG_SRC_URL=https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz && \
    export GOLANG_SRC_SHA256=787b0b750d037016a30c6ed05a8a70a91b2e9db4bd9b1a2453aa502a63f1bccc && \
    export MINICONDA=Miniconda3-latest-Linux-x86_64.sh && \
    cp /usr/share/zoneinfo/Japan /etc/localtime && \
    wget -q $GOLANG_SRC_URL -O golang.tar.gz && \
    wget -q https://raw.githubusercontent.com/docker-library/golang/5a84ebfbf3c55674dd6f36c66828c2e7461f2f0b/1.6/alpine/go-wrapper \
            https://raw.githubusercontent.com/docker-library/golang/5a84ebfbf3c55674dd6f36c66828c2e7461f2f0b/1.6/alpine/no-pic.patch \
            https://repo.continuum.io/miniconda/$MINICONDA \
            http://dl.ipafont.ipa.go.jp/IPAexfont/ipaexg00301.zip && \
    chmod 755 go-wrapper && \
    mv go-wrapper /usr/local/bin/ && \
    echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - && \
    tar -C /usr/local -xzf golang.tar.gz && \
    cd /usr/local/go/src && \
    patch -p2 -i /no-pic.patch && \
    export GOROOT_BOOTSTRAP=$(go env GOROOT) && \
    ./make.bash && \
    mkdir -p $GOPATH/src $GOPATH/bin && \
    chmod -R 777 $GOPATH && \
    cd / && \
    bash /$MINICONDA -b -p /opt/conda && \
    conda update -y conda pip setuptools && \
    conda install -y jupyter && \
    unzip -q ipaexg00301.zip && \
    mkdir -p /usr/share/fonts/ && \
    mv /ipaexg00301/ipaexg.ttf /usr/share/fonts/ && \
    ln -s /opt/conda/bin/* /usr/local/bin/ && \
    go get golang.org/x/tools/cmd/goimports && \
    go get -tags zmq_4_x github.com/gophergala2016/gophernotes && \
    mkdir -p ~/.ipython/kernels/gophernotes && \
    cp -r $GOPATH/src/github.com/gophergala2016/gophernotes/kernel/* ~/.ipython/kernels/gophernotes && \
    apk del .build-deps && \
    apk add --no-cache zeromq && \
    find /opt -name __pycache__ | xargs rm -r && \
    rm -rf /root/.[apw]* /$MINICONDA /ipaexg00301* \
        /opt/conda/pkgs/* /golang.tar.gz /no-pic.patch
WORKDIR /root/
ADD go_sample.tgz $WORKDIR
EXPOSE 8888
VOLUME /root/go/
CMD ["sh", "-c", "jupyter notebook --ip=*"]
