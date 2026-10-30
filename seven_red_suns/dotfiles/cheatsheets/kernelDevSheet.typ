#import "@preview/boxed-sheet:0.1.2": *
#import "@preview/keyle:0.4.0"
//#import "../src/lib.typ": *


// Add reflow: true so the layout box shrinks alongside the visual key
#let smaller = keyle.themes.standard.with(
  text-args: (size: 4pt),
)
#let base-kbd = keyle.config(theme: smaller)

// The font do not exist on this computer

// #set text(font: (
//   "Times New Roman",
//   "SimSun",
// ))

#let homepage = link("https://lzhms.github.io/")[https://lzhms.github.io/]
#let author = "Phil"
#let title = "Kernel Dev Cheatsheet"

#let my-colors = (
  rgb(190, 149, 196),
  rgb("#f39f71"),
  rgb(102, 155, 188),
  rgb(229, 152, 155),
  rgb("6a4c93"),
  rgb("E0A500"),
  rgb("#934c84"),
  rgb("#934c5a"),
)

#show: boxedsheet.with(
  title: title,           // Title of document
  homepage: homepage,     // Homepage of author
  authors: author,        // Author Name
  write-title: true,      // Writes Title on the first page
  title-align: left,      // Position of titles in concept box
  title-number: true,     // Whether to numbered the title (Default = true)
  title-delta: 2pt,       // Fonts delta for title scaling (Default = 1pt)
  scaling-size: false,    // Whether to scale the titles (Default = false)
  font-size: 5.5pt,       // Size of font (Default = 5.5pt)
  line-skip: 5.5pt,       // Size of line-skip (Default = 5.5pt)
  x-margin: 10pt,         // Margin on x-axis (Default = 30pt)
  y-margin: 30pt,         // Margin on y-axis (Default = 0pt)
  num-columns: 4,         // Number of columns (Default = 5)
  column-gutter: 2pt,     // Space between columns (Default = 4pt)
  numbered-units: false,  // Numbering of units (Default = false)
  color-box: my-colors    // Color scheme of boxes
)
#let kbd(..args) = box(baseline: -15%, base-kbd(..args))

= Setup
#concept-block[
  #inline("Creating an ISO")

  To create this arch iso, you will need `pacman` and `arch-install-scripts`

  + create a empty image with one of these two commands :
    - ```bash qemu-img create lkp-arch.img 4G```
    - ```bash dd if=/dev/zero of=lkp-arch.img bs=1M count=0 seek=4096```

  + Format and mount the file : 
    ```bash
    mkfs.ext4 lkp-arch.img
    sudo mount lkp-arch.img /mnt
    ```
  + We install pacman and the necessary tools on the image :
    ```bash
    sudo mkdir -p /mnt/var/lib/pacman

    sudo env "PATH=$PATH" pacman --root /mnt --config ./.pacman.conf -Sy base kmod iproute2 procps-ng util-linux bash neovim
    ```
    - `kmod` to manipulate modules (rmmod, insmod, etc...)
    - `iproute2` gives access to `ip` command
    - `procps-ng` gives `ps`, `top`, `free`, `sysctl`, ...

  + Finaly we chroot in the machine to set the password and then umount
    ```bash
    sudo arch-chroot /mnt passwd -d root
    sudo umount /mnt
    ```

  #inline("Optionnal")

  If you want to start the tty without having to enter a password, run this small script :
    ```bash
    sudo mkdir -p /mnt/etc/systemd/system/serial-getty@ttyS0.service.d/
    cat << 'EOF' | sudo tee /mnt/etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf
    [Service]
    ExecStart=
    ExecStart=-/sbin/agetty --autologin root --noclear %I $TERM
    EOF
    ```
]

= QEMU
#concept-block[
  #inline("Shortcuts")

  - Quit : #kbd("Ctrl-A", "X")
]
