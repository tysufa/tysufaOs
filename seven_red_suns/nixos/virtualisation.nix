{pkgs, ...} :
let 
gpuIDs = [
    "10de:2860" # VGA / 3D Controller
    "10de:22bd" # Audio Controller
  ] ;

in
{
# 1. Enable IOMMU & bind GPU to vfio-pci at boot

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "vfio" ];

    boot.kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      ("vfio-pci.ids=" + builtins.concatStringsSep "," gpuIDs)
    ];

    # 2. Force VFIO modules to load in initrd before NVIDIA drivers
    boot.initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    # Blacklist host NVIDIA modules in the VFIO entry so host leaves GPU alone
    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
      "nouveau"
    ];

  };

  # 3. Enable Libvirt, QEMU, OVMF (UEFI), and swtpm (for Windows 11 TPM 2.0)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      vhostUserPackages = with pkgs; [ virtiofsd ]; # allow folders to be shared (virtiofsd needs to be accessible in standard path)

      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # 4. Enable Virt-Manager and SPICE USB Redirection
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
