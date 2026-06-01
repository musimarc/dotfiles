#!/usr/bin/env bash
# Alerte popup quand la batterie de la souris MX Master passe sous un seuil.
# Lancé périodiquement par mx-battery-alert.timer (systemd --user).
set -euo pipefail

NAME="MX Master"
THRESHOLD="${MX_BATT_THRESHOLD:-10}"   # surchargeable pour les tests
RESET="${MX_BATT_RESET:-20}"           # hystérésis : ré-arme l'alerte au-dessus
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/mx-battery-alert.state"

# MAC du périphérique connecté portant ce nom (robuste au changement de canal)
MAC=$(bluetoothctl devices Connected 2>/dev/null | grep -i "$NAME" | head -1 | awk '{print $2}')
[ -z "${MAC:-}" ] && exit 0   # pas connectée -> rien à faire

info=$(bluetoothctl info "$MAC" 2>/dev/null || true)
pct=$(printf '%s\n' "$info" | sed -n 's/.*Battery Percentage:.*(\([0-9]\+\)).*/\1/p')
[ -z "${pct:-}" ] && exit 0   # batterie non remontée

already=$(cat "$STATE" 2>/dev/null || echo "")

if [ "$pct" -lt "$THRESHOLD" ]; then
  if [ "$already" != "alerted" ]; then
    notify-send -u critical -i battery-caution -a "Batterie souris" \
      "🖱️ Souris MX Master faible" "Batterie à ${pct}% — pense à recharger."
    echo "alerted" > "$STATE"
  fi
elif [ "$pct" -ge "$RESET" ]; then
  : > "$STATE"   # rechargée : ré-arme pour la prochaine fois
fi
