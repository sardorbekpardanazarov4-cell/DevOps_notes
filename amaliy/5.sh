#!/usr/bin/env bash

# 5-kun: Log Tahlilchisi
# ERROR qatorlarini topib, alohida faylga saqlaydi va sonini chiqaradi

set -u    # aniqlanmagan o'zgaruvchilardan foydalanish xato

# ------------------------------------------------------------
# O'zgaruvchilar (foydalanuvchi o'zgartirishi mumkin)
# ------------------------------------------------------------
INPUT_FILE="${1:-access.log}"          # 1-argument yoki default
OUTPUT_FILE="errors_only.log"

# ------------------------------------------------------------
# Funksiyalar
# ------------------------------------------------------------
usage() {
    echo "Foydalanish:"
    echo "  $0 [log_fayl_nomi]"
    echo ""
    echo "Misollar:"
    echo "  $0 nginx_error.log"
    echo "  $0 /var/log/apache2/error.log"
    echo ""
    echo "Agar argument berilmasa, default: access.log"
    exit 1
}

# ------------------------------------------------------------
# Asosiy mantiq
# ------------------------------------------------------------

# Agar --help yoki -h kiritilsa
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
fi

# Kirish faylini tekshirish
if [ ! -f "$INPUT_FILE" ]; then
    echo "Xato: '$INPUT_FILE' fayli topilmadi!" >&2
    echo "Iltimos, mavjud log fayl yo'lini kiriting."
    exit 2
fi

if [ ! -r "$INPUT_FILE" ]; then
    echo "Xato: '$INPUT_FILE' faylini o'qish huquqi yo'q!" >&2
    exit 3
fi

echo "Log fayli tahlil qilinmoqda: $INPUT_FILE"
echo "----------------------------------------"

# ERROR qatorlarini topish va saqlash
# Variantlar: [ERROR], ERROR:, level=error, va hokazo
grep -i -E "\[ERROR\]|\bERROR\b|level=error|ERROR:" "$INPUT_FILE" > "$OUTPUT_FILE"

# Agar hech narsa topilmasa, bo'sh fayl hosil bo'ladi — buni tekshiramiz
if [ ! -s "$OUTPUT_FILE" ]; then
    echo "Hech qanday ERROR darajasidagi qator topilmadi."
    rm -f "$OUTPUT_FILE"  # bo'sh faylni o'chirib tashlaymiz
else
    error_count=$(wc -l < "$OUTPUT_FILE")
    echo "Muvaffaqiyatli yakunlandi!"
    echo "Jami ERROR qatorlari soni : $error_count"
    echo "Saqlangan fayl           : $OUTPUT_FILE"
    echo ""
    echo "Birinchi 5 ta xato (ko'rish uchun):"
    echo "----------------------------------------"
    head -n 5 "$OUTPUT_FILE"
fi

echo "----------------------------------------"
echo "Tayyor."