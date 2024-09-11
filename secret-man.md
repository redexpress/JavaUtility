# 基本操作

### 验证 Workload Identity 和 GCP Secret Manager 配置的操作指南

以下是一个简明的操作指南，包括准备条件、安装 Airflow Provider 以及验证步骤。

### 1. **准备条件**

#### 1.1 确保 Kubernetes 集群已启用 Workload Identity
- 确保你的 Kubernetes 集群已经启用 Workload Identity，并且集群中的 Service Account 和 GCP Service Account 已正确绑定。

#### 1.2 确保 GCP Secret Manager 已设置
- 在 GCP Secret Manager 中为你的 Airflow 连接创建 Secret，并设置相应的 IAM 权限。

#### 1.3 确保 Airflow 运行环境
- 确保你的 Airflow 环境已经正确配置为使用 GCP Secret Manager 作为 Secrets Backend。

### 2. **安装 Airflow Provider**

#### 2.1 安装 Airflow Google Provider
确保你安装了最新版本的 Airflow Google Provider，以支持 GCP Secret Manager。

```bash
pip install apache-airflow-providers-google
```

#### 2.2 验证 Provider 安装
运行以下命令以验证 `apache-airflow-providers-google` 是否已正确安装：

```bash
pip show apache-airflow-providers-google
```

你应该看到有关 Provider 的详细信息，包括版本号和安装路径。

### 3. **配置 Airflow 使用 GCP Secret Manager**

#### 3.1 配置 `airflow.cfg`
确保你的 `airflow.cfg` 文件中配置了 GCP Secret Manager 作为 Secrets Backend。

```ini
[secrets]
backend = airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend
backend_kwargs = {"connections_prefix": "airflow-connections", "project_id": "your-gcp-project-id"}
```

### 4. **验证 GCP Secret Manager 配置**

#### 4.1 检查 Secret Manager 中的 Secret
确保 Secret Manager 中有正确的 Secret，且命名和内容与 Airflow 连接要求一致。

```bash
gcloud secrets list
gcloud secrets versions list --secret="your-secret-name"
```

#### 4.2 验证 Secret 权限
确保 Kubernetes Service Account 拥有访问 GCP Secret Manager 的权限。

```bash
gcloud secrets get-iam-policy your-secret-name
```

确保你的 GCP Service Account 有 `roles/secretmanager.secretAccessor` 权限。

### 5. **在 Airflow 中验证连接**

#### 5.1 创建测试 DAG
创建一个简单的测试 DAG，确保它能够使用从 Secret Manager 获取的连接。

```python
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
from airflow.hooks.base_hook import BaseHook

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
}

with DAG(dag_id='test_secret_manager',
         default_args=default_args,
         schedule_interval=None) as dag:

    def check_connection():
        conn = BaseHook.get_connection("your-connection-id")
        print(f"Connection: {conn}")

    start = DummyOperator(task_id='start')
    check = PythonOperator(task_id='check_connection', python_callable=check_connection)

    start >> check
```

#### 5.2 运行和监控 DAG
- 部署并运行测试 DAG。
- 监控 DAG 运行情况，确保任务能正确读取和使用 GCP Secret Manager 中的连接。

#### 5.3 验证任务日志
- 检查 Airflow Web UI 中的任务日志，确保没有权限错误或连接错误。

### 6. **处理常见问题**

#### 6.1 如果连接未能成功加载
- 检查 Secret Manager 中的 Secret 名称是否与 Airflow 连接 ID 匹配。
- 确认 Kubernetes Service Account 是否正确映射到 GCP Service Account，并有相应的权限。

#### 6.2 如果 Airflow 报告权限错误
- 确保 GCP Service Account 被授予了 `roles/secretmanager.secretAccessor` 权限。
- 检查 IAM 权限是否正确配置。

#### 6.3 确保 Airflow 使用了正确的 Provider
- 确认 Airflow 配置文件中的 Secrets Backend 设置正确。
- 验证 Airflow 的日志中是否显示加载 GCP Secret Manager 的信息。

### 总结（Markdown 格式）

```markdown
## 验证 Workload Identity 和 GCP Secret Manager 配置的操作指南

### 1. 准备条件

1.1 确保 Kubernetes 集群已启用 Workload Identity

1.2 确保 GCP Secret Manager 已设置

1.3 确保 Airflow 运行环境

### 2. 安装 Airflow Provider

2.1 安装 Airflow Google Provider

```bash
pip install apache-airflow-providers-google
```

2.2 验证 Provider 安装

```bash
pip show apache-airflow-providers-google
```

### 3. 配置 Airflow 使用 GCP Secret Manager

3.1 配置 `airflow.cfg`

```ini
[secrets]
backend = airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend
backend_kwargs = {"connections_prefix": "airflow-connections", "project_id": "your-gcp-project-id"}
```

### 4. 验证 GCP Secret Manager 配置

4.1 检查 Secret Manager 中的 Secret

```bash
gcloud secrets list
gcloud secrets versions list --secret="your-secret-name"
```

4.2 验证 Secret 权限

```bash
gcloud secrets get-iam-policy your-secret-name
```

### 5. 在 Airflow 中验证连接

5.1 创建测试 DAG

```python
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
from airflow.hooks.base_hook import BaseHook
from airflow.operators.python_operator import PythonOperator

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
}

with DAG(dag_id='test_secret_manager',
         default_args=default_args,
         schedule_interval=None) as dag:

    def check_connection():
        conn = BaseHook.get_connection("your-connection-id")
        print(f"Connection: {conn}")

    start = DummyOperator(task_id='start')
    check = PythonOperator(task_id='check_connection', python_callable=check_connection)

    start >> check
```

5.2 运行和监控 DAG

5.3 验证任务日志

### 6. 处理常见问题

6.1 如果连接未能成功加载

6.2 如果 Airflow 报告权限错误

6.3 确保 Airflow 使用了正确的 Provider
```

这个指南涵盖了从配置到验证的所有步骤，确保你能够有效地设置和测试 GCP Secret Manager 和 Workload Identity 配置。

# 理论概述

要在不增加用户迁移成本的情况下，将 Airflow 的连接从原来的 metadata 存储迁移到 GCP Secret Manager 作为 External Secret Store，你可以通过以下方式简化迁移过程，并尽可能保持原有的工作流不变：

### 1. **使用 Airflow’s Secrets Backend 机制**:
   Airflow 支持 Secrets Backend，可以配置它直接从 GCP Secret Manager 中获取连接，而无需改变原来的连接使用方式。

### 2. **配置 GCP Secret Manager 作为 Secrets Backend**:
   在 `airflow.cfg` 中，配置 GCP Secret Manager 作为 External Secret Store：
   ```ini
   [secrets]
   backend = airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend
   backend_kwargs = {"connections_prefix": "airflow-connections", "project_id": "your-gcp-project-id"}
   ```

   - `connections_prefix` 用于指定 Secret 前缀，比如你可以将所有 Airflow connection 的 Secret 命名为 `airflow-connections-<conn_id>`。
   - `project_id` 是你 GCP 项目的 ID。

   这样，Airflow 会自动从 GCP Secret Manager 中获取连接信息，而不需要在每个 DAG 或任务中手动调用 Secret。

### 3. **保持现有的 Connection 逻辑**:
   用户可以继续使用 `airflow.models.Connection` 访问连接信息，而不需要更改现有代码或工作流。Airflow 会自动根据连接 ID 从 Secret Manager 中获取对应的连接。例如，如果用户有一个连接 `my_connection`，Airflow 会从 GCP Secret Manager 中查找 `airflow-connections-my_connection` 的 Secret。

### 4. **支持多用户 Service Account**:
   由于每个用户都有独立的 GCP Service Account，你可以在 GCP Secret Manager 中为每个用户的连接配置权限。具体做法是：
   - 为每个用户的 Service Account 授予读取相应连接 Secret 的权限（`Secret Accessor`）。
   - 确保 Kubernetes 中的 Airflow Pods 使用合适的 Service Account，这样用户的任务会自动使用他们的 GCP Service Account 来访问对应的 Secret。

### 5. **兼容性与迁移成本降低**:
   - 用户不需要改变他们如何在 DAG 中使用连接的方式，依然可以通过 `conn_id` 来访问连接。
   - GCP Secret Manager 作为 Secrets Backend 后，Airflow 会自动将连接请求从 metadata database 重定向到 Secret Manager，无需手动管理。

### 示例：
如果用户之前在 DAG 中使用连接如下：
```python
from airflow.hooks.base_hook import BaseHook

connection = BaseHook.get_connection("my_connection")
```
不需要任何修改。Airflow 会自动从 Secret Manager 中提取连接信息。

### 总结：
- 配置 GCP Secret Manager 作为 Airflow 的 Secrets Backend。
- 通过 `connections_prefix` 保持现有连接命名一致。
- 通过 GCP Service Account 控制不同用户的访问权限。
- 用户无需修改代码，Airflow 会自动处理连接的存储和访问。

这样可以大大降低迁移成本，简化从 metadata 到 GCP Secret Manager 的过渡过程。


# 禁用meta data connection

要防止用户在 Airflow 中使用 metadata 数据库中存储的连接（从而绕过安全检查），并确保所有连接必须从 GCP Secret Manager 中获取，你可以采取以下措施：

### 1. **禁用 Airflow Metadata 数据库中的连接访问**
   最直接的方法是禁用 Airflow 使用 metadata 数据库来管理连接。通过设置 Airflow 的配置，让它只能通过 External Secret Backend（如 GCP Secret Manager）来访问连接。具体步骤如下：

   #### 配置 Airflow 只使用 Secret Backend：
   在 `airflow.cfg` 中，设置 `secrets.backend` 为 GCP Secret Manager，**并移除默认的 metadata connection backend**。通过这种方式，Airflow 将只会查询 GCP Secret Manager 中的连接信息，而不会从数据库中获取连接：
   
   ```ini
   [secrets]
   backend = airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend
   backend_kwargs = {"connections_prefix": "airflow-connections", "project_id": "your-gcp-project-id"}
   ```

   默认情况下，Airflow 会先检查 metadata 数据库中的连接，再检查 Secrets Backend。通过移除 metadata 作为连接源，你可以强制 Airflow 只通过 GCP Secret Manager 访问连接。

### 2. **在 DAG Import 阶段检查连接来源**
   可以通过自定义 Airflow Plugin 或 Listener，在 DAG 导入时检查所有任务中的连接来源，并确保连接是从 GCP Secret Manager 获取的。若发现连接是从 metadata 中获取的，则抛出错误，避免 DAG 导入成功。

   你可以在 `airflow_local_settings.py` 中添加以下代码来进行连接检查：

   ```python
   from airflow.models import Connection
   from airflow.utils.db import provide_session

   @provide_session
   def validate_connection_source(session=None):
       # 获取所有连接，检查它们是否存储在 metadata 中
       connections = session.query(Connection).all()
       for conn in connections:
           if conn.conn_id.startswith("airflow-"):
               raise ValueError(f"Connection {conn.conn_id} is stored in the metadata database. Only GCP Secret Manager connections are allowed.")

   # 在每次 DAG 导入时执行连接检查
   def task_instance_start_listener():
       validate_connection_source()
   ```

   这样，在 DAG 导入时，Airflow 会自动检查连接来源，并拒绝任何存储在 metadata 数据库中的连接。

### 3. **清除现有的 Metadata 数据库中的连接**
   为确保没有用户意外或故意使用 metadata 数据库中的连接，可以主动清除现有的连接记录：

   1. 进入 Airflow metadata 数据库。
   2. 查找并删除所有 `connection` 表中的记录。
   3. 确保后续不再通过 metadata 数据库添加连接。

   你可以使用 SQL 来删除这些连接：
   ```sql
   DELETE FROM connection;
   ```

### 4. **限制通过 UI 添加连接**
   禁止用户通过 Airflow Web UI 添加或编辑连接，这样他们无法轻松地在 metadata 数据库中创建新连接。可以通过以下方式禁用 Airflow UI 中的连接管理功能：
   
   - **隐藏连接管理页面**：修改 Web UI 权限，移除用户对 `Connections` 菜单的访问权限。
   - **关闭 Web UI 中的创建连接功能**：修改 Airflow RBAC 配置，限制对连接的写权限。

### 5. **在 DAG 执行时检查连接使用**
   通过自定义 Airflow Hook，在任务执行时检查任务中使用的连接是否来自 GCP Secret Manager。如果检测到连接是从 metadata 中获取的，抛出异常中断任务执行。

   例如，在每个任务执行之前，验证 `conn_id` 的来源：
   ```python
   from airflow.hooks.base_hook import BaseHook

   def check_connection_source(conn_id):
       connection = BaseHook.get_connection(conn_id)
       if connection.extra_dejson.get("source") != "GCP Secret Manager":
           raise ValueError(f"Connection {conn_id} is not sourced from GCP Secret Manager.")

   # 在任务开始时调用该函数
   check_connection_source('my_connection')
   ```

### 6. **启用监控和审计**
   - 启用 Airflow 的审计日志，跟踪连接的创建和使用。如果某个用户尝试使用 metadata 数据库中的连接，可以记录下这些操作。
   - 在 GCP Secret Manager 中启用审计日志，以确保所有连接访问都记录在案，并监控潜在的越权访问行为。

### 总结：
1. 禁用 metadata 数据库中的连接，确保 Airflow 只从 GCP Secret Manager 获取连接。
2. 使用自定义 Listener 在 DAG 导入和任务执行时检查连接来源。
3. 清理 metadata 数据库中的现有连接，防止用户继续使用旧的连接。
4. 通过权限控制和 UI 限制，阻止用户在 metadata 中创建新连接。

通过这些措施，可以确保所有用户的连接都必须从 GCP Secret Manager 获取，并防止绕过安全检查。


# 使用公共连接


为了简化从 metadata 连接到 GCP Secret Manager 的迁移过程，同时保持一些连接为公用，以下是一个可行的方案，结合了 Service Account 的权限控制和共享连接的设置。

### 1. **保持用户专属的连接**
   每个用户专属的连接可以按照以下步骤迁移到 GCP Secret Manager，确保连接只对特定用户的 GCP Service Account 可见。

   #### 1.1 为用户创建专属 Secret
   为每个用户在 GCP Secret Manager 中创建他们的专属连接，例如：
   - `airflow-connections-user1-connection`
   - `airflow-connections-user2-connection`

   可以使用 `gcloud` 命令行工具创建并配置 Secret：
   ```bash
   gcloud secrets create airflow-connections-user1-connection --replication-policy="automatic"
   gcloud secrets versions add airflow-connections-user1-connection --data-file="user1_connection_data.txt"
   ```

   #### 1.2 配置权限
   使用 GCP IAM 设置每个用户的 GCP Service Account 只能访问其对应的 Secret：
   ```bash
   gcloud secrets add-iam-policy-binding airflow-connections-user1-connection \
       --member="serviceAccount:user1-service-account@your-project.iam.gserviceaccount.com" \
       --role="roles/secretmanager.secretAccessor"
   ```

   这样确保每个用户的 GCP Service Account 只能访问他们自己的连接。

### 2. **设置公用连接**
   对于公用连接（供多个用户使用），可以采取以下步骤：

   #### 2.1 创建公用 Secret
   将公用连接保存在一个公用的 Secret 中，例如：
   - `airflow-connections-public-connection`

   ```bash
   gcloud secrets create airflow-connections-public-connection --replication-policy="automatic"
   gcloud secrets versions add airflow-connections-public-connection --data-file="public_connection_data.txt"
   ```

   #### 2.2 配置公用权限
   为多个用户的 Service Account 授权访问这个公用 Secret：
   ```bash
   gcloud secrets add-iam-policy-binding airflow-connections-public-connection \
       --member="serviceAccount:user1-service-account@your-project.iam.gserviceaccount.com" \
       --role="roles/secretmanager.secretAccessor"

   gcloud secrets add-iam-policy-binding airflow-connections-public-connection \
       --member="serviceAccount:user2-service-account@your-project.iam.gserviceaccount.com" \
       --role="roles/secretmanager.secretAccessor"
   ```

   这样，`user1` 和 `user2` 的任务都可以访问公用连接。

### 3. **配置 Airflow Secrets Backend**
   在 `airflow.cfg` 中配置 GCP Secret Manager 作为 Secrets Backend：
   ```ini
   [secrets]
   backend = airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend
   backend_kwargs = {"connections_prefix": "airflow-connections", "project_id": "your-gcp-project-id"}
   ```

   这样，Airflow 会根据连接 ID 自动从 Secret Manager 获取连接。

### 4. **Airflow DAG 中使用连接**
   用户在 DAG 中不需要更改现有代码，仍然可以通过 `conn_id` 来获取连接。Airflow 会自动从 Secret Manager 中提取对应的连接。

   ```python
   from airflow.hooks.base_hook import BaseHook

   # 获取用户专属连接
   user_conn = BaseHook.get_connection("user1-connection")

   # 获取公用连接
   public_conn = BaseHook.get_connection("public-connection")
   ```

### 5. **处理兼容性问题**
   如果希望保持 metadata 数据库中的部分连接作为备用或兼容，可以将其保留，或者通过使用 **Secrets Backend** 的优先级机制来控制是否首先检查 Secret Manager 或 metadata 数据库。确保只对那些需要访问公用连接的用户授予相关 Secret 的权限。

### 总结方案（Markdown 格式）

```markdown
## 1. 为用户创建专属连接
为每个用户在 GCP Secret Manager 中创建专属连接，确保每个用户的 GCP Service Account 只能访问自己的连接。

```bash
# 为用户创建 Secret
gcloud secrets create airflow-connections-user1-connection --replication-policy="automatic"
gcloud secrets versions add airflow-connections-user1-connection --data-file="user1_connection_data.txt"

# 配置 IAM 权限
gcloud secrets add-iam-policy-binding airflow-connections-user1-connection \
    --member="serviceAccount:user1-service-account@your-project.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"
```

## 2. 创建和配置公用连接
为公用连接创建 Secret 并配置多个用户的访问权限。

```bash
# 创建公用 Secret
gcloud secrets create airflow-connections-public-connection --replication-policy="automatic"
gcloud secrets versions add airflow-connections-public-connection --data-file="public_connection_data.txt"

# 配置公用访问权限
gcloud secrets add-iam-policy-binding airflow-connections-public-connection \
    --member="serviceAccount:user1-service-account@your-project.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding airflow-connections-public-connection \
    --member="serviceAccount:user2-service-account@your-project.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"
```

## 3. 配置 Airflow 使用 GCP Secret Manager 作为 Secret Backend
在 `airflow.cfg` 中配置 Secret Backend。

```ini
[secrets]
backend = airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend
backend_kwargs = {"connections_prefix": "airflow-connections", "project_id": "your-gcp-project-id"}
```

## 4. 在 DAG 中使用连接
用户仍然可以通过 `conn_id` 获取连接，无需修改现有代码。

```python
from airflow.hooks.base_hook import BaseHook

# 获取用户专属连接
user_conn = BaseHook.get_connection("user1-connection")

# 获取公用连接
public_conn = BaseHook.get_connection("public-connection")
```

# 只有部分用户使用的公共连接


为了确保公用连接只供部分用户访问，你可以为每个公用连接单独配置 GCP Secret Manager 的访问权限，确保只有特定的用户能够访问这些连接。具体步骤如下：

### 1. **为公用连接设置特定用户的权限**
   对于每个公用连接，确保只给需要访问该连接的用户分配访问权限。这样，不是所有用户都能访问所有公用连接，而是根据需要进行权限分配。

#### 1.1 为每个公用连接创建 Secret
假设你有多个公用连接，例如 `public-connection1` 和 `public-connection2`，你可以分别为这些连接创建 Secret：

```bash
# 创建第一个公用连接 Secret
gcloud secrets create airflow-connections-public-connection1 --replication-policy="automatic"
gcloud secrets versions add airflow-connections-public-connection1 --data-file="public_connection1_data.txt"

# 创建第二个公用连接 Secret
gcloud secrets create airflow-connections-public-connection2 --replication-policy="automatic"
gcloud secrets versions add airflow-connections-public-connection2 --data-file="public_connection2_data.txt"
```

#### 1.2 分配用户访问权限
只给特定的用户（GCP Service Account）授予访问公用连接的权限：

```bash
# 分配 user1 和 user2 访问第一个公用连接的权限
gcloud secrets add-iam-policy-binding airflow-connections-public-connection1 \
    --member="serviceAccount:user1-service-account@your-project.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding airflow-connections-public-connection1 \
    --member="serviceAccount:user2-service-account@your-project.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"

# 仅分配 user3 访问第二个公用连接的权限
gcloud secrets add-iam-policy-binding airflow-connections-public-connection2 \
    --member="serviceAccount:user3-service-account@your-project.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"
```

通过这样配置，`user1` 和 `user2` 可以访问 `public-connection1`，但不能访问 `public-connection2`。而 `user3` 可以访问 `public-connection2`，但不能访问 `public-connection1`。

### 2. **在 Airflow 中使用公用连接**
用户在 Airflow DAG 中使用连接时，不需要知道底层的权限细节，Airflow 会根据配置的 `conn_id` 自动从 GCP Secret Manager 中获取正确的连接。

例如：
```python
from airflow.hooks.base_hook import BaseHook

# user1 或 user2 可以使用 public-connection1
public_conn1 = BaseHook.get_connection("public-connection1")

# 只有 user3 可以使用 public-connection2
public_conn2 = BaseHook.get_connection("public-connection2")
```

通过这种方式，公用连接能够精细化控制，确保不同用户只能访问他们被授权的公用连接。

# 使用service account 的注意事项

### 使用 **Workload Identity** 简化 Service Account 管理和防止用户隐私信息泄露

**Workload Identity** 是 GCP 中一种推荐的方式，用于在 Kubernetes 上的工作负载安全地访问 GCP 资源，而无需直接将服务账号的私钥分发给用户或应用。这有助于解决 Service Account 直接暴露或私钥泄露的问题，增强了安全性。

#### 为什么使用 Workload Identity？
1. **避免直接暴露 Service Account 私钥**：无需将 GCP Service Account 的私钥直接分发给每个用户或容器，减少私钥泄露的风险。
2. **简化管理**：通过 GCP IAM 配置 Kubernetes Service Account 和 GCP Service Account 的关联，简化了权限管理，减少了人为错误。
3. **动态分配权限**：工作负载在运行时使用与之关联的 Kubernetes Service Account，从而动态获得访问 GCP 资源（如 Secret Manager）的权限。

### 详细步骤：

#### 1. **启用 Workload Identity API**
首先，确保 GCP 项目中启用了 Workload Identity 相关的 API。

```bash
gcloud services enable iamcredentials.googleapis.com container.googleapis.com
```

#### 2. **创建 Kubernetes 集群并启用 Workload Identity**
在 Kubernetes 集群中启用 Workload Identity。这一步通常是在集群创建时完成。

```bash
gcloud container clusters create my-cluster \
    --workload-pool=YOUR_PROJECT_ID.svc.id.goog \
    --zone=YOUR_ZONE
```

这里，`YOUR_PROJECT_ID.svc.id.goog` 是工作负载池的名称。这个工作负载池用于将 Kubernetes Service Account 映射到 GCP IAM Service Account。

#### 3. **创建 Kubernetes Service Account**
为每个用户或工作负载创建一个 Kubernetes Service Account，用于运行相关的 Airflow 任务：

```bash
kubectl create serviceaccount user1-k8s-sa
```

#### 4. **创建 GCP Service Account**
为用户创建相应的 GCP Service Account，确保每个用户的 GCP Service Account 只能访问自己或公用的连接。

```bash
gcloud iam service-accounts create user1-gcp-sa \
    --description="Service Account for user1" \
    --display-name="user1-gcp-sa"
```

#### 5. **绑定 Kubernetes Service Account 和 GCP Service Account**
将 Kubernetes Service Account 绑定到 GCP Service Account，利用 IAM Policy 绑定来确保用户只可以通过工作负载访问 GCP 资源。

```bash
gcloud iam service-accounts add-iam-policy-binding user1-gcp-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/iam.workloadIdentityUser" \
    --member="serviceAccount:YOUR_PROJECT_ID.svc.id.goog[default/user1-k8s-sa]"
```

这意味着 Kubernetes 命名空间 `default` 中的 `user1-k8s-sa` Service Account 会映射到 GCP 中的 `user1-gcp-sa` Service Account。

#### 6. **配置 Airflow 任务以使用 Kubernetes Service Account**
在 Airflow 中配置任务时，确保每个任务使用相应的 Kubernetes Service Account。这可以通过 Helm 图表或任务定义中指定：

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: example-job
spec:
  template:
    spec:
      serviceAccountName: user1-k8s-sa  # 使用对应的K8S Service Account
      containers:
      - name: example-container
        image: gcr.io/YOUR_PROJECT_ID/example-image
```

#### 7. **管理连接权限**
通过 IAM 权限管理，确保 GCP Service Account 只能访问特定的 Secret。在 Secret Manager 中为每个 Secret 配置权限：

```bash
gcloud secrets add-iam-policy-binding airflow-connections-user1-connection \
    --member="serviceAccount:user1-gcp-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"
```

这样，`user1` 的 Kubernetes Service Account 通过 Workload Identity 自动映射到 `user1-gcp-sa`，并且仅此工作负载可以访问其相关的 GCP Secret。

### Workload Identity 的优点：

- **增强安全性**：避免分发 Service Account 私钥，提升了安全性。用户无法直接访问敏感的 GCP 服务，只能通过受限的 Kubernetes Service Account 进行访问。
- **精细权限控制**：可以为不同的工作负载分配不同的权限，确保用户无法越权访问他人的连接或敏感信息。
- **简化操作**：避免每次使用 GCP API 都要管理和配置 Service Account 私钥，使用 Workload Identity 实现自动化的权限分配。

### 可能的限制：
- **需要 Kubernetes 支持**：Workload Identity 仅在 Kubernetes 集群中可用，因此如果用户的部署环境不是基于 Kubernetes，可能无法使用这种方法。
- **复杂的初始设置**：对于不熟悉 GCP IAM 和 Kubernetes 权限管理的团队，Workload Identity 可能需要较高的初始设置成本。

### 总结步骤（Markdown 格式）

```markdown
## 使用 Workload Identity 简化服务账号并提升安全性

### 1. 启用 Workload Identity API

```bash
gcloud services enable iamcredentials.googleapis.com container.googleapis.com
```

### 2. 创建 Kubernetes 集群并启用 Workload Identity

```bash
gcloud container clusters create my-cluster \
    --workload-pool=YOUR_PROJECT_ID.svc.id.goog \
    --zone=YOUR_ZONE
```

### 3. 创建 Kubernetes Service Account

```bash
kubectl create serviceaccount user1-k8s-sa
```

### 4. 创建 GCP Service Account

```bash
gcloud iam service-accounts create user1-gcp-sa \
    --description="Service Account for user1" \
    --display-name="user1-gcp-sa"
```

### 5. 绑定 Kubernetes Service Account 和 GCP Service Account

```bash
gcloud iam service-accounts add-iam-policy-binding user1-gcp-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/iam.workloadIdentityUser" \
    --member="serviceAccount:YOUR_PROJECT_ID.svc.id.goog[default/user1-k8s-sa]"
```

### 6. 配置 Airflow 任务使用 Kubernetes Service Account

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: example-job
spec:
  template:
    spec:
      serviceAccountName: user1-k8s-sa  # 使用对应的K8S Service Account
      containers:
      - name: example-container
        image: gcr.io/YOUR_PROJECT_ID/example-image
```

### 7. 管理连接权限

```bash
gcloud secrets add-iam-policy-binding airflow-connections-user1-connection \
    --member="serviceAccount:user1-gcp-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"
```

