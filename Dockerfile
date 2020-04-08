FROM ubuntu:18.04
MAINTAINER "kyle@kylehlw.cn"

ADD https://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-5.0.6.tar.gz /bugzilla.tar.gz
COPY ./bugzilla.tar.gz /bugzilla.tar.gz
COPY ./start-bugzilla /usr/bin/start-bugzilla

RUN apt update && \
    apt-get install git nano && \
    apt-get install apache2 mysql-server libappconfig-perl libdate-calc-perl libtemplate-perl libmime-perl build-essential libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl libemail-mime-modifier-perl libdbi-perl libdbd-mysql-perl libcgi-pm-perl libmath-random-isaac-perl libmath-random-isaac-xs-perl apache2-mpm-prefork libapache2-mod-perl2 libapache2-mod-perl2-dev libchart-perl libxml-perl libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl libtheschwartz-perl libtest-taint-perl libauthen-radius-perl libfile-slurp-perl libencode-detect-perl libmodule-build-perl libnet-ldap-perl libfile-which-perl libauthen-sasl-perl libtemplate-perl-doc libfile-mimeinfo-perl libhtml-formattext-withlinks-perl libgd-dev libmysqlclient-dev lynx-cur graphviz python-sphinx rst2pdf && \
    perl -v && \
    mv /bugzilla.conf /etc/apache2/sites-available/bugzilla.conf && \
    tar zvxf /bugzilla.tar.gz && \
    rm -rf /bugzilla.tar.gz && \
    mv /bugzilla-5.0.6 /var/www/html/bugzilla && \
    a2ensite bugzilla && \
    a2enmod cgi headers expires && \
    service apache2 restart && \
    cd /var/www/html/bugzilla && \
    perl install-module.pl --all && \
    ./checksetup.pl && \
    perl install-module.pl DBD::Pg && \
    apt remove -y gcc make && \
    chmod +x /usr/bin/start-bugzilla

WORKDIR /var/www/html/bugzilla

CMD 'start-bugzilla'
