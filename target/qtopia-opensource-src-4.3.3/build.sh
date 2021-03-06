#!/bin/sh
#
#
GCC_VER=4.4.4
cd $HOME/maxwit/toolchain/usr/${TARGET_PLAT}/include/c++/${GCC_VER}/bits && mv locale_classes.tcc locale_classes.tcc.bak &&
sed -e "89,116s/dynamic_cast/static_cast/g" locale_classes.tcc.bak >locale_classes.tcc && cd - ||exit 1

cd ../qtopia-opensource-src-4.3.3 && \
sed -i '976 s/QPhoneProfile::Schedule::Schedule/QPhoneProfile::Schedule/' src/libraries/qtopia/qphoneprofile.cpp && \
sed -i '130 s/\(.*O_CREAT | O_WRONLY\).*);/\1, 0777);/g' src/libraries/qtopiabase/qmemoryfile_unix.cpp && \
cd ../qtopia-opensource-src-4.3.3-build \
||exit 1

echo "yes"| ../qtopia-opensource-src-4.3.3/configure \
	-release -image ${ROOTFS_PATH}/opt/qtopia \
	-prefix /opt/qtopia \
	-xplatform linux-arm-g++ \
	-arch arm -no-qvfb \
	-displaysize 240x320 -no-modem \
	-extra-qt-config "-little-endian" \
	-extra-qtopiacore-config \
    "-release -xplatform qws/linux-arm-g++ -embedded arm -qconfig qpe -depths 8,16,32 -qt-sql-sqlite -qt-kbd-usb -no-kbd-tty -no-mouse-linuxtp -qt-mouse-tslib -qt-gfx-transformed" \
    || exit 1
make && make install|| exit 1

## copy timezone info
cp -r ${HOME}/maxwit/toolchain/usr/share/zoneinfo/ ${ROOTFS_PATH}/usr/share/

## copy config && startup file
mkdir -pv ${ROOTFS_PATH}/etc/init.d &&
cp -v `dirname $0`/qtopia.sh ${ROOTFS_PATH}/etc/init.d/ || exit 1

## FIXME!
## can't set $PATH in busybox
cd ${ROOTFS_PATH}/usr/bin &&
ln -svf ../../opt/qtopia/bin/* . &&
cd - || exit 1

cd $HOME/maxwit/toolchain/usr/${TARGET_PLAT}/include/c++/${GCC_VER}/bits && mv locale_classes.tcc.bak locale_classes.tcc && cd - || exit 1
