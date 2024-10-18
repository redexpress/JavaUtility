你的任务主要是为了隔离不同租户的任务队列和访问权限。具体来说，你需要在 Kubernetes 中为每个租户部署独立的 Airflow worker，指定不同的任务队列，并使用不同的 GCP Workload Identity 来隔离 GCP Service Account 的权限。

### 任务分析
1. **Worker StatefulSet 的多实例部署**：Kubernetes 的 StatefulSet 支持部署多个副本，你可以为每个租户单独部署一个新的 StatefulSet。这将确保不同租户的 worker 是独立的。
   
2. **Celery 队列隔离**：每个租户使用自己的任务队列，可以通过在 worker 启动 Celery 时加上 `--queues=<queue_name>` 参数来实现。这确保每个 worker 只处理自己租户的任务。

3. **不同的 GCP Workload Identity**：GCP Workload Identity 允许每个 Kubernetes Pod 绑定到不同的 GCP Service Account。你可以为每个租户的 StatefulSet 设置不同的 Workload Identity，并为每个租户绑定到特定的 Service Account。

### 解决方案步骤
1. **为每个租户创建新的 StatefulSet**：
   - 在现有的 StatefulSet 基础上创建新的配置文件（YAML），为每个租户单独定义 StatefulSet。
   - 在 `containers.args` 中指定 `celery worker --queues=<queue_name>`，以绑定指定的 Celery 队列。
   
2. **配置不同的 GCP Workload Identity**：
   - 为每个租户的 StatefulSet 配置 Kubernetes Service Account（每个租户使用不同的 Service Account）。
   - 为 Kubernetes Service Account 绑定不同的 GCP Service Account（通过 Workload Identity）。
   - 在 StatefulSet 的 pod 模板中配置 `serviceAccountName`。

3. **GCP 权限管理**：
   - 确保每个租户的 GCP Service Account 只拥有租户相关的权限，例如访问租户专属的 GCP 资源。

### 注意事项
- **队列隔离**：确保租户间任务互不影响，避免交叉访问队列。
- **安全性**：GCP Workload Identity 和 Service Account 需要严格的权限划分，避免租户间权限泄漏。
- **监控和日志**：为不同租户的 worker 部署监控和日志，便于排查问题。

这个方法可以帮助你实现租户隔离，并简化后续的管理。

## Kubernetes StatefulSet
### 1. **Kubernetes StatefulSet 配置示例**

这是一个为每个租户创建独立 `StatefulSet` 的示例 YAML，重点在于 `celery` 的队列配置和 GCP Workload Identity 的绑定。

#### `statefulset.yaml`
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: airflow-worker-tenant1   # 为每个租户单独命名
  namespace: airflow
spec:
  serviceName: "airflow-worker"
  replicas: 1                    # 每个租户的Worker副本数
  selector:
    matchLabels:
      app: airflow-worker
  template:
    metadata:
      labels:
        app: airflow-worker
    spec:
      serviceAccountName: tenant1-k8s-sa  # 与GCP Workload Identity绑定的K8s Service Account
      containers:
        - name: airflow-worker
          image: <your-airflow-worker-image>
          args: ["celery", "worker", "--queues=tenant1-queue"]  # 指定该worker只监听tenant1的队列
          env:
            - name: AIRFLOW__CORE__EXECUTOR
              value: CeleryExecutor       # 确保启用CeleryExecutor
            - name: AIRFLOW__CELERY__BROKER_URL
              value: <your-broker-url>    # Celery broker URL（例如Redis或RabbitMQ的连接URL）
            - name: AIRFLOW__CELERY__RESULT_BACKEND
              value: <your-result-backend-url> # Celery的结果存储位置
          resources:
            requests:
              cpu: "500m"
              memory: "1024Mi"
            limits:
              cpu: "1000m"
              memory: "2048Mi"
```

### 2. **GCP Workload Identity 配置**

要为不同租户配置 GCP Workload Identity，确保为每个租户的 Kubernetes Service Account 绑定不同的 GCP Service Account。关键配置步骤如下：

#### 1. **创建 Kubernetes Service Account (KSA)**:
   这是 Kubernetes 中为每个租户的 worker 创建独立的 Service Account，用于绑定 GCP Service Account。

```bash
kubectl create serviceaccount tenant1-k8s-sa --namespace airflow
```

#### 2. **绑定 GCP Service Account (GSA)**:
   使用 GCP Workload Identity 绑定 Kubernetes Service Account 与 GCP Service Account。

```bash
# 为GCP Service Account绑定Kubernetes Service Account
gcloud iam service-accounts add-iam-policy-binding [GCP_SA_EMAIL] \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:[PROJECT_ID].svc.id.goog[airflow/tenant1-k8s-sa]"
```

#### 3. **更新 Kubernetes 部署的注解**:
   更新 `StatefulSet` pod spec 中，加入必要的 GCP Workload Identity 的注解。

```yaml
    spec:
      serviceAccountName: tenant1-k8s-sa  # 绑定KSA
      automountServiceAccountToken: true
      containers:
        - name: airflow-worker
          ...
      annotations:
        iam.gke.io/gcp-service-account: [GCP_SA_EMAIL]  # 绑定GCP Service Account
```

### 3. **Airflow 使用 CeleryExecutor**

Airflow 的 CeleryExecutor 允许任务通过 Celery 队列进行异步调度和执行。为了使用 Celery，你需要配置以下内容：

#### 1. **启用 CeleryExecutor**:
   在 `airflow.cfg` 中启用 `CeleryExecutor`。

```ini
[core]
executor = CeleryExecutor

[celery]
broker_url = redis://:password@redis-service:6379/0  # 指定 Celery broker URL，例如 Redis 或 RabbitMQ
result_backend = db+postgresql://user:password@postgres-service/airflow  # 结果存储
```

#### 2. **设置 Celery 队列**:
   在每个 `Worker` 启动时，使用 `--queues` 参数来指定它监听的队列。例如在上面的 StatefulSet 配置中，我们为 `tenant1` 的 Worker 指定了 `tenant1-queue`。

通过这种方式，Airflow 中的任务会根据指定的 `queue` 路由到正确的 Celery Worker，这样每个租户的任务就能被正确隔离处理。

#### 3. **Celery 使用场景**:
   - 适合分布式处理，多个 Worker 可以分担不同的任务。
   - 可以为不同任务指定不同的队列，以便将任务分发到指定的 Worker。

总结来说，通过为每个租户部署独立的 Worker StatefulSet，结合 Celery 的队列机制和 GCP Workload Identity，可以很好地实现租户隔离和队列管理。

## worker
你提到的“目前只能部署一个 worker StatefulSet”可能意味着现有的 Airflow 部署中，只配置了一个通用的 worker StatefulSet，没有为不同租户创建独立的 worker。你的要求是需要为每个租户部署单独的 StatefulSet，每个 StatefulSet 绑定不同的队列和 GCP Service Account，做到租户隔离。

### StatefulSet 部署多个的可行性
按你描述的需求，可以为不同的租户部署多个 worker StatefulSet。通过配置不同的队列、GCP Workload Identity 和 Service Account，可以实现租户级别的隔离。

### **哪些部分是可变的，哪些部分是固定的？**

#### **固定部分（适用于所有 StatefulSet）**
这些配置在所有租户的 StatefulSet 中大体相同：
1. **基础镜像**：Airflow worker 使用的容器镜像，例如：
   ```yaml
   image: <your-airflow-worker-image>
   ```
   所有租户的 StatefulSet 都可以使用相同的 Airflow worker 镜像。

2. **Executor 配置**：确保 CeleryExecutor 在所有 StatefulSet 中都一致。
   ```yaml
   env:
     - name: AIRFLOW__CORE__EXECUTOR
       value: CeleryExecutor
   ```

3. **Broker URL 和 Result Backend**：所有租户通常共享同一个 Celery broker 和结果后端（比如 Redis/RabbitMQ 和 PostgreSQL），这些部分通常不需要改变。
   ```yaml
   env:
     - name: AIRFLOW__CELERY__BROKER_URL
       value: <your-broker-url>    # Redis 或 RabbitMQ URL
     - name: AIRFLOW__CELERY__RESULT_BACKEND
       value: <your-result-backend-url> # 结果存储位置
   ```

4. **副本数量**：大多数情况下，所有租户的 StatefulSet 副本数量可以保持相同，除非某些租户需要更多资源。
   ```yaml
   replicas: 1  # 通常每个租户只需要一个 worker 副本
   ```

#### **可变部分（根据租户不同而变化）**
这些配置需要根据不同租户的需求做出改变：
1. **StatefulSet 名称**：
   每个租户的 StatefulSet 名称要不同，以便区分。例如：
   ```yaml
   metadata:
     name: airflow-worker-tenant1   # 租户1的名称
   ```

2. **Celery 队列**：
   每个租户的 worker 需要监听不同的 Celery 队列。通过在启动参数中指定 `--queues=<queue_name>`，确保每个 worker 只处理自己租户的任务：
   ```yaml
   args: ["celery", "worker", "--queues=tenant1-queue"]  # 为租户1监听队列
   ```

3. **Kubernetes Service Account**：
   每个租户的 StatefulSet 使用不同的 Kubernetes Service Account，以便与不同的 GCP Service Account 绑定。不同租户的 StatefulSet 需要在 `spec.serviceAccountName` 中指定对应的 Kubernetes Service Account：
   ```yaml
   serviceAccountName: tenant1-k8s-sa  # 绑定租户1的 Kubernetes Service Account
   ```

4. **GCP Workload Identity 绑定**：
   每个租户的 StatefulSet 通过注解绑定不同的 GCP Service Account。在 StatefulSet 的 pod 模板中为每个租户配置不同的注解：
   ```yaml
   annotations:
     iam.gke.io/gcp-service-account: tenant1-gcp-sa@your-project.iam.gserviceaccount.com  # 租户1的 GCP Service Account
   ```

### **总结：哪些不同，哪些固定？**

| 配置项                         | 固定部分                                      | 可变部分（根据租户）                          |
|--------------------------------|---------------------------------------------|---------------------------------------------|
| **镜像**                       | 相同的 worker 镜像                           | N/A                                         |
| **Executor 配置**              | 相同，CeleryExecutor                         | N/A                                         |
| **Broker URL 和 Result Backend**| 使用相同的 Redis/RabbitMQ 和 PostgreSQL       | N/A                                         |
| **副本数量**                   | 通常相同                                    | 在特定情况下为某些租户调整副本数             |
| **StatefulSet 名称**            | N/A                                         | 每个租户使用不同的名称                        |
| **Celery 队列**                 | N/A                                         | 每个租户监听不同队列                          |
| **Kubernetes Service Account** | N/A                                         | 每个租户使用不同的 Service Account             |
| **GCP Workload Identity**       | N/A                                         | 每个租户绑定不同的 GCP Service Account         |

### **下一步操作**
- **复制和修改现有的 StatefulSet 配置文件**，为每个租户生成独立的 YAML 配置，修改可变部分，如名称、队列、Service Account 和 Workload Identity。
- **部署多个 StatefulSet**，确保每个租户有单独的 worker 监听专属队列，并拥有独立的 GCP 访问权限。

## StatefulSet code
下面是一个完整的 `StatefulSet` YAML 示例，包含英文注释，适用于为每个租户部署独立的 Airflow Worker，并结合 Celery 和 GCP Workload Identity。

### Example: `airflow-worker-tenant1-statefulset.yaml`

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: airflow-worker-tenant1  # Name of the StatefulSet, unique for each tenant
  namespace: airflow  # Namespace where the StatefulSet will be deployed
spec:
  serviceName: "airflow-worker"  # Name of the service that this StatefulSet belongs to
  replicas: 1  # Number of worker replicas for this tenant (adjust if needed)
  selector:
    matchLabels:
      app: airflow-worker
  template:
    metadata:
      labels:
        app: airflow-worker
      annotations:
        iam.gke.io/gcp-service-account: tenant1-gcp-sa@your-project.iam.gserviceaccount.com  # GCP Service Account binding for Workload Identity
    spec:
      serviceAccountName: tenant1-k8s-sa  # Kubernetes Service Account specific to this tenant
      containers:
        - name: airflow-worker
          image: <your-airflow-worker-image>  # Replace with your Airflow worker container image
          args: ["celery", "worker", "--queues=tenant1-queue"]  # Start the worker and assign it to the tenant's Celery queue
          env:
            - name: AIRFLOW__CORE__EXECUTOR
              value: CeleryExecutor  # Use CeleryExecutor for distributed task execution
            - name: AIRFLOW__CELERY__BROKER_URL
              value: redis://:password@redis-service:6379/0  # URL of the message broker (e.g., Redis)
            - name: AIRFLOW__CELERY__RESULT_BACKEND
              value: db+postgresql://user:password@postgres-service/airflow  # Backend for storing task results (e.g., PostgreSQL)
          resources:
            requests:
              cpu: "500m"  # Minimum CPU request for the worker
              memory: "1024Mi"  # Minimum memory request for the worker
            limits:
              cpu: "1000m"  # CPU limit for the worker
              memory: "2048Mi"  # Memory limit for the worker
      restartPolicy: Always
```

### Key Parts Explained:

1. **StatefulSet Name**:
   - Each tenant requires a unique StatefulSet. Here it's named `airflow-worker-tenant1` to distinguish it from other tenants.

2. **Annotations for Workload Identity**:
   - The `iam.gke.io/gcp-service-account` annotation binds the Kubernetes Service Account (KSA) to the Google Cloud Service Account (GSA) specific to this tenant. This enables the worker to authenticate with GCP services using the tenant's credentials.

3. **Kubernetes Service Account**:
   - `serviceAccountName: tenant1-k8s-sa` refers to the KSA created specifically for `tenant1`. This KSA is associated with the GSA that has the required GCP permissions for this tenant.

4. **Celery Queue Assignment**:
   - The argument `--queues=tenant1-queue` ensures that the worker will only listen to tasks in the `tenant1-queue`. This ensures task isolation between different tenants.

5. **Executor and Broker Configuration**:
   - CeleryExecutor is enabled with the `AIRFLOW__CORE__EXECUTOR` environment variable. 
   - The `broker_url` and `result_backend` are also configured, where `broker_url` connects to a Redis instance (or RabbitMQ) and `result_backend` stores task results in PostgreSQL.

6. **Resource Requests and Limits**:
   - You can adjust the `cpu` and `memory` values according to the resource requirements for your worker nodes.

### How to Modify for Another Tenant:
For each new tenant, you will:
- Change the `metadata.name` (e.g., `airflow-worker-tenant2`).
- Update the queue name in `args` (e.g., `--queues=tenant2-queue`).
- Use a different `serviceAccountName` (e.g., `tenant2-k8s-sa`).
- Update the `iam.gke.io/gcp-service-account` annotation to match the tenant's GSA (e.g., `tenant2-gcp-sa@your-project.iam.gserviceaccount.com`).

By following this template, you can deploy a separate worker StatefulSet for each tenant, ensuring proper task isolation and secure access to GCP resources.
