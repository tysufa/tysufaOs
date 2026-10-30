# Creating an arch iso

```bash
qemu-img create lkp-arch.img 4G # commande alternative : dd if=/dev/zero of=lkp-arch.img bs=1M count=0 seek=4096
mkfs.ext4 lkp-arch.img

sudo mount lkp-arch.img /mnt
# kmod : commandes pour gérer les modules (insmod, rmmod, etc)
# iproute2 : fournis la commande ip
# procps-ng : fournis les commandes ps, top, free, sysctl, vmstat, kill, pgrep

# necessaire pour que pacman accepte d'installer les binaires
sudo mkdir -p /mnt/var/lib/pacman

sudo env "PATH=$PATH" pacman --root /mnt --config ./.pacman.conf -Sy \
  base kmod iproute2 procps-ng util-linux bash neovim

sudo arch-chroot /mnt passwd -d root
sudo umount /mnt


```

## Optionnel

```bash
# Configuration de la console série ttyS0 sans mot de passe
sudo mkdir -p /mnt/etc/systemd/system/serial-getty@ttyS0.service.d/
cat << 'EOF' | sudo tee /mnt/etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I $TERM
EOF
```

# QEMU

## quiter : ctrl-A puis X
