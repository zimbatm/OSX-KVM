#!/usr/bin/env bash

# See https://www.mail-archive.com/qemu-devel@nongnu.org/msg471657.html thread.
#
# The "pc-q35-2.4" machine type was changed to "pc-q35-2.9" on 06-August-2017.
#
# The "media=cdrom" part is needed to make Clover recognize the bootable ISO
# image.

##################################################################################
# NOTE: Comment out the "MY_OPTIONS" line in case you are having booting problems!
##################################################################################

MY_OPTIONS="+aes,+xsave,+avx,+xsaveopt,avx2,+smep"

# Don't try to bind the audio on the host
export QEMU_AUDIO_DRV=none

typeset -i drive=0

opts=(
  # Make it fast
  -enable-kvm

  # CPU
  -cpu "Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS"

  -smp 24 #8,cores=4
  #-smp 4,cores=2

  # Memory
  -m 100G

  # Inputs
  -usb -device usb-kbd -device usb-tablet

  # Hardware
  -machine pc-q35-2.9
  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
  -drive if=pflash,format=raw,readonly,file=OVMF_CODE.fd
  -drive if=pflash,format=raw,file=OVMF_VARS-1024x768.fd
  -smbios type=2

  # Sound
  -device ich9-intel-hda -device hda-duplex

  # Networking
  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27

  # Display
  -display vnc=localhost:5

  -monitor stdio
)

# For some reason it won't boot without the ISO. Some times.
opts+=(
  -device ide-drive,bus=ide.$drive,drive=MacDVD
  -drive id=MacDVD,if=none,snapshot=on,media=cdrom,file=./'HighSierra-10.13.5.iso'
)
((drive++))

opts+=(
  -device ide-drive,bus=ide.$drive,drive=Clover
  -drive id=Clover,if=none,snapshot=on,format=qcow2,file=./'Clover.qcow2'
)
((drive++))

opts+=(
  -device ide-drive,bus=ide.$drive,drive=MacHDD
  -drive id=MacHDD,if=none,file=./mac_hdd.img,format=qcow2
)
((drive++))

set -x
qemu-system-x86_64 "${opts[@]}"
