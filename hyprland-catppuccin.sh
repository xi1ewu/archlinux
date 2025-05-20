#!/bin/bash

echo "🔧 تحديث النظام وتثبيت الأدوات الأساسية..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git curl wget base-devel wayland wayland-protocols xdg-desktop-portal-hyprland

echo "🛠️ تثبيت Hyprland والأدوات الجمالية..."
yay -S --noconfirm hyprland waybar wofi kitty hyprpaper hyprlock hypridle swaync ttf-jetbrains-mono papirus-icon-theme

echo "🎨 تحميل ثيم Catppuccin Mocha لـ Hyprland..."
git clone https://github.com/catppuccin/hyprland.git ~/catppuccin-hypr
mkdir -p ~/.config/hypr
cp ~/catppuccin-hypr/themes/mocha.conf ~/.config/hypr/theme.conf

echo "🖼️ تحميل الخلفية وتكوين Hyprpaper..."
mkdir -p ~/Pictures/Wallpapers
wget -O ~/Pictures/Wallpapers/wall.jpg https://images.unsplash.com/photo-1503264116251-35a269479413

mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = ~/Pictures/Wallpapers/wall.jpg
wallpaper = ,~/Pictures/Wallpapers/wall.jpg
EOF

echo "⚙️ إعداد ملف hyprland.conf..."
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

echo "🧩 إعداد Waybar مع أزرار مخصصة..."
mkdir -p ~/.config/waybar/scripts

# سكربت زر الطاقة
cat > ~/.config/waybar/scripts/power-menu.sh <<EOF
#!/bin/bash
options="⏻ Poweroff\n🔁 Reboot\n🔒 Lock"
choice=\$(echo -e "\$options" | wofi --dmenu --width 200 --height 150)
case "\$choice" in
  *Poweroff*) poweroff ;;
  *Reboot*) reboot ;;
  *Lock*) hyprlock ;;
esac
EOF

# سكربت زر تغيير الثيم (مثال بسيط)
cat > ~/.config/waybar/scripts/toggle-theme.sh <<EOF
#!/bin/bash
if grep -q "mocha" ~/.config/hypr/theme.conf; then
  cp ~/catppuccin-hypr/themes/latte.conf ~/.config/hypr/theme.conf
else
  cp ~/catppuccin-hypr/themes/mocha.conf ~/.config/hypr/theme.conf
fi
hyprctl reload
EOF

chmod +x ~/.config/waybar/scripts/*.sh

# ملف Waybar config
cat > ~/.config/waybar/config <<EOF
{
  "layer": "top",
  "position": "top",
  "modules-right": ["custom/power", "custom/theme", "clock"],
  "custom/power": {
    "format": "⏻",
    "tooltip": "Power Menu",
    "on-click": "~/.config/waybar/scripts/power-menu.sh"
  },
  "custom/theme": {
    "format": "🎨",
    "tooltip": "Toggle Theme",
    "on-click": "~/.config/waybar/scripts/toggle-theme.sh"
  },
  "clock": {
    "format": "🕒 {:%H:%M}",
    "tooltip-format": "{:%A, %d %B %Y}"
  }
}
EOF

echo "✅ التثبيت والإعدادات اكتملت! لتجربة النظام:"
echo "1. سجل الخروج من الجلسة الحالية أو أعد التشغيل."
echo "2. من شاشة الدخول (tty أو greetd)، اكتب: Hyprland"
echo "3. استمتع ببيئة Arch Linux جميلة ومخصصة 🔥"
