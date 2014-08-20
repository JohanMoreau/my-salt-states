snmpd:
  pkg:
    - installed
  service:
    - running
    - name: snmpd
    - require:
      - pkg: snmpd
 
snmpd.conf:
  file:
    - managed
    - name: /etc/snmp/snmpd.conf
    - source: salt://nux/snmp/files/snmpd.conf
    - template: jinja
    - context:
         snmpcom: {{ pillar.get('snmpcom', 'public') }}
         snmplocal: {{ pillar.get('snmplocal', 'On the Discworld') }}
         snmpcontact: {{ pillar.get('snmpcontact', 'root') }}
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: snmpd
    - watch_in:
      - service: snmpd

snmpd.default:
  file:
    - managed
    - name: /etc/default/snmpd
    - source: salt://nux/snmp/files/snmpd
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: snmpd
    - watch_in:
      - service: snmpd
