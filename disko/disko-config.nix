{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };

                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["noatime"];
                  };

                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd"];
                  };

                  "/home/wireguard" = {
                    mountOptions = ["compress=zstd"];
                  };

                  "/home/bob" = {
                    mountOptions = ["compress=zstd"];
                  };

                  "/home/charlie" = {
                    mountOptions = ["compress=zstd"];
                  };

                  "/snapshots" = {};

                  "/swap" = {
                    mountpoint = "/.swap";
                    swap.swapfile.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
