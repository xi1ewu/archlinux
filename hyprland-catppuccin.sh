#!/bin/bash

echo "🔧 تحديث النظام وتثبيت الأدوات الأساسية..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git curl wget base-devel wayland wayland-protocols xdg-desktop-portal-hyprland

echo "🧱 تثبيت Hyprland والبرامج الجمالية..."
yay -S --noconfirm hyprland waybar wofi kitty hyprpaper hyprlock hypridle swaync ttf-jetbrains-mono papirus-icon-theme

echo "🎨 تحميل ثيم Catppuccin لـ Hyprland..."
git clone https://github.com/catppuccin/hyprland.git ~/catppuccin-hypr
mkdir -p ~/.config/hypr
cp ~/catppuccin-hypr/themes/mocha.conf ~/.config/hypr/theme.conf

echo "📁 إنشاء ملف hyprland.conf..."
cat > ~/.config/hypr/hyprland.conf <<EOF
source = ~/.config/hypr/theme.conf

monitor=,preferred,auto,1
exec-once = waybar &
exec-once = hyprpaper &
exec-once = kitty &

input {
  kb_layout = us
}

general {
  gaps_in = 5
  gaps_out = 10
  border_size = 2
  col.active_border = rgba(89, 89, 241, 1.0)
  col.inactive_border = rgba(30, 30, 46, 0.9)
}

decoration {
  rounding = 10
  blur = true
  blur_size = 5
  blur_passes = 3
  blur_ignore_opacity = true
}
EOF

echo "🖼️ إعداد خلفية سطح المكتب..."
mkdir -p ~/Pictures/Wallpapers
wget -O ~/Pictures/Wallpapers/wall.jpg https://w.wallhaven.cc/full/1k/wallhaven-1k9kpl.jpg

cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = ~/Pictures/Wallpapers/wall.jpg
wallpaper = ,~/Pictures/Wallpapers/wall.jpg
EOF

echo "✅ تم التثبيت! لتجربة Hyprland الآن:"
echo "  1. سجل الخروج من الجلسة الحالية"
echo "  2. افتح جلسة Hyprland من مدير الجلسات (مثل greetd أو tty + startx)"
echo "  3. استمتع بواجهة Catppuccin Mocha الجميلة 🐈‍⬛☕"
