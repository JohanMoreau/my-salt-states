{% from "nux/pam-ldap/map.jinja" import pam_ldap with context %}

#tls_cacertfile:
#    file.managed:
#        - source: salt://pam-ldap/files/cert
#        - user: root
#        - group: root
#        - mode: 640
libnss-db:
    pkg:
        - installed

nss-updatedb:
    pkg:
        - installed

pam-ldap:
    pkg:
        - installed
        - name: {{ pam_ldap.pkg }}

/etc/nsswitch.conf:
   file.managed:
        - source: salt://nux/pam-ldap/files/nsswitch.conf

{{ pam_ldap.config }}:
   file.managed:
        - source: salt://nux/pam-ldap/files/ldap.conf
        #- user: user
        #- group: user
        #- mode: 644

ldap_conf:
  file.append:
    - name: /etc/ldap.conf
    - text:
        - host {{ salt['pillar.get']('pam:ldap:host') }}
        {% if salt['pillar.get']('pam:ldap:port') %}
        - port {{ salt['pillar.get']('pam:ldap:port') }}
        {% endif %}
        - base {{ salt['pillar.get']('pam:ldap:base') }}
        - ldap_version {{ salt['pillar.get']('pam:ldap:version', 3) }}
        - bind_policy {{ salt['pillar.get']('pam:ldap:policy') }}
        {% if salt['pillar.get']('pam:ldap:binddn') %}
        - binddn {{ salt['pillar.get']('pam:ldap:binddn', '') }}
        - bindpw {{ salt['pillar.get']('pam:ldap:bindpw', '') }}
        {% endif %}
        - scope {{ salt['pillar.get']('pam:ldap:scope', 'sub') }}
        - pam_lookup_policy {{ salt['pillar.get']('pam:ldap:pam_lookup_policy', 'yes') }}
        - pam_groupdn {{ salt['pillar.get']('pam:ldap:pam_groupdn') }}
        - pam_member_attribute {{ salt['pillar.get']('pam:ldap:pam_member_attribute', 'member') }}
        - pam_password {{ salt['pillar.get']('pam:ldap:pam_password') }}
        {% if salt['pillar.get']('pam:ldap:ssl') %}
        - ssl {{ salt['pillar.get']('pam:ldap:ssl') }}
        {% endif %}
        {% if salt['pillar.get']('pam:ldap:tls_checkpeer') == 'yes' %}
        - tls_checkpeer {{ salt['pillar.get']('pam:ldap:tls_checkpeer', 'no') }}
        - tls_cacertfile {{ salt['pillar.get']('pam:ldap:tls_cacertfile', '') }}
        - tls_cacertdir {{ salt['pillar.get']('pam:ldap:tls_cacertdir', '') }}
        {% endif %}
        - sasl_secprops none
        - sasl-secprops none
        - sasl_secprops maxssf=0
        - sasl-secprops maxssf=0
        - nss_base_passwd {{ salt['pillar.get']('pam:ldap:base') }}?sub
        - nss_base_shadow {{ salt['pillar.get']('pam:ldap:base') }}?sub
        - nss_base_group {{ salt['pillar.get']('pam:ldap:base') }}?sub
        - nss_map_objectclass posixAccount user
        - nss_map_objectclass shadowAccount user
        - nss_map_attribute uid msSFU30Name
        - nss_map_attribute uidNumber uidNumber
        - nss_map_attribute gidNumber gidNumber
        - nss_map_attribute uniqueMember msSFU30PosixMember
        - nss_map_attribute homeDirectory unixHomeDirectory
        - nss_map_attribute cn cn
        - nss_map_attribute loginShell loginShell
        - nss_map_attribute gecos msSFU30Gecos
        - nss_map_attribute memberUid msSFU30MemberUid
        - nss_map_objectclass posixGroup group
        - pam_login_attribute msSFU30Name
        - pam_filter objectclass=user
        - ssl no
        - nss_initgroups_ignoreusers Debian-exim,avahi,avahi-autoipd,backup,bin,colord,couchdb,daemon,debian-xfs,dnsmasq,games,gdm,gnats,haldaemon,hplip,irc,kdm,kernoops,klog,libuuid,lightdm,list,lp,mail,man,messagebus,munin,mysql,news,ntpd,polkituser,postfix,proxy,pulse,root,rtkit,saned,snmp,speech-dispatcher,sshd,sync,sys,syslog,usbmux,uucp,vboxadd,whoopsie,www-data
