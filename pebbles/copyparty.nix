{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];


    copyparty = {
	enable = true;

	user = "copyparty"; 
	# the group to run the service as
	group = "copyparty"; 

	settings = {
	    i = "0.0.0.0";
	    # use lists to set multiple values
	    p = [ 3210 3211 ];
	    # use booleans to set binary flags
	    no-reload = true;
	    # using 'false' will do nothing and omit the value when generating a config
	    ignored-flag = false;
	};

	volumes = {
	    "/" = {
	        path = "/mnt/storage/test";
		access = { rw = "*"; };
	    };
	};
    };
}
