# DWH_tasks

### Выполненные части задания
1. [Часть 1](./hw1.pdf)
2. [Часть 2](./hw2.pdf)
3. [Часть 3](./hw3.pdf)

## HW3

**Выполняли:** Владимиров, Рогачков, Бойко

### Что сделано
- [x] Подняли менеджер временных обновлений - Airflow
- [x] Настроили временной обновление данных в DWH, и изменение витрин для аналитики
- [x] Построили 2 витрины, через `dbt`
- [x] Подняли `bi` систему - `metabase`

### Как запустить
- `docker compose up -d`. Дальше надо подождать некоторое время, пока пройдет полная инициализация(у меня вышло, не на самом мощном пк правда около 10-30 минут до полного запуска)
- Если возникают ошибки, связанные с `debezium` или `debezium-init`, можно попробовать запускать контейнеры по шагам, что бы разгрузить систему. Между шагами дождаться `healthy` состояний:
  - `docker-compose up -d zookeeper broker postgres-dwh postgres-user postgres-order postgres-logistics airflow-postgres airflow-redis`
  - `docker-compose up -d postgres-user-replica-init postgres-order-replica-init postgres-logistics-replica-init airflow-init`
  - `docker-compose up -d postgres-user-replica postgres-order-replica postgres-logistics-replica`
  - `docker-compose up -d debezium debezium-ui`
  - `docker-compose up -d debezium-init dbt-runner`
  - `docker-compose up -d airflow-webserver airflow-scheduler airflow-worker airflow-triggerer bi-platform`
- Если нужно обновить состояние системы(пришли новые данные в кафку и их нужно переложить) запускать: `docker-compose run dbt-runner dbt run`. Это перезапустит dbt в режиме инсерта новых данных

### Коннекты для бд:
- `user-db` : `jdbc:postgresql://localhost:5432/user_service_db`
- `user-repl` : `jdbc:postgresql://localhost:5442/user_service_repl`
- `order-db` : `jdbc:postgresql://localhost:5433/order_service_db`
- `order-repl` : `jdbc:postgresql://localhost:5443/order_service_repl`
- `logistics-db` : `jdbc:postgresql://localhost:5434/logistics_service_db`
- `logistics-repl` : `jdbc:postgresql://localhost:5444/logistics_service_repl`
- `postgres-dwh` : `jdbc:postgresql://localhost:5435/dwh_db`

Пароль везде `postgres` как и пользователь

Ссылка на видео демонстрацию: https://disk.360.yandex.ru/i/zL5nlJzcfvJ1DA
