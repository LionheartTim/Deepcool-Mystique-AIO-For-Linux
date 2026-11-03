
#!/usr/bin/env bash
set -Eeuo pipefail

echo "DeepCool MYSTIQUE USB permissions"
echo
echo "This installs host USB access rules for"
echo "DeepCool MYSTIQUE (3633:0009)."
echo "Administrator approval is required."
echo
read -r -p "Install these rules? [y/N] " answer

case "$answer" in
    y|Y|yes|YES|j|J) ;;
    *) echo "Cancelled."; exit 0 ;;
esac

command -v sudo >/dev/null || {
    echo "ERROR: sudo is required."
    exit 1
}

command -v udevadm >/dev/null || {
    echo "ERROR: systemd-udev is required."
    exit 1
}

TEMP="$(mktemp -d)"
trap 'rm -rf "$TEMP"' EXIT

cat > "$TEMP/71-deepcool-mystique.rules" <<'EOF'
# DeepCool MYSTIQUE USB access
ACTION!="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="3633", ATTR{idProduct}=="0009", MODE="0660", GROUP="root", TAG+="uaccess"
ACTION!="remove", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", ATTRS{idProduct}=="0009", MODE="0660", GROUP="root", TAG+="uaccess"
EOF

cat > "$TEMP/zz-deepcool-mystique.rules" <<'EOF'
# Preserve scoped permissions after older DeepCool rules
ACTION!="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="3633", ATTR{idProduct}=="0009", MODE="0660", GROUP="root"
ACTION!="remove", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", ATTRS{idProduct}=="0009", MODE="0660", GROUP="root"
EOF

for rule in \
    71-deepcool-mystique.rules \
    zz-deepcool-mystique.rules
do
    target="/etc/udev/rules.d/$rule"

    if sudo test -e "$target"; then
        if ! sudo cmp -s "$TEMP/$rule" "$target"; then
            echo "ERROR: Existing rule differs: $target"
            echo "No existing rule was overwritten."
            exit 1
        fi
    else
        sudo install -Dm644 "$TEMP/$rule" "$target"
    fi
done

sudo udevadm control --reload-rules

sudo udevadm trigger \
    --action=add \
    --subsystem-match=usb \
    --attr-match=idVendor=3633 \
    --attr-match=idProduct=0009

sudo udevadm settle

echo
echo "USB rules installed."
echo "USB access must still be verified for the active user."
