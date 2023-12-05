#!/bin/bash

# Установка необходимых зависимостей
echo "Установка необходимых зависимостей..."

# Обновление списка пакетов
sudo apt-get update

# Установка mkcert
if ! command -v mkcert &> /dev/null
then
    echo "Установка mkcert..."
    sudo apt-get install -y libnss3-tools
    wget -q https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-arm
    chmod +x mkcert-v1.4.3-linux-arm
    sudo mv mkcert-v1.4.3-linux-arm /usr/local/bin/mkcert
    mkcert -install
fi

# Установка Docker, если он не установлен
if ! command -v docker &> /dev/null
then
    echo "Установка Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
fi

# Установка Docker Compose, если он не установлен
if ! command -v docker-compose &> /dev/null
then
    echo "Установка Docker Compose..."
    sudo apt-get install -y docker-compose
fi


# Проверка наличия HOME_TOKEN в serverConfig.txt и сохранение, если он отсутствует
grep -q "HOME_TOKEN=" serverConfig.txt || echo "HOME_TOKEN=your_token" >> serverConfig.txt

# Поиск и установка USB-устройства для Zigbee2MQTT
read -p "Найти и установить USB-устройство для Zigbee2MQTT? (y/n): " zigbee_answer
if [[ "$zigbee_answer" == "y" ]]; then
    USB_PATH=$(ls /dev/tty.usb* | head -n 1)
    if [ -z "$USB_PATH" ]; then
        echo "USB-устройство для Zigbee2MQTT не найдено."
        echo "ZIGBEE2MQTT_USB_PATH=" >> serverConfig.txt
    else
        echo "Найдено USB-устройство для Zigbee2MQTT: $USB_PATH"
        echo "ZIGBEE2MQTT_USB_PATH=$USB_PATH" >> serverConfig.txt
    fi
fi

# Установка статического IP-адреса для Raspberry Pi/Linux
read -p "Установить статический IP-адрес? (y/n): " ip_answer
if [[ "$ip_answer" == "y" ]]; then
    read -p "Введите статический IP-адрес: " static_ip
    echo "interface eth0" >> /etc/dhcpcd.conf
    echo "static ip_address=$static_ip/24" >> /etc/dhcpcd.conf
    echo "static routers=router_ip" >> /etc/dhcpcd.conf
    echo "static domain_name_servers=dns_ip" >> /etc/dhcpcd.conf
    LOCAL_IP=$static_ip
else
    LOCAL_IP="$(hostname -I | cut -d' ' -f1)"
fi
echo "Используемый IP-адрес: $LOCAL_IP"

# Проверка наличия SSL сертификатов
read -p "Создать SSL сертификаты? (y/n): " ssl_answer
if [[ "$ssl_answer" == "y" ]]; then
    if [ ! -f "ssl/cert.pem" ] || [ ! -f "ssl/key.pem" ]; then
        echo "Создание SSL сертификатов..."
        mkcert -cert-file ssl/cert.pem -key-file ssl/key.pem "$LOCAL_IP"
    else
        echo "SSL сертификаты уже существуют."
    fi
fi

# Обновление репозитория
git pull

# Сборка и запуск Docker контейнеров
docker-compose down
docker volume rm gethome-local-server_db_data
docker-compose up --build -d
docker-compose run app knex migrate:latest
docker-compose run app knex seed:run
docker container prune -f
docker rmi $(docker images -f "dangling=true" -q)

echo "Установка завершена."