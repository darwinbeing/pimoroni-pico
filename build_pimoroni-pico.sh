#!/bin/sh


export PATH=$PWD/arm-gnu-toolchain-12.2.mpacbti-rel1-darwin-x86_64-arm-none-eabi/bin:$PATH

# NAME=inky_frame
# BOARD=PICO_W_INKY
# PICO_BOARD=pico_w

NAME=pico
BOARD=PICO
PICO_BOARD=pico
local_board_dir=false
WORKSPACE=$PWD/workspace-micropython
BOARD_DIR=$WORKSPACE/pimoroni-pico/micropython/board/$BOARD
USER_C_MODULES=$WORKSPACE/pimoroni-pico/micropython/modules/micropython-$NAME.cmake

mkdir -p $WORKSPACE
cd $WORKSPACE
git clone https://github.com/micropython/micropython.git
git clone https://github.com/darwinbeing/pimoroni-pico.git

cd $WORKSPACE/micropython
git submodule update --init
cd $WORKSPACE/micropython/lib/pico-sdk
git submodule update --init
cd $WORKSPACE/pimoroni-pico
git submodule update --init --recursive

# PICO_W_ENVIRO PICO_W_INKY patch needed
# cd $WORKSPACE/micropython
# $WORKSPACE/pimoroni-pico/micropython/board/pico-sdk-patch.sh $BOARD


cd $WORKSPACE/micropython/mpy-cross
make -j4

cd $WORKSPACE/pimoroni-pico
cmake $WORKSPACE/pimoroni-pico -DBOARD=$BOARD -DPICO_SDK_PATH=$WORKSPACE/micropython/lib/pico-sdk -DPICO_BOARD=$PICO_BOARD
make BOARD=$BOARD -j4

cd $WORKSPACE/micropython/ports/rp2
if [ "$local_board_dir" = true ] ; then
    echo 'Be careful not to fall off!'
    make BOARD=$BOARD BOARD_DIR=$BOARD_DIR submodules -j4
    make BOARD=$BOARD BOARD_DIR=$BOARD_DIR USER_C_MODULES=$USER_C_MODULES -j4
else
    make BOARD=$BOARD submodules -j4
    make BOARD=$BOARD USER_C_MODULES=$USER_C_MODULES -j4
fi
