#!/bin/sh
#

./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	--with-gmp=${1}/usr \
	|| exit 1

make -j2 && \
make DESTDIR=${1} install || exit 1
