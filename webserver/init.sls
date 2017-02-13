webserver_packages:
  pkg:
    - installed:
      - httpd
      - php5
      - php5-mysql
      - mariadb-server
      - mariadb

create cthulhuplus.com_directory:
  file.directory:
    - name: /var/www/cthulhuplus.com
    - user: httpd
    - group: httpd
    - mode: 755

create inverseuniverse.com_directory:
  file.directory:
    - name: /var/www/inverseuniverse.com
    - user: httpd
    - group: httpd
    - mode: 755

enable_services:
  service.running:
    - name: httpd
    - enable: True
    - name: mariadb
    - enable: True

open_firewall_httpd:
  cmd.run:
    - name: firewall-cmd --permanent --zone=public --add-service=http
    - name: firewall-cmd --permanent --zome=public --add-service=https
    - name: firewall-cmd --reload

secure_mariadb:
  cmd.run:
    - name: mysqladmin -u root password NewPassword123
    - name: mysql -u root -p'NewPassword123' -e "delete from mysql.user where User='';"
    - name: mysql -u root -p'NewPassword123' -e "delete from mysql.user where User='root' and host no in ('localhost', '127.0.0.1', '::1');"
    - name: mysql -u root -p'NewPassword123' -e "drop database test;"
    - name: mysql -u root -p'NewPassword123' -e "delete from mysql.db where Db='test' or Db='test\_%';"
    - name: mysql -u root -p'NewPassword123' -e "flush privileges;"
