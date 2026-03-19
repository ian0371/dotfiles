{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = (import ../../pkgs { inherit pkgs; }) // {
        vm = pkgs.writeShellApplication {
          name = "vm";
          text =
            let
              host =
                if
                  pkgs.stdenv.hostPlatform.system == "aarch64-darwin"
                  || pkgs.stdenv.hostPlatform.system == "aarch64-linux"
                then
                  inputs.self.nixosConfigurations.igloo-aarch64-linux.config
                else
                  inputs.self.nixosConfigurations.igloo.config;
            in
            ''
              ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
            '';
        };
      };
    };
}
