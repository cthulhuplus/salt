webserver_packages:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - php-mysql
      - mariadb-server
      - mariadb

create cthulhuplus.com_directory:
  file.directory:
    - name: /var/www/cthulhuplus.com
    - user: apache 
    - group: apache
    - mode: 755

create inverseuniverse.com_directory:
  file.directory:
    - name: /var/www/inverseuniverse.com
    - user: apache
    - group: apache
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

set_mysql_root_password:
  cmd.run:
    - name: mysqladmin -u root password NewPassword123
delete_anonymous_users:
  cmd.run:
    - name: mysql -u root -p'NewPassword123' -e "delete from mysql.user where User='';"
disable_remote_mysql_access_for_root:
  cmd.run:
    - name: mysql -u root -p'NewPassword123' -e "delete from mysql.user where User='root' and host not in ('localhost', '127.0.0.1', '::1');"
remove_test_database01:
  cmd.run:
    - name: mysql -u root -p'NewPassword123' -e "drop database test;"
remote_test_database02:
  cmd.run:
    - name: mysql -u root -p'NewPassword123' -e "delete from mysql.db where Db='test' or Db='test\_%';"
flush_privileges:
  cmd.run:
    - name: mysql -u root -p'NewPassword123' -e "flush privileges;"
