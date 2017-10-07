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
    'tcp-client-server':
      templates:
        - name: 'Syslog'
          type: 'string'
          string: '/tmp/%HOSTNAME%.log'
      rulesets:
        - name: 'RemoteDevice'
          actions:
            - filter: '*.*,local7.none'
              parameters:
                type: 'omfile'
                dynaFile: 'Syslog'
      modules:
        - load: 'imtcp'
          KeepAlive: 'on'
      inputs:
        - type: 'imtcp'
          port: '514'
          ruleset: 'RemoteDevice'
      actions:
        - type: omfwd
          Target: {{ grains.host }}
          Port: 514
          Protocol: 'tcp'
          TCP_Framing: 'octet-counted'
          template: 'RSYSLOG_TraditionalFileFormat'
