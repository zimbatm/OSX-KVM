
## NixOS configuration

Add this to install QEMU and create the `virbr0` interface. We are not going to use libvirt really at the moment.

```nix
{
  libvirt.enable = true
}
```

After every reboot, re-link the bridge:

```
sudo ip tuntap add dev tap0 mode tap
sudo ip link set tap0 up promisc on
sudo brctl addif virbr0 tap0
```


ssh -L 5905:localhost:5905

vinagre localhost:5905

# How to exit vinagre? Try F10


## MacOS setup

### How to set clover timeout?

https://www.tonymacx86.com/threads/how-to-set-clover-to-automatically-boot-system-drive.174322/

## Misc

OVMF_VARS-1024x768.fd gets changed

