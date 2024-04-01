{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "steam-mount";
  runtimeInputs = with pkgs; [util-linux steam procps];
  text = ''
      function mount_drive () {
            label="$(${pkgs.util-linux}/bin/lsblk -noLABEL $1)"
            if [ -z "$label" ]; then
              label="$(${pkgs.util-linux}/bin/lsblk -noUUID $1)"
            fi
            mkdir -p "/mnt/$label"
            chown $2:users "/mnt/$label"
            mount "$1" "/mnt/$label"
            sleep 5
            urlencode()
            {
              [ -z "$1" ] || echo -n "$@" | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'
            }
          mount_point="$(lsblk -noMOUNTPOINT $1)"
          if [ -z "$mount_point" ]; then
            echo "Failed to mount "$1" at /mnt/$label"
          else
            mount_point="$mount_point/SteamLibrary"
            url=$(urlencode "''${mount_point}")
            if pgrep -x "steam" > /dev/null; then
              echo "Added Folder to steam library $url"
              systemd-run -M 1000@ --user --collect --wait sh -c "steam 'steam://addlibraryfolder/''${url}'"
            fi
          fi
      }
    if ["$1" = "remove"]; then
    	exit 0
    else
    	mount_drive "/dev/$2" "$3"
    fi
    exit 0;
  '';
}
