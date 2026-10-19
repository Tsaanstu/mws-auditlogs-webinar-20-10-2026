#!/usr/bin/env bash
set -e

# Данные: заполнить перед запуском.
KAFKA_BOOTSTRAP_SERVERS='queue.mwsapis.ru:9093'
KAFKA_TOPIC='<TOPIC_NAME>'
KAFKA_CONSUMER_GROUP_ID='<GROUP_ID>'
KAFKA_USERNAME='<MWS_PROJECT_NAME>'
KAFKA_PASSWORD='<QUEUE_API_KEY>'

sudo mkdir -p /var/log/mws-audit
sudo touch /var/log/mws-audit/events.jsonl
sudo chown vector:vector /var/log/mws-audit/events.jsonl
sudo chmod 644 /var/log/mws-audit/events.jsonl

sudo tee /etc/vector/vector.yaml >/dev/null <<EOF
sources:
  mws_audit_kafka:
    type: kafka
    bootstrap_servers: '${KAFKA_BOOTSTRAP_SERVERS}'
    group_id: '${KAFKA_CONSUMER_GROUP_ID}'
    topics:
      - '${KAFKA_TOPIC}'

    decoding:
      codec: json

    sasl:
      enabled: true
      mechanism: "PLAIN"
      username: '${KAFKA_USERNAME}'
      password: '${KAFKA_PASSWORD//\'/\'\'}'

    tls:
      enabled: true
      verify_certificate: true
      verify_hostname: true

sinks:
  mws_audit_file:
    type: file
    inputs:
      - mws_audit_kafka
    path: "/var/log/mws-audit/events.jsonl"
    encoding:
      codec: json
EOF

sudo vector validate /etc/vector/vector.yaml
sudo systemctl enable --now vector
sudo systemctl status vector --no-pager
