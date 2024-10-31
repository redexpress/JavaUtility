## airflow_local_settings.py
```python
from airflow.models import DAG

def cluster_policy(dag: DAG):
    queue_name = 'wcl_dis_uk'

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
