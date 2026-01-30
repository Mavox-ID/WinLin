#!/bin/bash

sudo apt update
sudo apt install -y os-prober grub-customizer gettext
if ! grep -q "GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
    echo "Search another OS (os-prober)..."
    echo "GRUB_DISABLE_OS_PROBER=false" | sudo tee -a /etc/default/grub
fi
sudo update-grub
echo "----------------------------------------------------------------"
echo "Done! Now you can store the WinLin theme itself via build.sh.   "
echo "After installing the WinLin theme, run 'sudo update-grub' again."
echo "----------------------------------------------------------------"
