#!/bin/bash


echo "Challenge boshlandi"

# Matematik amallar
a=10
b=20
yigindi=$((a + b))

echo ""
echo "--- 1-kunlik Bash Challenge natijasi ---"
echo "Salom! Bu mening birinchi bash skriptim."

echo ""
echo "Matematik amal:"
echo "$a + $b = $yigindi"

# Tizim ma'lumotlari
echo ""
echo "Tizim ma'lumotlari:"
echo "Foydalanuvchi: $USER"
echo "Uy katalogi: $HOME"
echo "Ishlatilayotgan Shell: $SHELL"

# Joriy papkada .txt va .sh fayllari
echo ""
echo "Papka ichidagi skriptlar va matn fayllari ro'yxati:"
ls -1 *.sh *.txt 2>/dev/null || echo "(bunday fayllar topilmadi)"

# yoki yanada sodda variant (faqat mavjud bo'lsa chiqaradi):
# ls *.sh *.txt 2>/dev/null