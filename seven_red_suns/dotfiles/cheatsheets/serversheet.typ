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
#let title = "Server Cheatsheet"

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

= Adresses et liens
#concept-block[
  #inline("Adresses ip")

  adresse ip local : http://192.168.1.238

  adresse ip tailscale : http://100.79.190.77/

  #inline("Ports")

  - homepage : 8082 | http://192.168.1.238:8082 | https://tysufa.com
  - immich : 2283 | http://192.168.1.238:2283
  - zotero/webdav : 8083 | http://100.79.190.77/ | https://zotero.tysufa.com
  

]
= Tunnel cloudflare
#concept-block[
  gerer les tunnels sur #link("https://dash.cloudflare.com/ae467bacb28e34740f53a8156fe8cafb/tunnels/02a95328-146a-4b11-b777-e5c520d54058/overview")[cloudflare]

  #inline("Connecter un tunnel sur nixos")

  copier le token (format : eyJhIjoi#"********************"eCJ9)
  puis executer cette commande pour obtenir 3 secrets :
  ```bash echo "eyJhIjoi********************eCJ9" | base64 -d```

  placer ensuite les 3 secrets dans les champs suivants :
  - "AccountTag" ("a")
  - "TunnelID" ("t")
  - "TunnelSecret" ("s")

  que l'on peut modifier avec la commande ```bash nix-shell -p sops --run "sops secrets/secrets.yaml"```

  
]

= Sops
#concept-block[
  The secrets are written in the folder only accessible by root `/run/secrets`

  Whenever you want to add a secret using sops, there are 3 steps :
    + Add it into sops.nix
      ```nix
        secrets."nomdossier/nomfichier" = {
          owner = "root";
          group = "root";
          mode = "0400";
        };
      ```
      You can also leave the { } empty, to get the same result (probably) by default

    + Edit the secrets.yaml file with this command
      ```bash
      nix-shell -p sops --run "EDITOR=nvim sops secrets/secrets.yaml"
      ```

    + Finally you can access the secret in the nix config 
      ```nix
        passwordFile = config.sops.secrets."nomdossier/nomfichier".path;
      ```


]

= Backups
#concept-block[

  #inline("exporting local backups")

  to backup a restic directory from a local machine to a distant one : 
  ```bash restic -r sftp:tysufa@192.168.1.238:/mnt/storage/Backups/restic copy --from-repo /local/restic/repo```

  #inline("Automaticaly backing up server to external drives")

  This code adds a udev rule to automatically call our systemd service when the specified hard drive (ID_FS_LABEL="offline-backup") is connected to the server
  ```nix
services.udev.extraRules = ''                                                                                                                          
   ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_LABEL}=="offline-backup", TAG+="systemd", ENV{SYSTEMD_WANTS}+="restic-external-backup.service"          
'';
  ```

  The job of our systemd service is to :
  + Mount the hdd on the server
  + Execute the restic backup commands on all the folders we want to backup
    ```bash ${pkgs.restic}/bin/restic -r $RESTIC_REPOSITORY backup /mnt/storage/zotero/ /mnt/storage/shared-files/ /mnt/storage/audiobookshelf/```
  + Unmount the hdd and warn the user that everything is over and so the hdd can be unplugged


  #inline("restic service")

  there is a restic service that saves daily :
  - zotero
  - immich
]


= Services
#concept-block[

  #inline("immich")

  #inline("audiobookshelf")

  #inline("homepage")

  #inline("copyparty")
]

#concept-block[
  #inline("zotero")

  Zotero is managed via an online account, but the files are stored in a webdav

  The credentials for the webdav are stored in sops and then used as environment variables (`ZOTERO_WEBDAV_USER` and `ZOTERO_WEBDAV_PASSWD`)

  You can access it via port 8083, this webdav is mapping `/mnt/storage/zotero`
]


