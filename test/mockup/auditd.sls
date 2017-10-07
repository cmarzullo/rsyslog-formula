# -*- coding: utf-8 -*-
# vim: ft=sls

test_mockup_auditd_install:
  pkg.installed:
    - name: auditd

test_mockup_audisp_config:
  file.managed:
    - name: '/etc/audisp/plugins.d/syslog.conf'
    - contents: |
        active = yes
        direction = out
        path = builtin_syslog
        type = builtin
        args = LOG_INFO LOG_LOCAL6
        format = string

test_mockup_auditd_service:
  service.running:
    - name: auditd
    - watch:
      - file: test_mockup_audisp_config
