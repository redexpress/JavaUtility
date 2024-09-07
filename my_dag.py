from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.base_hook import BaseHook
from datetime import datetime


def read_file_content(ti=None, conn_id=None, **kwargs):
    conn = BaseHook.get_connection(conn_id)
    path = conn.extra_dejson.get('path', '')
    print('filepath is:', path)
    print('conn_id is:', conn_id)
    ti.xcom_push(key='conn_id', value=conn_id)

with DAG(
    'my_dag',
    start_date=datetime(2023, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=['example', 'my']
) as dag:

    show_date = BashOperator(
        task_id='show_date1',
        bash_command='date'
    )

    read_file = PythonOperator(
        task_id='read_file1',
        python_callable=read_file_content,
        op_kwargs={'conn_id': 'my_foo'},
        provide_context=True,
    )

    show_date >> read_file