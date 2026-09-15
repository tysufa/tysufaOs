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
#let title = "Restic Cheatsheet"

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

= Basics
#concept-block[
  #inline("Init")

  To start using restic, you need to create a repo : 
  ```bash
  restic init --repo /path/to/repo
  ```
  this will ask for a password

  #inline("Backing up")
  
  When you want to backup a folder you need to use this command :
  ```bash
  restic --repo /path/to/repo backup folder1 folder2 ... folderN
  ```

  This will backup iteratively without duplicating new data

  #inline("Checking state")

  ```bash
  restic --repo /path/to/repo snapshots
  ```
  This will show all the snapshots (backup command you used) in this repo
  This is also the command you can use if you want to see the size of your backups

  If you want to check the content of the snapshot, you can use this command :
  ```bash
  restic -r /path/to/repo ls latest|073a90db
  ```
  This will list all the files in the snapshot
  you can also specify a directory :
  ```bash
  restic -r /path/to/repo ls latest|073a90db /home
  ```
  This will only list the content of home, its only recursive if you add `--recursive`

  #inline("Restore")

  #inline("Clean up")

  To clean up and keep only the most recent snapshot of each unique bakcup :

  ```bash
  restic forget --keep-last 1 --prune
  ```

  #inline("Send to server")

  To copy a restic repo to a distant server, you can use this command :
  ```bash
  restic -r sftp:tysufa@192.168.1.238:/mnt/storage/Backups/restic copy --from-repo ~/Backup/restic
  ```
]

