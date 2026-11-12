{...}: {
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # open source drivers
    # powermanagement needs offload to be true
    # powerManagement.enable = true;
    # powerManagement.finegrained = true; # Enables deep sleep for the 4080 when offloading

    prime.sync.enable = false;
    prime = {
      # nvidia-offload %command% to activate nvidia gpu when offload mod is on
      offload = {
        enable = false;
        enableOffloadCmd = false;
      };

      # FIX: Wrapped these in quotation marks ""
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.xone.enable = true;

  hardware.bluetooth.enable = true;

  hardware.i2c.enable = true;
}
