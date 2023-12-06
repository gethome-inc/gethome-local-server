#!/bin/bash

# Определение ОС
OS=$(uname -s)

# Установка необходимых зависимостей в зависимости от ОС
echo "Установка необходимых зависимостей для $OS..."

# Для Linux (Debian/Ubuntu/Raspberry Pi OS)
if [ "$OS" = "Linux" ]; then
    sudo apt-get update

    if ! command -v mkcert &> /dev/null; then
        sudo apt-get install -y libnss3-tools
        # ... установка mkcert для Linux ...
    fi

    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
    fi

    if ! command -v docker-compose &> /dev/null; then
        sudo apt-get install -y docker-compose
    fi
fi

# Для macOS
if [ "$OS" = "Darwin" ]; then
    echo "Идет настройка для macOS..."

    # Проверка и установка Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Установка Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew уже установлен."
    fi

    # Пример установки mkcert через Homebrew
    if ! command -v mkcert &> /dev/null; then
        echo "Установка mkcert через Homebrew..."
        brew install mkcert
        mkcert -install
    else
        echo "mkcert уже установлен."
    fi

    # Пример установки Docker через Homebrew
    if ! command -v docker &> /dev/null; then
        echo "Установка Docker через Homebrew..."
        brew install --cask docker
    else
        echo "Docker уже установлен."
    fi
fi

# Проверка и обновление ZIGBEE2MQTT_USB_PATH
read -p "Найти и установить USB-устройство для Zigbee2MQTT? (y/n): " zigbee_answer
if [[ "$zigbee_answer" == "y" ]]; then
    USB_PATH=""
    if [ "$OS" = "Linux" ]; then
        USB_PATH=$(ls /dev/tty.usb* | head -n 1)
    elif [ "$OS" = "Darwin" ]; then
        # Поиск USB устройств, подходящих для Zigbee
        USB_PATH=$(ls /dev/tty.usbserial-* /dev/tty.SLAB_USBtoUART 2>/dev/null | head -n 1)
    fi

    if [ -z "$USB_PATH" ]; then
        echo "USB-устройство для Zigbee2MQTT не найдено."
        sed -i'.bak' -e '/ZIGBEE2MQTT_USB_PATH=/d' serverConfig.txt
        echo "ZIGBEE2MQTT_USB_PATH=" >> serverConfig.txt
    else
        echo "Найдено USB-устройство для Zigbee2MQTT: $USB_PATH"
        sed -i'.bak' -e '/ZIGBEE2MQTT_USB_PATH=/d' serverConfig.txt
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
