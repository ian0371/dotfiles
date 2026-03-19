FROM nixos/nix:latest

ENV QEMU_OPTS="-nographic"

WORKDIR /workspace

RUN printf '%s\n' \
  'experimental-features = nix-command flakes' \
  'accept-flake-config = true' \
  >> /etc/nix/nix.conf

RUN mkdir -p /var/cache/man/nixpkgs

COPY . .

ENTRYPOINT ["nix", "run", ".#vm", "--"]
