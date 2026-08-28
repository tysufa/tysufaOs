{...}: {
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # Enables deep sleep for the 4080 when not offloading

    prime = {
      # nvidia-offload %command% to activate nvidia gpu when offload mod is on
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # FIX: Wrapped these in quotation marks ""
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.xone.enable = true;

  hardware.bluetooth.enable = true;
}
