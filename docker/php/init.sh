; PHP Configuration for Laravel
memory_limit = 512M
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 300
max_input_time = 300
max_input_vars = 3000

; Session Configuration
session.gc_probability = 1
session.gc_divisor = 1000
session.gc_maxlifetime = 1440

; Error Reporting (will be overridden by Laravel in production)
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = /var/log/php_errors.log

; Date & Time
date.timezone = Asia/Jakarta

; File Uploads
file_uploads = On

; Security
expose_php = Off
allow_url_fopen = On
allow_url_include = Off

; Performance
realpath_cache_size = 2M
realpath_cache_ttl = 120

; Other optimizations
zend.detect_unicode = Off
output_buffering = 4096
