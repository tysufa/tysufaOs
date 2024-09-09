{ pkgs, ... }:
{
  programs = {
    oh-my-posh = {
      enable = true;
      useTheme = "catppuccin_mocha";
      settings = {
        schema= "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
        final_space= true;
        version= 2;
        blocks=[{
          type = "prompt";
          alignment= "left";
          newline = true;
          segments=[{
            type= "path";
            style= "plain";
            background = "transparent";
            foreground = "blue";
            template = "{{ .Path }}";
            properties = {
              style= "full";
            };
          }
          {
            type = "git";
            style = "plain";
            foreground = "p:grey";
            background = "transparent";
            template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
            properties = {
              branch_icon = "";
              commit_icon = "@";
              fetch_status = true;
            };
          }];
        }
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [{
            type = "text";
            style = "plain";
            foreground = "magenta";
            background = "transparent";
            template = "❯";
          }];
        }
        {
          foreground = "magenta";
          background = "transparent";
          template = "❯ ";
        }];
        transient_prompt = {
          foreground = "magenta";
          background = "transparent";
          template = "❯ ";
        };
      };
    };
  };
}
