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
#let title = "Sched_ext Cheatsheet"

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

= Nixos devenv
#concept-block[
  #inline("Dependances")

  En plus des dépendances classiques, il faudra :

  - bpftools
  - libbpf
  - rustc
  - python3
  - clang
  - pahole
  - zlib
  - llvm

  #inline("Compilation")

  Il faut commencer par ajouter ```nix hardeningDisable = [ "all" ];``` pour desactiver l'injection de \_FORTIFY_SOURCE flag qui cause des warnings (donc des erreurs)

  pour les paramètres à activer dans le `.config` voir `kernel-minimal-config-sched-ext` dans `~/Templates/KernelDev/`

  #inline("executer les binaires")
  Pour que la machine virtuelle est accès 
  le chemin vers `ld-linux-x86-64.so.2` est défini en dur au moment de la compilation, donc sur nixos il est présent dans le nix store et l'execution échoue. Il y a 3 solutions :
  + ```bash /lib64/ld-linux-x86-64.so.2 /mnt/share/scx_simple``` directement depuis la vm
  + ```bash patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 ./share/scx_simple``` dans le host
  + ```bash export LDFLAGS="-Wl,--dynamic-linker=/lib64/ld-linux-x86-64.so.2 $LDFLAGS"``` dans le host, pour compiler directement avec le bon chemin
]

