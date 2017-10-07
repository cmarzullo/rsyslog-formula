# -*- coding: utf-8 -*-
# vim: ft=sls
# Init rsyslog
{%- from "rsyslog/map.jinja" import rsyslog with context %}

{%- if rsyslog.enabled %}
include:
  - rsyslog.install
  - rsyslog.config
  - rsyslog.service
{%- else %}
'rsyslog-formula disabled':
  test.succeed_without_changes
{%- endif %}
