from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

# Default args
default_args = {
    'owner': 'data_engineering',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'ecommerce_etl_batch',
    default_args=default_args,
    description='E-commerce ETL: OLTP → Warehouse → Marts',
    schedule_interval='@daily',
    catchup=False,
)

load_dim_customer = BashOperator(
    task_id='load_dim_customer',
    bash_command='psql -d warehouse_db -f /path/to/load_dim_customer.sql',
    dag=dag,
)

load_dim_product = BashOperator(
    task_id='load_dim_product',
    bash_command='psql -d warehouse_db -f /path/to/load_dim_product.sql',
    dag=dag,
)

load_dim_date = BashOperator(
    task_id='load_dim_date',
    bash_command='psql -d warehouse_db -f /path/to/load_dim_date.sql',
    dag=dag,
)

load_fact_sales = BashOperator(
    task_id='load_fact_sales',
    bash_command='psql -d warehouse_db -f /path/to/load_fact_sales.sql',
    dag=dag,
)

run_validation = BashOperator(
    task_id='run_etl_validation',
    bash_command='psql -d warehouse_db -f /path/to/data_tests.sql',
    dag=dag,
)

def notify_failure(context):
    print('ETL failed:', context)

handle_failure = PythonOperator(
    task_id='handle_failure',
    python_callable=notify_failure,
    trigger_rule='one_failed',
    dag=dag,
)

[load_dim_customer, load_dim_product, load_dim_date] >> load_fact_sales >> run_validation
[load_dim_customer, load_dim_product, load_dim_date, load_fact_sales, run_validation] >> handle_failure 