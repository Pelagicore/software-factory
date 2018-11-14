FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
	cmake \
	git \
	locales \
	python3-pip \
	enchant \
	plantuml

RUN pip3 install \
	sphinx_rtd_theme \
	sphinxcontrib-actdiag \
	sphinxcontrib-blockdiag \
	sphinxcontrib-plantuml \
	sphinxcontrib-manpage \
	sphinxcontrib-seqdiag \
	sphinxcontrib-spelling

RUN rm -rf /var/lib/apt/lists/*

# Add support for UTF-8 when spellchecking
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
