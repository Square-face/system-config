set -xeo pipefail

host=$1

temp=$(mktemp -d)
cleanup() {
  rm -rf "$temp"
}
trap cleanup EXIT

install -d -m755 "$temp/persist/etc/ssh"

pass hosts/$1/rsa.key > "$temp/persist/etc/ssh/ssh_host_rsa_key"
pass hosts/$1/rsa.pub > "$temp/persist/etc/ssh/ssh_host_rsa_key.pub"

# pass hosts/$1/ecdsa.key > "$temp/persist/etc/ssh/ssh_host_ecdsa_key"
# pass hosts/$1/ecdsa.pub > "$temp/persist/etc/ssh/ssh_host_ecdsa_key.pub"

pass hosts/$1/ed25519.key > "$temp/persist/etc/ssh/ssh_host_ed25519_key"
pass hosts/$1/ed25519.pub > "$temp/persist/etc/ssh/ssh_host_ed25519_key.pub"

chmod 600 "$temp/persist/etc/ssh/ssh_host_rsa_key"
# chmod 600 "$temp/persist/etc/ssh/ssh_host_ecdsa_key"
chmod 600 "$temp/persist/etc/ssh/ssh_host_ed25519_key"


nix run github:nix-community/nixos-anywhere -- \
    --generate-hardware-config nixos-facter ./$1/facter.json \
    --disk-encryption-keys /tmp/disk.pass <(pass hosts/$1/disk-pass) \
    --extra-files "$temp" \
    --flake ".#$1" \
    --target-host $2
