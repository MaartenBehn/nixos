{ self, inputs, ... }: {
  flake.modules.nixos.pigman = { modulesPath, lib, config, pkgs, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persistent".neededForBoot = true;

    disko.devices = {
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=4G"
            "mode=755"
          ];
        };
      };

      disk = {
        main = {
          device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S2R6NX0J632695T";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02"; # BIOS boot partition
              };
              esp = {
                name = "ESP";
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "fmask=0022" "dmask=0022" ];
                };
              };
              swap = {
                size = "16G";
                content = {
                  type = "swap";
                  resumeDevice = true;
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/persistent" = {
                      mountOptions = [ "subvol=persistent" "compress=zstd" "noatime" ];
                      mountpoint = "/persistent";
                    };
                    "/nix" = {
                      mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                      mountpoint = "/nix";
                    };
                  };
                };
              };
            };
          };
        };

        data0 = {
          device = "/dev/disk/by-id/ata-APPLE_HDD_HTS545050A7E362_TNS519GY0ZUSRG";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              data0 = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/mnt/Data0";
                };
              };
            };
          };
        };

        data1 = {
          device = "/dev/disk/by-id/ata-ST1000DM003-1ER162_Z4YEP8YA";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              data1 = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/mnt/Data1";
                };
              };
            };
          };
        };
      };
    };

    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        directories = [
          "/etc/nixos"
          "/var/log"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
            how = "symlink";
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key";
            mode = "0600";
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key.pub";
            mode = "0644";
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key";
            mode = "0600";
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key.pub";
            mode = "0644";
          }
        ];

        users.${config.username} = {
          directories = [
            ".ssh"
          ];
          files = [ ];
        };
      };
    };

    # Enables DHCP on each ethernet and wireless interface.
    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.kernelPackages = pkgs.linuxPackages_6_12;
    hardware.nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;

    boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;

  };

  flake.modules.homeManager.pigman = {
    home.sessionVariables.terminal = "kitty";
  };

  hosts.pigman = {
    modules = [
      "core"
      "pigman"
      "networking"
      "networking_vpn"
      "cli"
      "cli-full"
      "nvidia"
      "server_base"
      "server_ssh"
      #"server_ollama"
      "fix_tpm2" 
    ];

    local_ip = "192.168.0.8";
    domains.public = null; 
    domains.local = "local";
    build = {
      remote = true;
      maxJobs = 3;
      speedFactor = 2;
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "nvidia-gpu" ];
      cores = {
        big-parallel = 6;
        base = 12;
      };
    };
  };
}
