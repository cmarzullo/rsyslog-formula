# -*- coding: utf-8 -*-
# vim: ft=sls
# Manage service for service rsyslog
{%- from "rsyslog/map.jinja" import rsyslog with context %}

rsyslog_service:
 service.{{ rsyslog.service.state }}:
   - name: {{ rsyslog.service.name }}
   - enable: {{ rsyslog.service.enable }}
   - watch:
       - file: rsyslog_config_global
