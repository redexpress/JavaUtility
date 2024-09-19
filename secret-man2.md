# 1
你想要的方案可以通过以下步骤实现，确保每个 DAG 执行者使用不同的 GCP Service Account 来访问各自的 Secret：

### 1. **前缀命名与 IAM 权限管理**

你已经使用了类似 `myproject-connection-myconn` 命名的 secret，并给指定的 service account 授予了 `roles/secretmanager.secretAccessor` 权限。接下来，你需要确保每个 DAG 执行者使用不同的 Service Account，且每个 Service Account 只能访问属于它的前缀的 secrets。

例如：
- 对于用户 A，创建 secret 名为 `myproject-connection-myconn-a`，并给 `user-a-sa` (service account) `roles/secretmanager.secretAccessor` 权限。
- 对于用户 B，创建 secret 名为 `myproject-connection-myconn-b`，并给 `user-b-sa` 对该 secret 的访问权限。

### 2. **使用 Airflow 的 Connection 功能自动前缀匹配**

为了让 Airflow 处理前缀，且用户不需要知道完整的 secret 名称，你可以通过自定义逻辑实现这种前缀匹配。你可以在 Airflow 的 listener（如 `airflow_local_settings.py`）或 DAG 中添加逻辑，将前缀 `myproject-connection-` 自动添加到 `jenkins_connection_id` 上。这样，用户只需在 DAG 中指定 `myconn`，Airflow 会自动找到正确的 secret。

例如，在 Airflow 的 `airflow_local_settings.py` 中：

```python
def get_prefixed_connection(conn_id):
    # 给连接 ID 自动添加前缀
    return f"myproject-connection-{conn_id}"

# 在插件或任务执行前动态修改连接 ID
original_get_connection = airflow.hooks.base.BaseHook.get_connection

def patched_get_connection(conn_id):
    prefixed_conn_id = get_prefixed_connection(conn_id)
    return original_get_connection(prefixed_conn_id)

airflow.hooks.base.BaseHook.get_connection = patched_get_connection
```

通过这种方式，Airflow 会在后台将 `myconn` 自动映射为 `myproject-connection-myconn`。

### 3. **为每个 DAG 执行者使用不同的 GCP Service Account**

你希望每个 DAG 的执行者使用不同的 GCP Service Account，并访问自己的 secret。可以通过以下方式实现：

#### 1. **Kubernetes Pod Operator + Workload Identity**

如果你是在 Kubernetes 上运行 Airflow，最简单的办法是利用 Kubernetes 的 Workload Identity，让每个 Pod 在执行时使用不同的 GCP Service Account。

例如：
```python
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator

trigger_jenkins_job = KubernetesPodOperator(
    task_id='trigger_jenkins_job',
    namespace='default',
    image='jenkins-job-image',
    service_account_name='user-a-service-account',  # 绑定用户A的service account
    env_vars={
        'JENKINS_CONNECTION_ID': 'myconn',  # 使用用户A对应的 connection
    },
    dag=dag
)
```

通过为每个 DAG 指定不同的 `service_account_name`，可以确保 Pod 使用对应的 GCP Service Account，从而限制该 DAG 执行者只能访问对应的 secrets。

#### 2. **为 DAG 动态配置 GCP Service Account Key**

如果你不使用 Kubernetes，也可以在 DAG 运行前，通过 Python 动态设置 GCP Service Account 凭证：

```python
import os

def set_service_account_for_dag(user_service_account_key_path):
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = user_service_account_key_path

task = PythonOperator(
    task_id='set_gcp_credentials',
    python_callable=set_service_account_for_dag,
    op_args=['/path/to/user-specific-service-account-key.json'],
    dag=dag,
)
```

这样，当 DAG 执行时，会使用不同的 GCP Service Account 来访问其对应的 Secret Manager 资源。

### 4. **错误处理：没有访问权限的 Secret**

如果用户使用了错误的 secret，并且其 GCP Service Account 没有相应权限，GCP Secret Manager 将返回权限错误。你不需要在 Airflow 侧额外处理，GCP 会自动阻止访问未经授权的 secrets。

### 总结

- 通过给 Airflow Connections 添加前缀以及自定义 `airflow_local_settings.py`，用户可以使用简化的 `jenkins_connection_id`。
- 通过使用不同的 GCP Service Account（结合 Kubernetes Workload Identity 或动态配置凭证），每个 DAG 执行者可以使用自己的 GCP Service Account 来访问自己的 secrets。
- 如果用户尝试访问未经授权的 secret，GCP 会直接阻止访问，并返回权限错误。

这样，你既可以简化用户操作，又可以确保不同用户的权限隔离。

# 2 Workload
配置 Kubernetes Workload Identity 可以让你在 Google Kubernetes Engine (GKE) 中使用 Google Cloud 服务的特定权限，而无需在 Pods 中直接管理或使用 service account keys。下面是设置 Workload Identity 的基本步骤：

### 1. **创建 Google Cloud Service Account**

首先，你需要在 Google Cloud 中创建一个 Service Account，并授予它访问 Secret Manager 或其他 GCP 资源的权限。

```sh
gcloud iam service-accounts create <SERVICE_ACCOUNT_NAME> --display-name "<DISPLAY_NAME>"
```

### 2. **为 Service Account 分配权限**

为创建的 Service Account 分配适当的角色（例如 `roles/secretmanager.secretAccessor`）。

```sh
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member "serviceAccount:<SERVICE_ACCOUNT_EMAIL>" \
  --role "roles/secretmanager.secretAccessor"
```

### 3. **创建 Kubernetes Service Account**

在 Kubernetes 中创建一个 Service Account，并在其 annotation 中指定对应的 Google Cloud Service Account。

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: <K8S_SERVICE_ACCOUNT_NAME>
  annotations:
    iam.gke.io/gcp-service-account: <SERVICE_ACCOUNT_EMAIL>
```

保存为 `service-account.yaml`，然后应用它：

```sh
kubectl apply -f service-account.yaml
```

### 4. **授予 Workload Identity 使用权限**

让 Google Cloud Service Account 可以被 Kubernetes Service Account 使用。

```sh
gcloud iam service-accounts add-iam-policy-binding <SERVICE_ACCOUNT_EMAIL> \
  --member "serviceAccount:<PROJECT_ID>.svc.id.goog[<NAMESPACE>/<K8S_SERVICE_ACCOUNT_NAME>]" \
  --role "roles/iam.workloadIdentityUser"
```

### 5. **更新 Kubernetes Deployment 或 Pod**

在你的 Kubernetes 部署或 Pod 配置中，指定你之前创建的 Kubernetes Service Account。例如：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  template:
    spec:
      serviceAccountName: <K8S_SERVICE_ACCOUNT_NAME>
      containers:
      - name: my-container
        image: gcr.io/my-project/my-image
```

### 6. **配置 Airflow 使用 Workload Identity**

如果你在 Airflow 中使用 Kubernetes Pod Operator，可以指定 Pod 使用特定的 Kubernetes Service Account。确保 Airflow Pod 可以使用 Workload Identity。

```python
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator

trigger_jenkins_job = KubernetesPodOperator(
    task_id='trigger_jenkins_job',
    namespace='default',
    image='gcr.io/my-project/my-image',
    service_account_name='<K8S_SERVICE_ACCOUNT_NAME>',
    env_vars={
        'JENKINS_CONNECTION_ID': 'myconn',
    },
    dag=dag,
)
```

### 7. **验证配置**

验证 Workload Identity 是否配置正确：
- 在 Kubernetes Pod 中，你可以使用 `gcloud` 命令行工具来确认当前的身份。

```sh
gcloud auth print-access-token
```

如果配置正确，它会打印出 Google Cloud 的 access token。

### 总结

- 创建 Google Cloud Service Account，并为其分配访问权限。
- 在 Kubernetes 中创建 Service Account，并配置 Workload Identity annotation。
- 将 Kubernetes Service Account 授权给 Google Cloud Service Account。
- 更新你的 Kubernetes 部署或 Pod 使用正确的 Service Account。
- 在 Airflow 或其他 Kubernetes 任务中指定使用的 Kubernetes Service Account。

通过这些步骤，你可以确保你的 Kubernetes Pods 使用指定的 GCP Service Account，从而安全地访问 Google Cloud 资源。
