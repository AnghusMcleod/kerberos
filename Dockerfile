FROM alpine:latest

# Install required packages
RUN apk --no-cache add krb5 krb5-server krb5-libs apache2 php7 php7-apache2 openldap-clients openssl krb5-webkdc tcpdump strace

# Copy configuration files
COPY krb5.conf /etc/krb5.conf
COPY kdc.conf /etc/krb5kdc/kdc.conf
COPY kadm5.acl /etc/krb5kdc/kadm5.acl
COPY webkdc.conf /etc/apache2/conf.d/webkdc.conf

# Create a volume for Kerberos database
VOLUME ["/var/lib/krb5kdc", "/var/lib/krb5kadm5"]

# Expose Kerberos and Apache ports
EXPOSE 88 749 80

# Copy entry script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables
ENV LDAP_SERVER ldap.example.com
ENV LDAP_PORT 389
ENV LDAP_BIND_DN cn=admin,dc=example,dc=com
ENV LDAP_BIND_PASSWORD admin_password
ENV LDAP_USER_BASE_DN ou=users,dc=example,dc=com
ENV LDAP_GROUP_BASE_DN ou=groups,dc=example,dc=com

# Start KDC and Apache with WebKDC
CMD ["/entrypoint.sh"]
