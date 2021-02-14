# Сделать докер файл 
#в котором проходит установка nginx через apt
# с виртуальным server_nane helloworld; !!!!!!!
# хостом который будет выдавать "Hello word" в браузер
# добавить в вирт хост выдачу кастомного хедера 
#с содержимым helloworld
# Закоммитить получившийся докерфайл в github
# Сделать запрос(ы) curl 
# которые покажут кастомный хедер и helloworld
FROM ubuntu

RUN apt -y update &&\
    apt -y upgrade &&\
    apt -y install php-fpm &&\
    apt -y install nginx-extras

EXPOSE 80
WORKDIR /etc/nginx/sites-available
COPY ./nginx.conf ./default

WORKDIR /var/www/html/helloworld
COPY ./index.php ./index.php
WORKDIR /etc/nginx/
RUN sed -i 's/# server_tokens off;/server_tokens off;\n\tmore_clear_headers Server;\n\tmore_set_headers "Server: helloworld";\n/' ./nginx.conf
WORKDIR /~
RUN echo "#!/bin/bash\nservice php7.4-fpm start\nnginx -g \"daemon off;\"" > start.sh
RUN chmod +x start.sh
ENTRYPOINT [ "./start.sh" ]

# docker build -t test .
# docker run -it --rm -p 8080:80 test
# curl -I localhost:8080
