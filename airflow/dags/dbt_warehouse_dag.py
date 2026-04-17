from datetime import datetime, timedelta

from airflow.operators.bash import BashOperator

from airflow import DAG

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

dag = DAG(
    "dbt_warehouse_refresh",
    default_args=default_args,
    description="Доставка по складам",
    schedule_interval="0 3 * * *",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["marketplace", "analytics", "presentation", "warehouse", "dbt"],
)

run_dbt = BashOperator(
    task_id="run_dbt_warehouse",
    bash_command='cd /opt/airflow/dbt_project && dbt run --models warehouse_delivery_mart --vars \'{"target_date": "{{ ds }}"}\' --profiles-dir /home/airflow/.dbt',
    dag=dag,
)

end = BashOperator(
    task_id="end_refresh",
    bash_command='echo "dbt warehouse completed for date: {{ ds }}"',
    dag=dag,
)

run_dbt >> end
