FROM rhscl/httpd-24-rhel7

USER 0
RUN rm -f /etc/httpd/conf.d/*.conf && \
    :> /etc/httpd/conf.d/ssl.conf
COPY httpd/ /etc/httpd/
RUN chmod -R 777 /etc/httpd/conf.d

USER 1001
