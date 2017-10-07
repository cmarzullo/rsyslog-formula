# -*- coding: utf-8 -*-
# vim: ft=yaml
# Custom Pillar Data for rsyslog central server

rsyslog:
  enabled: True
  required_pkgs:
    - rsyslog
    - rsyslog-gnutls
  service:
    name: rsyslog
    state: running
    enable: True
  globals:
    PreserveFQDN: 'on'
    MaxMessageSize: '32768'
  configs:
    'tls-client-server':
      templates:
        - name: 'Syslog'
          type: 'string'
          string: '/tmp/%HOSTNAME%/syslog.log'
        - name: 'Audit'
          type: 'string'
          string: '/tmp/%HOSTNAME%/audit.log'
      rulesets:
        - name: 'RemoteDevice'
          actions:
            - filter: '*.*;local6.none'
              parameters:
                type: 'omfile'
                dynaFile: 'Syslog'
                fileCreateMode: '0600'
                name: 'syslog_action'
                template: 'RSYSLOG_TraditionalFileFormat'
            - filter: 'local6.*'
              parameters:
                type: 'omfile'
                dynaFile: 'Audit'
                fileCreateMode: '0600'
                name: 'audit_action'
                template: 'RSYSLOG_TraditionalFileFormat'
      modules:
        - load: 'imtcp'
          KeepAlive: 'on'
          'StreamDriver.Mode': '1'
          'StreamDriver.AuthMode': 'x509/name'
          PermittedPeer: 
            - '*'
            - '*.local'
      inputs:
        - type: 'imtcp'
          port: '514'
          ruleset: 'RemoteDevice'
      actions:
        - type: omfwd
          name: 'logfwd'
          Target: {{ grains.host }}
          Port: 514
          Protocol: 'tcp'
          TCP_Framing: 'octet-counted'
          template: 'RSYSLOG_SyslogProtocol23Format'
          StreamDriverMode: '1'
          StreamDriverAuthMode: 'x509/name'
          StreamDriverPermittedPeers: '*'
  tls:
    enable: true
    ca_dir: '/etc/pki/example_test_ca'
    ca_file: 'example_test_ca_ca_cert.crt'
    cert_dir: '/etc/pki/example_test_ca/certs'
    cert_file: '{{ grains.host }}.crt'
    key_dir: '/etc/pki/example_test_ca/certs'
    key_file: '{{ grains.host}}.key'
  messages: '*.=info;*.=notice;*.=warn;auth,authpriv,cron,daemon,mail,news.none;local6.none'
  syslog: '*.*;auth,authpriv.none;local6.none'
