FROM node:18.16.0-bullseye

RUN cd /tmp && \
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    zcat < install-tl-unx.tar.gz | tar xf - && \
    rm install-tl-unx.tar.gz && \
    cd install-tl-* && \
    perl ./install-tl --no-interaction --no-doc-install --no-src-install --scheme full

ENV PORT=8990

#RUN tlmgr install make4ht luaxml tex4ht environ trimspaces comment picture pict2e \
#    textgreek gensymb stix babel-greek cbfonts-fd dvisvgm lm tex-gyre kastrup \
#    luacode dvipng tree-dvips

# Fix openjre installation isssue
RUN mkdir -p /usr/share/man/man1

RUN apt-get update && \
    apt-get install --yes -y --no-install-recommends \
    python3-pygments python3-setuptools lua5.4 \
    pandoc default-jre-headless zip && \
    apt-get autoclean && apt-get --purge --yes autoremove && \
    # rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    git clone https://github.com/michal-h21/make4ht && \
    cd make4ht && \
    make justinstall SUDO=""

ENTRYPOINT ["/bin/bash"]