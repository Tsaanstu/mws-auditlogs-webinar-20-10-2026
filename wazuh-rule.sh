#!/usr/bin/env bash
set -e

# Данные: заполнить перед запуском.
MONITORED_USER_REGEX='^demo\.user@example\.com$'
RULE_ID='100100'  # ID должен быть свободен.
RULE_LEVEL='12'

# Добавить источник внутрь первого блока ossec_config.
sudo sed -i '0,/<\/ossec_config>/{
  /<\/ossec_config>/i\
  <localfile>\
    <log_format>json</log_format>\
    <location>/var/log/mws-audit/events.jsonl</location>\
  </localfile>
}' /var/ossec/etc/ossec.conf

# Добавить правило, сохранив существующие.
sudo tee -a /var/ossec/etc/rules/local_rules.xml >/dev/null <<EOF

<group name="mws,audit,">
  <rule id="${RULE_ID}" level="${RULE_LEVEL}">
    <decoded_as>json</decoded_as>
    <field name="kind">^v1/audit$</field>
    <field name="authentication.subject"
           type="pcre2">${MONITORED_USER_REGEX}</field>
    <description>MWS Cloud: activity by monitored user \$(authentication.subject): \$(action)</description>
    <group>mws_audit,mws_monitored_user,</group>
  </rule>
</group>
EOF

sudo /var/ossec/bin/wazuh-logcollector -t
sudo systemctl restart wazuh-manager
sudo systemctl status wazuh-manager --no-pager
