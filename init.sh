#!/bin/bash
#
currentPath=/home/mslauson/projects/config/wm-config

echo "Which computer are we on today?" | lolcat
COMPUTER="$(gum choose desktop thonk devone cancel)"
echo "Initializing for $COMPUTER"

echo "Configuring Custom Desktop Files" | lolcat
for file in "$currentPath"/desktop/*.desktop; do
	filename=$(basename "$file")
	rm -rf "/home/mslauson/.local/share/applications/$filename"
	ln -s "$file" "/home/mslauson/.local/share/applications/$filename"
done

echo "Configuring Hypr" | lolcat
rm ~/.config/hypr/workspace.conf
rm ~/.config/hypr/vars.conf
rm ~/.config/hypr/computer_binds.conf

ln -s /home/mslauson/projects/config/wm-config/hypr/computers/"$COMPUTER"/workspace.conf ~/.config/hypr/workspace.conf
ln -s /home/mslauson/projects/config/wm-config/hypr/computers/"$COMPUTER"/vars.conf ~/.config/hypr/vars.conf
ln -s /home/mslauson/projects/config/wm-config/hypr/computers/"$COMPUTER"/computer_binds.conf ~/.config/hypr/computer_binds.conf
# for dir in aconfmgr alacritty autostart BetterDiscord btop cava doom emacs dunst gtk-2.0 gtk-3.0 gtk-4.0 hypr helix i3 kitty Kvantum mako neofetch OpenRGB paru polybar qt5ct qt6ct ranger rofi swappy swaylock waybar wlogout xfce
for dir in bat btop cava dunst gtk-2.0 gtk-3.0 gtk-4.0 hypr wofi ranger scripts swaylock waybar wlogout networkmanager-dmenu rofi systemd; do
	rm -rf ~/.config/$dir
	ln -s "$currentPath"/$dir ~/.config/$dir
done

echo "Configuring waybar" | lolcat
rm -rf ~/.config/waybar/config.jsonc
rm -rf ~/.config/waybar/style.css

ln -s /home/mslauson/projects/config/wm-config/waybar/computers/"$COMPUTER"/config.jsonc ~/.config/waybar/config.jsonc
ln -s /home/mslauson/projects/config/wm-config/waybar/computers/"$COMPUTER"/style.css ~/.config/waybar/style.css

echo "Configuring Starship" | lolcat
for item in .xprofile .starship.toml; do
	rm -rf ~/$item
	ln -s "$currentPath"/$item ~/$item
done

echo "Configuring Hypr Stores And Scripts" | lolcat
rm -rf /home/mslauson/projects/config/wm-config/hypr/store
mkdir /home/mslauson/projects/config/wm-config/hypr/store
touch /home/mslauson/projects/config/wm-config/hypr/store/dynamic_out.txt
touch /home/mslauson/projects/config/wm-config/hypr/store/prev.txt
touch /home/mslauson/projects/config/wm-config/hypr/store/latest_notif

chmod +x /home/mslauson/projects/config/wm-config/hypr/scripts/tools/*
chmod +x /home/mslauson/projects/config/wm-config/hypr/scripts/*
chmod +x /home/mslauson/projects/config/wm-config/hypr/*
