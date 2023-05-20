yay -Syu hyprland waybar-hyprland cava waybar-mpris-git python rustup kitty fish wofi xdg-desktop-portal-hyprland-git tty-clock-git swaylockd grim slurp pokemon-colorscripts-git starship jq dunst wl-clipboard swaylock-effects-git swww-git

currentPath="$(pwd)"
# for dir in aconfmgr alacritty autostart BetterDiscord btop cava doom emacs dunst gtk-2.0 gtk-3.0 gtk-4.0 hypr helix i3 kitty Kvantum mako neofetch OpenRGB paru polybar qt5ct qt6ct ranger rofi swappy swaylock waybar wlogout xfce
for dir in bat btop cava dunst fish hypr kitty wofi
do
    rm -rf ~/.config/$dir
    ln -s "$currentPath"/$dir ~/.config/$dir
done

for item in .xprofile .starship.toml
do
  rm -rf ~/$item
ln -s "$currentPath"/$item ~/$item
done
