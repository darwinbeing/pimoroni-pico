# cmake file for Pimoroni Inky with Raspberry Pi Pico W
set(MICROPY_BOARD PICO_W)

set(MICROPY_PY_LWIP ON)
set(MICROPY_PY_NETWORK_CYW43 ON)

set(MICROPY_FROZEN_MANIFEST ${MICROPY_BOARD_DIR}/manifest.py)
