在 Airflow 中创建一个 `google_cloud_default` 类型的连接，且不指定 `Keyfile JSON`，可以通过配置 Google Cloud 的 **Workload Identity** 来实现。这种方式允许 Airflow 在没有明确提供服务账户的情况下，通过 Google Cloud 提供的身份来访问所需资源。这可以帮助每个 Airflow worker 以它们的环境自动获取相关的 Google Cloud Service Account。

以下是配置流程：

### 1. 配置 Google Cloud 项目
你需要确保 GKE（Google Kubernetes Engine）和 Airflow worker 节点使用的 GCP 项目已经启用了 Workload Identity，并正确绑定了 GCP Service Account 和 Kubernetes Service Account。

### 2. 启用 Workload Identity
- 为 GKE 集群启用 Workload Identity：
  ```bash
  gcloud container clusters update <cluster-name> \
      --workload-pool=<project-id>.svc.id.goog
  ```

### 3. 创建和绑定 Kubernetes Service Account 和 GCP Service Account
1. **创建 Kubernetes Service Account (KSA)：**
   ```bash
   kubectl create serviceaccount <ksa-name> --namespace <namespace>
   ```

2. **为 GCP Service Account (GSA) 和 KSA 创建绑定：**
   ```bash
   gcloud iam service-accounts add-iam-policy-binding <gsa-name>@<project-id>.iam.gserviceaccount.com \
       --role roles/iam.workloadIdentityUser \
       --member "serviceAccount:<project-id>.svc.id.goog[<namespace>/<ksa-name>]"
   ```

3. **将 KSA 与 Pod 关联：**
   如果你是在 Kubernetes 集群上运行 Airflow，你可以修改 `PodTemplate`，或者在 Helm Chart 中添加以下内容，将 KSA 与 Airflow worker pod 关联：
   ```yaml
   serviceAccountName: <ksa-name>
   ```

### 4. 在 Airflow 中配置连接
1. 创建一个 `google_cloud_default` 类型的连接：
   - **Conn ID**: `google_cloud_default`
   - **Conn Type**: `Google Cloud`
   - 不填写 `Keyfile JSON`，这样 Airflow 会自动通过 Workload Identity 来获取 GCP Service Account。

### 5. 验证连接
你可以通过以下方式来验证 Airflow 是否能自动使用 worker 的 service account 进行 Google Cloud API 调用：
```python
from airflow.providers.google.cloud.hooks.gcs import GCSHook

hook = GCSHook()
buckets = hook.list_buckets()
print(buckets)
```

这样，Airflow worker 节点会自动使用通过 Workload Identity 绑定的 Service Account 来访问 Google Cloud 资源，无需手动设置 `Keyfile JSON`。

# Secret
要通过 Airflow 的 `google_cloud_default` 连接读取 Google Cloud Secret Manager 中的 Secret，通常可以使用 Airflow 提供的 **Google Secret Manager Hook**。如果你配置了 `google_cloud_default` 连接，并且相应的 Service Account 拥有 Secret Manager 的读取权限，Airflow 就可以通过该连接访问 Secret Manager 中的 Secret。

### 步骤：

1. **配置 Service Account**：确保绑定到 Airflow worker 的 Google Cloud Service Account 有 `Secret Manager Secret Accessor` 角色，该角色允许读取 Secret 的值。
   ```bash
   gcloud projects add-iam-policy-binding <project-id> \
       --member "serviceAccount:<service-account-email>" \
       --role "roles/secretmanager.secretAccessor"
   ```

2. **创建 Airflow DAG 读取 Secret**：
   使用 `SecretManagerHook` 可以从 Google Secret Manager 中读取 Secret。

### 示例代码：

```python
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.hooks.secret_manager import SecretManagerHook
from airflow.operators.python_operator import PythonOperator

def read_secret():
    # 创建 SecretManagerHook，使用默认的 google_cloud_default 连接
    secret_hook = SecretManagerHook(gcp_conn_id='google_cloud_default')
    
    # 读取指定 secret，假设 secret 名称为 'my-secret'，并且版本为 'latest'
    secret_name = 'projects/<project-id>/secrets/my-secret/versions/latest'
    secret_value = secret_hook.access_secret_version(secret_name=secret_name)
    
    # 输出读取到的 Secret 值
    print(f"Secret value: {secret_value}")

with DAG(
    dag_id='example_read_secret',
    start_date=days_ago(1),
    schedule_interval=None,
) as dag:

    read_secret_task = PythonOperator(
        task_id='read_secret_task',
        python_callable=read_secret,
    )

    read_secret_task
```

### 代码解释：
1. **`SecretManagerHook`**：使用了 `google_cloud_default` 连接来初始化。这个连接会自动获取绑定到 Airflow worker 的 Service Account 来进行 API 访问。
2. **`access_secret_version`**：此方法用于访问 Google Secret Manager 中某个 Secret 的值。你需要提供项目 ID 和 Secret 的名称，以及要读取的版本（通常为 `latest`）。

### 需要注意的几点：
- **Service Account 权限**：Airflow worker 使用的 Service Account 必须有 `Secret Manager Secret Accessor` 权限。
- **Secret 格式**：在访问 Secret 时，记得提供完整的 Secret 路径，例如 `projects/<project-id>/secrets/<secret-name>/versions/latest`。

这样你就可以通过 Airflow 的 `google_cloud_default` 连接，从 Google Secret Manager 中读取 Secret 的值。
