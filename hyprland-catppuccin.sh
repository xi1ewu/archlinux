#!/bin/bash

set -e

echo "🚀 بدء تثبيت الأدوات والثيمات..."

# تحديث النظام
sudo pacman -Syu --noconfirm

# تثبيت yay إذا لم يكن مثبت
if ! command -v yay &> /dev/null; then
  echo "🔧 تثبيت yay..."
  sudo pacman -S --needed base-devel git --noconfirm
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
fi

# تثبيت الحزم المطلوبة
yay -S --noconfirm \
  catppuccin-gtk-theme catppuccin-cursors catppuccin-icons papirus-icon-theme \
  waybar wofi hyprpaper swaync kitty nwg-look hyprland

echo "🎨 ضبط الثيمات باستخدام nwg-look..."

# ضبط ثيم GTK، الأيقونات، والمؤشر
nwg-look set-theme --gtk catppuccin-mocha-standard-mauve-dark
nwg-look set-theme --icons papirus
nwg-look set-theme --cursor catppuccin-mocha

echo "⚙️ إعداد Waybar..."

mkdir -p ~/.config/waybar
cat > ~/.config/waybar/config <<EOF
{
  "position": "top",
  "modules-left": ["clock"],
  "modules-center": ["custom/logo"],
  "modules-right": ["tray", "cpu", "memory", "custom/power"],
  "custom/logo": {
    "format": "",
    "tooltip": false
  },
  "custom/power": {
    "format": "⏻",
    "on-click": "hyprlock"
  },
  "cpu": { "format": "🧠 {usage}%" },
  "memory": { "format": "💾 {used:0.1f}G" },
  "clock": {
    "format": "📆 {:%A %H:%M}",
    "tooltip-format": "{:%d %B %Y}"
  }
}
EOF

cat > ~/.config/waybar/style.css <<EOF
* {
  font-family: JetBrainsMono Nerd Font;
  font-size: 14px;
  background: #1e1e2e;
  color: #cdd6f4;
}

#custom-logo {
  font-size: 20px;
}

#clock, #cpu, #memory, #custom-power {
  padding: 0 10px;
  border-radius: 10px;
  background-color: #313244;
  margin: 2px;
}
EOF

echo "⚙️ إعداد Wofi..."

mkdir -p ~/.config/wofi
cat > ~/.config/wofi/style.css <<EOF
window {
  background-color: #1e1e2e;
  color: #cdd6f4;
  border-radius: 10px;
  padding: 10px;
  font-family: JetBrainsMono Nerd Font;
  font-size: 14px;
}
EOF

echo "🖼️ ضبط الخلفية..."

mkdir -p ~/Pictures/Wallpapers
wget -q -O ~/Pictures/Wallpapers/catppuccin.jpg https://raw.githubusercontent.com/catppuccin/wallpapers/main/mocha/forest.jpg

mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = ~/Pictures/Wallpapers/catppuccin.jpg
wallpaper = ,~/Pictures/Wallpapers/catppuccin.jpg
EOF

echo "⚙️ تحديث إعدادات Hyprland..."

mkdir -p ~/.config/hypr
cat >> ~/.config/hypr/hyprland.conf <<EOF

general {
  gaps_in = 5
  gaps_out = 10
  border_size = 2
  col.active_border = rgba(89b4faee)
  col.inactive_border = rgba(1e1e2eee)
  layout = dwindle
}

decoration {
  rounding = 12
  blur {
    enabled = true
    size = 8
    passes = 2
    new_optimizations = on
  }
  drop_shadow = yes
  shadow_range = 10
  shadow_render_power = 3
  col.shadow = rgba(00000099)
}

exec-once = waybar &
exec-once = hyprpaper &
exec-once = swaync &
exec-once = kitty &
EOF

echo "✅ كل شيء جاهز! أعد تشغيل الجلسة أو نفذ: hyprctl reload"

