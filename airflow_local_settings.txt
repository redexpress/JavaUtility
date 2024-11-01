from airflow.models.baseoperator import BaseOperator
import re 


def task_policy(task: BaseOperator):
    dag = task.dag
    dag_file_path = dag.fileloc
    match = re.search(r'/harbor/([^/]+)/', dag_file_path)
    if match:
        workspace_name = match.group(1)
        queue_name = f"{workspace_name.replace('-', '_')}"
        task.queue = queue_name
    else:
        print(f'DAG name error:{dag_file_path}')
        task.queue = 'wcl_dis_uk'
