FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
	cmake \
	git \
	locales \
	python3-pip \
	enchant

RUN pip3 install \
	sphinx_rtd_theme \
	sphinxcontrib-actdiag \
	sphinxcontrib-blockdiag \
	sphinxcontrib-manpage \
	sphinxcontrib-seqdiag \
	sphinxcontrib-spelling

RUN rm -rf /var/lib/apt/lists/*

# Add support for UTF-8 when spellchecking.

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
