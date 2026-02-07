#!/usr/bin/env bash

# 2-kun: Interaktiv Fayl va Katalog Tadqiqotchisi
# Fayllarni ko'rsatish + kiritilgan matndagi belgilar sonini hisoblash

clear

echo "═══════════════════════════════════════════════"
echo "     Xush kelibsiz!  INTERAKTIV TADQIQOTCHI     "
echo "═══════════════════════════════════════════════"
echo "Joriy papka: $(pwd)"
echo ""
echo "Fayl va papkalar ro'yxati (hajmi bilan):"
echo "───────────────────────────────────────────────"

# Fayllar va papkalarni chiroyli ko'rsatish
ls -lh --group-directories-first --time-style=long-iso 2>/dev/null || {
    echo "(!) Bu papkada ko'rsatiladigan fayl yo'q"
}

echo "───────────────────────────────────────────────"
echo ""

echo "Belgilarni sanash rejimi ishga tushdi!"
echo "Matn kiriting (har bir qator uchun belgilar soni hisoblanadi)"
echo "Dasturni tugatish uchun: bo'sh qator + Enter"
echo ""

while true; do
    # Foydalanuvchidan matn o'qish
    read -r matn
    
    # Agar hech narsa kiritilmasa (bo'sh qator) → chiqish
    if [ -z "$matn" ]; then
        echo ""
        echo "Dastur tugadi. Xayr!"
        echo "═══════════════════════════════════════════════"
        exit 0
    fi
    
    # Kiritilgan matn uzunligini hisoblash
    uzunlik=${#matn}
    
    echo "Kiritilgan qator uzunligi: $uzunlik belgi"
    echo "  → \"$matn\""
    echo ""
done