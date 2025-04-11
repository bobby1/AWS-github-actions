# Use the official Apache HTTPD image as the base image
FROM httpd:2.4

# Copy your custom httpd.conf file to the appropriate location in the container
# COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY index.html /usr/local/apache2/htdocs/index.html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Apache HTTPD when the container starts
CMD ["httpd", "-D", "FOREGROUND"]