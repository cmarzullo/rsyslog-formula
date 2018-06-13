# -*- coding: utf-8 -*-
# vim: ft=sls
# How to configure rsyslog
{%- from "rsyslog/map.jinja" import rsyslog with context %}

rsyslog_config_global:
  file.managed:
    - name: '/etc/rsyslog.conf'
    - source: 'salt://rsyslog/files/rsyslog.conf.{{ grains.os_family }}.j2'
    - user: 'root'
    - group: 'root'
    - mode: 0644
    - template: jinja

{% if rsyslog.configs is defined %}
{% for name, config in rsyslog.configs.iteritems() %}
rsyslog_config_{{ name }}:
  file.managed:
    - name: '/etc/rsyslog.d/{{ name }}.conf'
    - source: 'salt://rsyslog/files/extra.conf.j2'
    - user: 'root'
    - group: 'root'
    - mode: 0644
    - template: jinja
    - config_name: {{ name }}
    - config: {{ config | yaml}}
    - watch_in:
      - service: rsyslog_service

{% endfor %}
{% endif %}
