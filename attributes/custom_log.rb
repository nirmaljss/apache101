# coding: UTF-8

# Cookbook Name:: apache101
# Attributes:: custom_log

default['apache']['web']['log_dir'] = '/var/log/httpd'
default['apache']['web']['access_log'] = 'web_access_log'
default['apache']['web']['log_format'] = "%h %l %u %t \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\" %{Host}i %{X-Forwarded-For}i %T/%D %I %O"
default['apache']['web']['log_format_name'] = 'combined_plus_host_xff_timing_io'
