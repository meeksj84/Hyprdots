#!/bin/bash

flatpak run \
  --env=__NV_PRIME_RENDER_OFFLOAD=1 \
  --env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
  --env=__VK_LAYER_NV_optimus=NVIDIA_only \
  com.valvesoftware.Steam
