# MWS Audit Logs → Serverless Queue → Vector → Wazuh

Материалы демонстрации к вебинару 20 октября 2026 года.

События Audit Logs поступают в топик Serverless Queue. Vector читает их по Kafka-протоколу и записывает в `/var/log/mws-audit/events.jsonl`. Wazuh читает файл и создаёт оповещение о действиях выбранного пользователя.

## Файлы

- [install-wazuh.sh](install-wazuh.sh) — установка Wazuh 4.14 all-in-one.
- [install-vector.sh](install-vector.sh) — установка Vector.
- [vector-configuration.sh](vector-configuration.sh) — подключение Vector к очереди и запись событий в JSONL.
- [wazuh-rule.sh](wazuh-rule.sh) — подключение JSONL к Wazuh и создание правила `100100`.

## Документация MWS

- [Serverless Queue: обзор и работа с очередью](https://mws.ru/docs/cloud-platform/queue/general/whatis-queue.html).
- [Audit Logs: обзор и работа с аудитными логами](https://mws.ru/docs/cloud-platform/audit-logs/general/whatis-audit-logs.html).
