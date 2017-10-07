# -*- coding: utf-8 -*-
# vim: ft=sls
# How to install rsyslog
{%- from "rsyslog/map.jinja" import rsyslog with context %}

rsyslog_pkgs:
  pkg.installed:
    - pkgs: {{ rsyslog.required_pkgs }}
