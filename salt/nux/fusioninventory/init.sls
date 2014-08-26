fusioninventory_repo:
  pkgrepo.managed:
    - repo: 'deb http://debian.fusioninventory.org/debian trusty main'
    - file: /etc/apt/sources.list.d/fusioninventory.list
    - keyid: 049ED9B94765572E
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: fusioninventory

fusioninventory:
  pkg:
    - installed
    - name: fusioninventory-agent
  cmd.wait:
    - name: /usr/bin/fusioninventory-agent

agent.cfg:
  file:
    - managed
    - name: /etc/fusioninventory/agent.cfg
    - source: salt://nux/fusioninventory/files/agent.cfg
    - template: jinja
    - context:
         fusioninventoryserver: {{ pillar.get('fusioninventoryserver', 'http://server.domain.com/ocsinventory') }}
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: fusioninventory
    - watch_in:
      - cmd: fusioninventory
