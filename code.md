```python
import yaml

# 读取 YAML 文件
with open("workers.yaml", "r") as yaml_file:
    config = yaml.safe_load(yaml_file)

# 读取模板文件
with open("template.txt", "r") as template_file:
    template_content = template_file.read()

# 根据 YAML 中的每个 worker 生成文件
for worker in config["workers"]["workers"]:
    # 替换模板中的占位符
    worker_content = template_content.replace("REPLACEMENT__NAME", worker["name"])
    worker_content = worker_content.replace("REPLACEMENT__QUEUE", worker["queue"])

    # 保存生成的文件，命名为 worker 的名字
    output_filename = f"{worker['name']}.txt"
    with open(output_filename, "w") as output_file:
        output_file.write(worker_content)
    
    print(f"Generated {output_filename}")

```

## airflow_local_settings.py
```python
from airflow.models import DAG

def cluster_policy(dag: DAG):
    queue_name = 'queue_name'

    def set_queue_pre_execute(context: Dict[str, Any]):
        task_instance = context['task_instance']
        task_instance.queue = queue_name        

    def set_queue_on_execute(context):
        task_instance = context['task_instance']
        task_instance.queue = queue_name
    
    dag.default_args = dag.default_args or {}
    dag.default_args['queue'] = queue_name                 # 1
    
    for task in dag.tasks:
        task.queue = queue_name                            # 2
        task.queue_override = queue_name                   # 3
        task.pre_execute = set_queue_on_execute            # 4
        task.on_execute_callback = set_queue_on_execute    # 5
```

old
```
# def custom_dag_policy(dag: DAG):
#     dag_file_path = dag.fileloc
#     print(f'paTh: {dag_file_path}')
#     match = re.search(r'/harbor/([^/]+)/', dag_file_path)
#     for task in dag.tasks:
#         task.queue = 'wcl_dis_uk'
    # if match:
    #     workspace_name = match.group(1)
    #     print(f'wS nAme: {workspace_name}')
    #     queue_name = f"ws_{workspace_name.replace('-', '_')}"
    #     dag.default_args = dag.default_args or {}
    #     dag.default_args['queue'] = queue_name
    #     print(f"DAG {dag.dag_id} assigned to queue '{queue_name}' based on workspace '{workspace_name}'")
    # else:
    #     print(f'DAG name error:{dag_file_path}')
```


## DAG 1
```python
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.base_hook import BaseHook
from datetime import datetime
import re


def read_file_content(ti=None, conn_id=None, **kwargs):
    conn = BaseHook.get_connection(conn_id)
    path = conn.extra_dejson.get('path', '')
    print('filepath is:', path)
    print('conn_id is:', conn_id)
    ti.xcom_push(key='conn_id', value=conn_id)


def dummy_function(dag: DAG):
    queue_name = dag.default_args.get('queue', 'default_queue')
    print(f"===DAG '{dag.dag_id}' has default queue: {queue_name}")
    for task in dag.tasks:
        print(f"===Task '{task.task_id}' in DAG '{dag.dag_id}' has queue: {task.queue} or {queue_name}")


with DAG(
    'wcl-dis-',
    start_date=datetime(2023, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=['example', 'my']
) as dag:

    show_date = BashOperator(
        task_id='init_release',
        bash_command='date'
    )

    read_file = PythonOperator(
        task_id='start_release',
        python_callable=dummy_function,
        op_kwargs={'conn_id': 'my_foo'},
        provide_context=True,
    )

    show_date >> read_file
```

## DAG 2
```python
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.hooks.base_hook import BaseHook
from datetime import datetime


def dummy_function(ti=None, conn_id=None, **kwargs):
    print('METHOD dummy_function CALLED')


def log_task(task_id):
    print(f'Task {task_id} has been executed.')


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

    python_dummy = PythonOperator(
        task_id='dummy_func',
        python_callable=dummy_function,
        op_kwargs={'conn_id': 'my_foo'},
        provide_context=True,
    )

    task_default = PythonOperator(
        task_id='task_default_queue',
        python_callable=log_task,
        op_kwargs={'task_id': 'task_default_queue'},
        queue='default' 
    )

    task_custom = PythonOperator(
        task_id='task_custom_queue',
        python_callable=log_task,
        op_kwargs={'task_id': 'task_custom_queue'},
        queue='wcl_dis_uk'
    )

    show_date >> python_dummy >> task_default >> task_custom
```

## command
```
airflow celery worker --queues default
AIRFLOW__CELERY__WORKER_LOG_SERVER_PORT=8794 airflow celery worker --queues wcl_dis_uk
```

**config**
```ini
[celery]
broker_url = redis://localhost:6379/0
result_backend = redis://localhost:6379/0
default_queue = default
worker_queues = default, my_queue
[core]
# executor = SequentialExecutor
executor = CeleryExecutor
load_examples = False
[database]
# sql_alchemy_conn = sqlite:////home/xd/airflow/airflow.db
sql_alchemy_conn = postgresql+psycopg2://scott:tiger@localhost:5432/postgres
****
```


