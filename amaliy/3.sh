#!/usr/bin/env bash

# 3-kun: Foydalanuvchi hisoblarini boshqarish
# Skript sudo huquqlari bilan ishlatilishi kerak

set -u   # o'zgaruvchilar aniqlanmagan bo'lsa xato

# Yordam funksiyasi
show_help() {
    echo "Foydalanish:"
    echo "  sudo ./user_management.sh [OPTION]"
    echo ""
    echo "Mavjud variantlar:"
    echo "  -c, --create     Yangi foydalanuvchi yaratish"
    echo "  -d, --delete     Foydalanuvchini o'chirish"
    echo "  -r, --reset      Foydalanuvchi parolini yangilash"
    echo "  -l, --list       Tizimdagi foydalanuvchilar ro'yxati"
    echo "  -h, --help       Ushbu yordam xabarini ko'rsatish"
    echo ""
    echo "Eslatma: Skriptni sudo bilan ishga tushirish kerak!"
    exit 0
}

# Foydalanuvchi mavjudligini tekshirish
user_exists() {
    local username="$1"
    id "$username" >/dev/null 2>&1
    return $?
}

# Asosiy mantiq - argumentlarni qayta ishlash
if [ "$#" -eq 0 ]; then
    show_help
fi

case "$1" in
    -c|--create)
        echo "Yangi foydalanuvchi yaratish"
        echo "──────────────────────────────"
        
        read -p "Foydalanuvchi nomi: " username
        
        if [ -z "$username" ]; then
            echo "Xato: Foydalanuvchi nomi kiritilmadi!" >&2
            exit 1
        fi
        
        if user_exists "$username"; then
            echo "Xato: '$username' ismli foydalanuvchi allaqachon mavjud!" >&2
            exit 1
        fi
        
        read -s -p "Parol kiriting: " password
        echo ""
        read -s -p "Parolni tasdiqlang: " password2
        echo ""
        
        if [ "$password" != "$password2" ]; then
            echo "Xato: Parollar mos kelmaydi!" >&2
            exit 1
        fi
        
        if [ -z "$password" ]; then
            echo "Xato: Parol bo'sh bo'lishi mumkin emas!" >&2
            exit 1
        fi
        
        # Foydalanuvchini yaratish (-m → home papka yaratiladi)
        if sudo useradd -m -s /bin/bash "$username"; then
            echo "$username:$password" | sudo chpasswd
            if [ $? -eq 0 ]; then
                echo "Muvaffaqiyat: '$username' foydalanuvchisi yaratildi."
                echo "Home papka: /home/$username"
            else
                echo "Xato: Parol o'rnatishda muammo yuz berdi." >&2
                # Agar parol o'rnatilmasa, yaratilgan foydalanuvchini o'chirish mumkin
                sudo userdel -r "$username" 2>/dev/null
                exit 1
            fi
        else
            echo "Xato: Foydalanuvchi yaratishda xato yuz berdi." >&2
            exit 1
        fi
        ;;

    -d|--delete)
        echo "Foydalanuvchini o'chirish"
        echo "─────────────────────────"
        
        read -p "O'chiriladigan foydalanuvchi nomi: " username
        
        if [ -z "$username" ]; then
            echo "Xato: Foydalanuvchi nomi kiritilmadi!" >&2
            exit 1
        fi
        
        if ! user_exists "$username"; then
            echo "Xato: '$username' ismli foydalanuvchi topilmadi!" >&2
            exit 1
        fi
        
        read -p "'$username' ni haqiqatan ham o'chirmoqchimisiz? (y/n): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo "Amal bekor qilindi."
            exit 0
        fi
        
        # -r → home papka va mail spool ham o'chiriladi
        if sudo userdel -r "$username"; then
            echo "Muvaffaqiyat: '$username' foydalanuvchisi o'chirildi."
        else
            echo "Xato: Foydalanuvchini o'chirishda muammo yuz berdi." >&2
            exit 1
        fi
        ;;

    -r|--reset)
        echo "Parolni yangilash / tiklash"
        echo "───────────────────────────"
        
        read -p "Foydalanuvchi nomi: " username
        
        if [ -z "$username" ]; then
            echo "Xato: Foydalanuvchi nomi kiritilmadi!" >&2
            exit 1
        fi
        
        if ! user_exists "$username"; then
            echo "Xato: '$username' ismli foydalanuvchi topilmadi!" >&2
            exit 1
        fi
        
        read -s -p "Yangi parol: " password
        echo ""
        read -s -p "Parolni tasdiqlang: " password2
        echo ""
        
        if [ "$password" != "$password2" ]; then
            echo "Xato: Parollar mos kelmaydi!" >&2
            exit 1
        fi
        
        if [ -z "$password" ]; then
            echo "Xato: Parol bo'sh bo'lishi mumkin emas!" >&2
            exit 1
        fi
        
        echo "$username:$password" | sudo chpasswd
        if [ $? -eq 0 ]; then
            echo "Muvaffaqiyat: '$username' uchun parol yangilandi."
        else
            echo "Xato: Parolni yangilashda muammo yuz berdi." >&2
            exit 1
        fi
        ;;

    -l|--list)
        echo "Tizimdagi foydalanuvchilar ro'yxati"
        echo "──────────────────────────────────"
        echo "Foydalanuvchi      UID"
        echo "───────────────────────────────"
        
        # Faqat oddiy foydalanuvchilarni ko'rsatish (UID >= 1000)
        # yoki barchasini ko'rsatish mumkin — hozir barchasini
        cut -d: -f1,3 /etc/passwd | sort -t: -k2 -n | while IFS=: read -r user uid; do
            printf "%-15s %s\n" "$user" "$uid"
        done
        ;;

    -h|--help)
        show_help
        ;;

    *)
        echo "Noma'lum variant: $1" >&2
        echo "Mavjud variantlarni ko'rish uchun: -h yoki --help"
        exit 1
        ;;
esac

exit 0