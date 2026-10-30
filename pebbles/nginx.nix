{ config, pkgs, ... }:

let
  # Reusable IP restriction block for private services
privateAccessControl = ''
    # Allow local home network (your Wi-Fi devices)
    allow 192.168.1.0/24;

    # Allow all Tailscale devices
    allow 100.64.0.0/10;

    # Allow server self-requests
    allow 127.0.0.1;
    allow ::1;

    # Deny all public internet traffic
    deny all;
  '';
in
{

  # ACME / Let's Encrypt Configuration
  security.acme = {
    acceptTerms = true;
    defaults.email = "cowaseg@protonmail.com"; # Replace with your email for expiration alerts

    certs."tysufa.com" = {
      domain = "tysufa.com";
      extraDomainNames = [ "*.tysufa.com" ];
      dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets."cloudflare-env".path;
      
      # Allow Nginx to read the generated SSL keys/certificates
      group = config.services.nginx.group;
    };
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    # recommendedOptimizedSettings = true;

    # Increase upload limits for Copyparty / Fireshare
    clientMaxBodySize = "10g";

    virtualHosts = {
      # -------------------------------------------------------------------
      # PUBLIC SERVICES (Accessible to anyone via Cloudflare Tunnel)
      # -------------------------------------------------------------------
      "tysufa.com" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000"; # Your blog/portfolio app port
        };
      };

      "blog.tysufa.com" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };

      # -------------------------------------------------------------------
      # PRIVATE SERVICES (Restricted to LAN & Tailscale only)
      # -------------------------------------------------------------------
      "webdav.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8083";
          proxyWebsockets = true;
        };
      };


      "copyparty.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3210";
          proxyWebsockets = true;
        };
      };

      "kavita.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5000";
          proxyWebsockets = true;
        };
      };


      "fireshare.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8086";
          proxyWebsockets = true;
        };
      };

      "audiobookshelf.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8084";
          proxyWebsockets = true;
        };
      };


      "immich.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2283";
          proxyWebsockets = true;
        };
      };

      "homepage.tysufa.com" = {
        extraConfig = privateAccessControl;
        useACMEHost = "tysufa.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8082";
          proxyWebsockets = true;
        };
      };
    };
  };
  # Open HTTP/HTTPS in host firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
