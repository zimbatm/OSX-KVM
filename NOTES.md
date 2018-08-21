# Nix and OSX-KVM

Install NixOS and add the configuration:

## NixOS configuration

Add this to install QEMU and create the `virbr0` interface. We are not using
libvirt but it installs qemu-kvm and virbr0.

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

After that the VM is ready to boot.

Run `./boot.sh`

## VNC Connection

In one terminal run
```
ssh -L 5905:localhost:5905
```

and then in another one:
```
vinagre localhost:5905
```

## MacOS setup

The nixos user is configured to login automatically.

The sudo password is `nixos`.

## FAQ

* How to exit vinagre? Try F10 or the Meta key.
* OVMF_VARS-1024x768.fd gets changed because it contains the nvram parameters

## TODO

* Document the macOS setup
* Make the VM boot automatically, don't get stuck on Clover

https://www.tonymacx86.com/threads/how-to-set-clover-to-automatically-boot-system-drive.174322/

* Automate the macOS installation
* Distribute the HighSierra.iso
* Secure the guest against Nix fetcher builds SSH nixos/nixos access
* Document the setup to become a remote builder, proxied through the host

