# Используем базовый образ Ubuntu 20.04
FROM ubuntu:20.04

# Добавляем метаданные об образе
MAINTAINER Timur Ibragimov <i.timur@mail.ru>

# Устанавливаем тайм зону для пакета tzdata (при установке пакета нужно указать тайм зону, чего нельзя сделать, когда билдится образ)
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Обновляем пакеты и устанавливаем необходимые инструменты
RUN apt-get update && apt-get install -y \
    apache2 \
    mysql-server \
    && rm -rf /var/lib/apt/lists/*

# Копируем файлы конфигурации
COPY my.cnf /etc/mysql/my.cnf
ADD default /etc/apache2/sites-available/default

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Устанавливаем пользователя, от имени которого будет исполняться Dockerfile
USER admin

# Устанавливаем переменные окружения
ENV MYSQL_ROOT_PASSWORD=root

# Определяем точку монтирования для Volume
VOLUME /var/lib/mysql

# Документируем порты для Apache и MySQL
EXPOSE 80 3306

# Запускаем Apache и MySQL при старте контейнера
CMD ["bash", "-c", "service mysql start && apache2ctl -D FOREGROUND"]
