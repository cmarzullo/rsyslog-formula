# -*- coding: utf-8 -*-
# vim: ft=sls

# create ssl ca and keypair
test_mockup_ssl_create_ca:
  module.run:
    - name: tls.create_ca
    - ca_name: example_test_ca
    - days: 5
    - CN: 'example Test CA'
    - C: US
    - ST: MyState
    - L: MyCity
    - O: example Testing
    - emailAddress: pleasedontemail@thisisnot.coms
    - unless: '[ -f /etc/pki/example_test_ca/example_test_ca_ca_cert.key ]'

test_mockup_ssl_create_csr:
  module.run:
    - name: tls.create_csr
    - ca_name: example_test_ca
    - CN: {{ grains.host }}
    - unless: '[ -f /etc/pki/example_test_ca/certs/{{ grains.host }}.key ]'

test_mockup_ssl_sign_csr:
  module.run:
    - name: tls.create_ca_signed_cert
    - ca_name: example_test_ca
    - CN: {{ grains.host }}
    - unless: '[ -f /etc/pki/example_test_ca/certs/{{ grains.host }}.crt ]'
