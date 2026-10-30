{ inputs, config, pkgs, ... }: {

    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    services.copyparty = {
	enable = true;

	# package = pkgs.copyparty.override {
	#    	  extraPackages = [ pkgs.ffmepg_full ];    	
	#    	};

	user = "copyparty"; 
	# the group to run the service as
	group = "copyparty"; 

	settings = {
	    i = "0.0.0.0";
	    # use lists to set multiple values
	    p = [ 3210 ];
	    # use booleans to set binary flags
	    no-reload = true;
	    # using 'false' will do nothing and omit the value when generating a config
	    ignored-flag = false;
	};

	accounts = {
		tysufa = {
		  passwordFile = config.sops.secrets."copyparty/tysufa".path;
		};
	};

	volumes = {
	    "/audiobookshelf" = {
	        path = "/mnt/storage/audiobookshelf/Audiobooks";
		access = { rwmd = ["tysufa"]; };
	    };
	    "/books" = {
	        path = "/mnt/storage/books";
		access = { rwmd = ["tysufa"]; };
	    };

	    "/Documents" = {
	    	path = "/mnt/storage/Documents";
		access = { rw = ["tysufa"]; };
	    };
		#    "/backups" = {
		#        path = "/mnt/storage/Backups";
		# access = { rw = "*"; };
		#    };
	};
    };

    systemd.services.copyparty.path = with pkgs; [ ffmpeg ];
}
