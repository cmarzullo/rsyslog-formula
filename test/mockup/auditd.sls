# -*- coding: utf-8 -*-
# vim: ft=sls

test_mockup_auditd_install:
  pkg.installed:
{% if grains.os_family == "Debian" %}
    - pkgs:
      - auditd
{% elif grains.os_family == "RedHat" %}
    - pkgs:
      - audit
      - audit-libs
{% endif %}

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

{% if grains.os_family == "Debian" %}
test_mockup_auditd_service:
  service.running:
    - name: auditd
    - watch:
      - file: test_mockup_audisp_config
{% elif grains.os_family == "RedHat" %}
# Very strange that auditd on rhel doesn't work with systemd
# https://bugzilla.redhat.com/show_bug.cgi?id=973697
test_mockup_auditd_service:
  cmd.run:
    - name: service auditd restart
    - onchanges:
      - file: test_mockup_audisp_config
{% endif %}
