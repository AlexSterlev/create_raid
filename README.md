# ДЗ №2 create_raid
- Для управление программным RAID-массивом используем пакет mdadm.
- Подключены 4 диска.
- Очищаем суперблоки RAID на разделах, из которых собран массив.
- Сборка RAID 10 из 4 дисков.
- В файл /etc/mdadm/mdadm.conf записана информация о RAID.
- На созданном програмном RAID созданны и отформатированны разделы ext 4 и примонтированны к каталогу raid.

# Проверка ДЗ №2
- cat /proc/mdstat
- ls -lah /raid

