currentPath="$(pwd)"
# for dir in aconfmgr alacritty autostart BetterDiscord btop cava doom emacs dunst gtk-2.0 gtk-3.0 gtk-4.0 hypr helix i3 kitty Kvantum mako neofetch OpenRGB paru polybar qt5ct qt6ct ranger rofi swappy swaylock waybar wlogout xfce
for dir in .xmonad
do
    rm -rf ~/$dir
    ln -s "$currentPath"/$dir ~/$dir
done

for item in .xprofile
do
  rm -rf ~/$item
ln -s "$currentPath"/$item ~/$item
done
