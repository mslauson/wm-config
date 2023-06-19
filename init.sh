currentPath=/home/mslauson/projects/config/wm-config
 
# for dir in aconfmgr alacritty autostart BetterDiscord btop cava doom emacs dunst gtk-2.0 gtk-3.0 gtk-4.0 hypr helix i3 kitty Kvantum mako neofetch OpenRGB paru polybar qt5ct qt6ct ranger rofi swappy swaylock waybar wlogout xfce
for dir in bat btop cava dunst fish hypr kitty wofi scripts starship swaylock waybar wlogout networkmanager-dmenu rofi
do
    rm -rf ~/.config/$dir
    ln -s "$currentPath"/$dir ~/.config/$dir
done

for item in .xprofile .starship.toml
do
  rm -rf ~/$item
  ln -s "$currentPath"/$item ~/$item
done

rm -rf /home/mslauson/projects/config/wm-config/hypr/store
mkdir /home/mslauson/projects/config/wm-config/hypr/store
touch /home/mslauson/projects/config/wm-config/hypr/store/dynamic_out.txt
touch /home/mslauson/projects/config/wm-config/hypr/store/prev.txt
touch /home/mslauson/projects/config/wm-config/hypr/store/latest_notif

chmod +x /home/mslauson/projects/config/wm-config/hypr/scripts/tools/*
chmod +x /home/mslauson/projects/config/wm-config/hypr/scripts/*
chmod +x /home/mslauson/projects/config/wm-config/hypr/*
