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
    "dbt_purchases_refresh",
    default_args=default_args,
    description="Аналитика закупок",
    schedule_interval="0 2 * * *",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["marketplace", "analytics", "presentation", "purchases", "dbt"],
)

run_dbt = BashOperator(
    task_id="run_dbt_purchases",
    bash_command="cd /opt/airflow/dbt_project && dbt run --models purchase_analytics_mart --full-refresh --profiles-dir /home/airflow/.dbt",
    dag=dag,
)

end = BashOperator(
    task_id="end_refresh",
    bash_command='echo "dbt purchases completed at $(date)"',
    dag=dag,
)

run_dbt >> end
