# -*- coding: utf-8 -*-
# vim: ft=yaml
# Custom Pillar Data for rsyslog central server

rsyslog:
  enabled: True
  service:
    name: rsyslog
    state: running
    enable: True
  configs:
    'udp-client-server':
      templates:
        - name: 'Syslog'
          type: 'string'
          string: '/tmp/%HOSTNAME%.log'
      rulesets:
        - name: 'RemoteDevice'
          actions:
            - parameters:
                type: 'omfile'
                dynaFile: 'Syslog'
      modules:
        - load: 'imudp'
      inputs:
        - type: 'imudp'
          port: '514'
          ruleset: 'RemoteDevice'
      actions:
        - type: omfwd
          Target: {{ grains.host }}
          Port: 514
          Protocol: 'udp'
