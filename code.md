CREATE TABLE "app" (
  "id" SERIAL PRIMARY KEY,
  "app_id" VARCHAR(64) NOT NULL DEFAULT 'default',
  "name" VARCHAR(500) NOT NULL DEFAULT 'default',
  "org_id" VARCHAR(32) NOT NULL DEFAULT 'default',
  "org_name" VARCHAR(64) NOT NULL DEFAULT 'default',
  "owner_name" VARCHAR(500) NOT NULL DEFAULT 'default',
  "owner_email" VARCHAR(500) NOT NULL DEFAULT 'default',
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "deleted_at" BIGINT NOT NULL DEFAULT 0,
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',
  "data_change_last_time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE ("app_id", "deleted_at")
);

COMMENT ON TABLE "app" IS 'Application table';

-- Column comments
COMMENT ON COLUMN "app"."id" IS 'Primary key';
COMMENT ON COLUMN "app"."app_id" IS 'App ID';
COMMENT ON COLUMN "app"."name" IS 'App name';
COMMENT ON COLUMN "app"."org_id" IS 'Organization ID';
COMMENT ON COLUMN "app"."org_name" IS 'Organization name';
COMMENT ON COLUMN "app"."owner_name" IS 'Owner name';
COMMENT ON COLUMN "app"."owner_email" IS 'Owner email';
COMMENT ON COLUMN "app"."is_deleted" IS 'Is deleted flag';
COMMENT ON COLUMN "app"."deleted_at" IS 'Delete timestamp (milliseconds)';
COMMENT ON COLUMN "app"."data_change_created_by" IS 'Creator email prefix';
COMMENT ON COLUMN "app"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "app"."data_change_last_modified_by" IS 'Last modifier email prefix';
COMMENT ON COLUMN "app"."data_change_last_time" IS 'Last modified time';

-- 添加索引
CREATE INDEX "idx_app_app_id" ON "app" ("app_id");
CREATE INDEX "idx_app_data_change_last_time" ON "app" ("data_change_last_time");
CREATE INDEX "idx_app_name" ON "app" ("name");



-- Dump of table appnamespace
-- ------------------------------------------------------------

CREATE TABLE app_namespace (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL DEFAULT '',
    app_id VARCHAR(64) NOT NULL DEFAULT '',
    format VARCHAR(32) NOT NULL DEFAULT 'properties',
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    comment VARCHAR(64) NOT NULL DEFAULT '',
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at BIGINT NOT NULL DEFAULT 0,
    data_change_created_by VARCHAR(64) NOT NULL DEFAULT 'default',
    data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_change_last_modified_by VARCHAR(64) DEFAULT '',
    data_change_last_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- Add comments
COMMENT ON TABLE app_namespace IS 'Definition of application namespaces';
COMMENT ON COLUMN app_namespace.id IS 'Auto-increment primary key';
COMMENT ON COLUMN app_namespace.name IS 'Namespace name, globally unique';
COMMENT ON COLUMN app_namespace.app_id IS 'App ID';
COMMENT ON COLUMN app_namespace.format IS 'Namespace format type';
COMMENT ON COLUMN app_namespace.is_public IS 'Whether the namespace is public';
COMMENT ON COLUMN app_namespace.comment IS 'Additional comments';
COMMENT ON COLUMN app_namespace.is_deleted IS '1: deleted, 0: normal';
COMMENT ON COLUMN app_namespace.deleted_at IS 'Delete timestamp in milliseconds';
COMMENT ON COLUMN app_namespace.data_change_created_by IS 'Creator email prefix';
COMMENT ON COLUMN app_namespace.data_change_created_time IS 'Creation timestamp';
COMMENT ON COLUMN app_namespace.data_change_last_modified_by IS 'Last modifier email prefix';
COMMENT ON COLUMN app_namespace.data_change_last_time IS 'Last modification timestamp';



-- Dump of table audit
-- ------------------------------------------------------------

CREATE TABLE audit (
    id SERIAL PRIMARY KEY,
    entity_name VARCHAR(50) NOT NULL DEFAULT 'default',
    entity_id INTEGER DEFAULT NULL,
    op_name VARCHAR(50) NOT NULL DEFAULT 'default',
    comment VARCHAR(500) DEFAULT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at BIGINT NOT NULL DEFAULT 0,
    data_change_created_by VARCHAR(64) NOT NULL DEFAULT 'default',
    data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_change_last_modified_by VARCHAR(64) DEFAULT '',
    data_change_last_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- Add comments
COMMENT ON TABLE audit IS 'Audit log table';
COMMENT ON COLUMN audit.id IS 'Primary key';
COMMENT ON COLUMN audit.entity_name IS 'Name of the table being audited';
COMMENT ON COLUMN audit.entity_id IS 'Record ID';
COMMENT ON COLUMN audit.op_name IS 'Operation type';
COMMENT ON COLUMN audit.comment IS 'Remarks';
COMMENT ON COLUMN audit.is_deleted IS '1: deleted, 0: normal';
COMMENT ON COLUMN audit.deleted_at IS 'Delete timestamp in milliseconds';
COMMENT ON COLUMN audit.data_change_created_by IS 'Creator email prefix';
COMMENT ON COLUMN audit.data_change_created_time IS 'Creation timestamp';
COMMENT ON COLUMN audit.data_change_last_modified_by IS 'Last modifier email prefix';
COMMENT ON COLUMN audit.data_change_last_time IS 'Last modification timestamp';



DROP TABLE IF EXISTS cluster;

-- Create Cluster table
CREATE TABLE cluster (
  id SERIAL PRIMARY KEY,  -- Auto-increment primary key
  name VARCHAR(32) NOT NULL DEFAULT '',  -- Cluster name
  app_id VARCHAR(64) NOT NULL DEFAULT '',  -- App ID
  parent_cluster_id INT NOT NULL DEFAULT 0,  -- Parent cluster ID
  comment VARCHAR(64),  -- Comment
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE,  -- 1: deleted, 0: normal
  deleted_at BIGINT NOT NULL DEFAULT 0,  -- Delete timestamp based on milliseconds
  data_change_created_by VARCHAR(64) NOT NULL DEFAULT 'default',  -- Creator email prefix
  data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  data_change_last_modified_by VARCHAR(64),  -- Last modified by email prefix
  data_change_last_time TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,  -- Last modified time
  CONSTRAINT uk_app_id_name_deleted_at UNIQUE (app_id, name, deleted_at)  -- Unique constraint on app_id, name, and deleted_at
);

-- Add comments for Cluster table
COMMENT ON COLUMN cluster.id IS 'Auto-increment primary key';
COMMENT ON COLUMN cluster.name IS 'Cluster name';
COMMENT ON COLUMN cluster.app_id IS 'App ID';
COMMENT ON COLUMN cluster.parent_cluster_id IS 'Parent cluster ID';
COMMENT ON COLUMN cluster.comment IS 'Comment';
COMMENT ON COLUMN cluster.is_deleted IS '1: deleted, 0: normal';
COMMENT ON COLUMN cluster.deleted_at IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN cluster.data_change_created_by IS 'Creator email prefix';
COMMENT ON COLUMN cluster.data_change_created_time IS 'Creation time';
COMMENT ON COLUMN cluster.data_change_last_modified_by IS 'Last modified by email prefix';
COMMENT ON COLUMN cluster.data_change_last_time IS 'Last modified time';

-- Create indexes for Cluster table
CREATE INDEX ix_parent_cluster_id ON cluster (parent_cluster_id);
CREATE INDEX data_change_last_time ON cluster (data_change_last_time);

-- Drop table if exists
DROP TABLE IF EXISTS commit;

-- Create Commit table
CREATE TABLE commit (
  id SERIAL PRIMARY KEY,  -- Primary key
  change_sets TEXT NOT NULL,  -- Changeset
  app_id VARCHAR(64) NOT NULL DEFAULT 'default',  -- App ID
  cluster_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Cluster name
  namespace_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Namespace name
  comment VARCHAR(500),  -- Comment
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE,  -- 1: deleted, 0: normal
  deleted_at BIGINT NOT NULL DEFAULT 0,  -- Delete timestamp based on milliseconds
  data_change_created_by VARCHAR(64) NOT NULL DEFAULT 'default',  -- Creator email prefix
  data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  data_change_last_modified_by VARCHAR(64),  -- Last modified by email prefix
  data_change_last_time TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,  -- Last modified time
  CONSTRAINT uk_app_id_cluster_name_namespace_name UNIQUE (app_id, cluster_name, namespace_name)  -- Unique constraint on app_id, cluster_name, and namespace_name
);

-- Add comments for Commit table
COMMENT ON COLUMN commit.id IS 'Primary key';
COMMENT ON COLUMN commit.change_sets IS 'Changeset';
COMMENT ON COLUMN commit.app_id IS 'App ID';
COMMENT ON COLUMN commit.cluster_name IS 'Cluster name';
COMMENT ON COLUMN commit.namespace_name IS 'Namespace name';
COMMENT ON COLUMN commit.comment IS 'Comment';
COMMENT ON COLUMN commit.is_deleted IS '1: deleted, 0: normal';
COMMENT ON COLUMN commit.deleted_at IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN commit.data_change_created_by IS 'Creator email prefix';
COMMENT ON COLUMN commit.data_change_created_time IS 'Creation time';
COMMENT ON COLUMN commit.data_change_last_modified_by IS 'Last modified by email prefix';
COMMENT ON COLUMN commit.data_change_last_time IS 'Last modified time';

-- Create indexes for Commit table
CREATE INDEX data_change_last_time ON commit (data_change_last_time);
CREATE INDEX app_id ON commit (app_id);
CREATE INDEX cluster_name ON commit (cluster_name);
CREATE INDEX namespace_name ON commit (namespace_name);

-- Drop table if exists
DROP TABLE IF EXISTS gray_release_rule;

-- Create GrayReleaseRule table
CREATE TABLE gray_release_rule (
  id SERIAL PRIMARY KEY,  -- Primary key
  app_id VARCHAR(64) NOT NULL DEFAULT 'default',  -- App ID
  cluster_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Cluster name
  namespace_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Namespace name
  branch_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Branch name
  rules VARCHAR(16000) DEFAULT '[]',  -- Gray release rules
  release_id INT NOT NULL DEFAULT 0,  -- Release ID
  branch_status SMALLINT DEFAULT 1,  -- Branch status: 0: delete, 1: active, 2: full release
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE,  -- 1: deleted, 0: normal
  deleted_at BIGINT NOT NULL DEFAULT 0,  -- Delete timestamp based on milliseconds
  data_change_created_by VARCHAR(64) NOT NULL DEFAULT 'default',  -- Creator email prefix
  data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  data_change_last_modified_by VARCHAR(64),  -- Last modified by email prefix
  data_change_last_time TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,  -- Last modified time
  CONSTRAINT uk_app_id_cluster_name_namespace_name UNIQUE (app_id, cluster_name, namespace_name)  -- Unique constraint on app_id, cluster_name, and namespace_name
);

-- Add comments for GrayReleaseRule table
COMMENT ON COLUMN gray_release_rule.id IS 'Primary key';
COMMENT ON COLUMN gray_release_rule.app_id IS 'App ID';
COMMENT ON COLUMN gray_release_rule.cluster_name IS 'Cluster name';
COMMENT ON COLUMN gray_release_rule.namespace_name IS 'Namespace name';
COMMENT ON COLUMN gray_release_rule.branch_name IS 'Branch name';
COMMENT ON COLUMN gray_release_rule.rules IS 'Gray release rules';
COMMENT ON COLUMN gray_release_rule.release_id IS 'Release ID';
COMMENT ON COLUMN gray_release_rule.branch_status IS 'Branch status: 0: delete, 1: active, 2: full release';
COMMENT ON COLUMN gray_release_rule.is_deleted IS '1: deleted, 0: normal';
COMMENT ON COLUMN gray_release_rule.deleted_at IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN gray_release_rule.data_change_created_by IS 'Creator email prefix';
COMMENT ON COLUMN gray_release_rule.data_change_created_time IS 'Creation time';
COMMENT ON COLUMN gray_release_rule.data_change_last_modified_by IS 'Last modified by email prefix';
COMMENT ON COLUMN gray_release_rule.data_change_last_time IS 'Last modified time';

-- Create indexes for GrayReleaseRule table
CREATE INDEX data_change_last_time ON gray_release_rule (data_change_last_time);
CREATE INDEX ix_namespace ON gray_release_rule (app_id, cluster_name, namespace_name);

-- Drop table if exists
DROP TABLE IF EXISTS instance;

-- Create Instance table
CREATE TABLE instance (
  id SERIAL PRIMARY KEY,  -- Auto-increment ID
  app_id VARCHAR(64) NOT NULL DEFAULT 'default',  -- App ID
  cluster_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Cluster name
  data_center VARCHAR(64) NOT NULL DEFAULT 'default',  -- Data center
  ip VARCHAR(32) NOT NULL DEFAULT '',  -- Instance IP
  data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  data_change_last_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Last modified time
  CONSTRAINT ix_unique_key UNIQUE (app_id, cluster_name, ip, data_center)  -- Unique constraint on app_id, cluster_name, ip, and data_center
);

-- Add comments for Instance table
COMMENT ON COLUMN instance.id IS 'Auto-increment ID';
COMMENT ON COLUMN instance.app_id IS 'App ID';
COMMENT ON COLUMN instance.cluster_name IS 'Cluster name';
COMMENT ON COLUMN instance.data_center IS 'Data center';
COMMENT ON COLUMN instance.ip IS 'Instance IP';
COMMENT ON COLUMN instance.data_change_created_time IS 'Creation time';
COMMENT ON COLUMN instance.data_change_last_time IS 'Last modified time';

-- Create indexes for Instance table
CREATE INDEX ix_ip ON instance (ip);
CREATE INDEX ix_data_change_last_time ON instance (data_change_last_time);

-- Drop table if exists
DROP TABLE IF EXISTS instance_config;

-- Create InstanceConfig table
CREATE TABLE instance_config (
  id SERIAL PRIMARY KEY,  -- Auto-increment ID
  instance_id INT NOT NULL,  -- Instance ID
  config_app_id VARCHAR(64) NOT NULL DEFAULT 'default',  -- Config App ID
  config_cluster_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Config Cluster name
  config_namespace_name VARCHAR(32) NOT NULL DEFAULT 'default',  -- Config Namespace name
  release_key VARCHAR(64) NOT NULL DEFAULT '',  -- Release key
  release_delivery_time TIMESTAMP,  -- Release delivery time
  data_change_created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  data_change_last_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Last modified time
  CONSTRAINT ix_unique_key UNIQUE (instance_id, config_app_id, config_namespace_name)  -- Unique constraint on instance_id, config_app_id, and config_namespace_name
);

-- Add comments for InstanceConfig table
COMMENT ON COLUMN instance_config.id IS 'Auto-increment ID';
COMMENT ON COLUMN instance_config.instance_id IS 'Instance ID';
COMMENT ON COLUMN instance_config.config_app_id IS 'Config App ID';
COMMENT ON COLUMN instance_config.config_cluster_name IS 'Config Cluster name';
COMMENT ON COLUMN instance_config.config_namespace_name IS 'Config Namespace name';
COMMENT ON COLUMN instance_config.release_key IS 'Release key';
COMMENT ON COLUMN instance_config.release_delivery_time IS 'Release delivery time';
COMMENT ON COLUMN instance_config.data_change_created_time IS 'Creation time';
COMMENT ON COLUMN instance_config.data_change_last_time IS 'Last modified time';

-- Create indexes for InstanceConfig table
CREATE INDEX ix_instance_config ON instance_config (instance_id, config_app_id, config_namespace_name);

-- Dump of table item
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "item";

CREATE TABLE "item" (
  "id" serial PRIMARY KEY,
  "namespace_id" integer NOT NULL DEFAULT 0,
  "key" varchar(128) NOT NULL DEFAULT 'default',
  "type" smallint NOT NULL DEFAULT 0,
  "value" text NOT NULL,
  "comment" varchar(1024) DEFAULT '',
  "line_num" integer DEFAULT 0,
  "is_deleted" boolean NOT NULL DEFAULT false,
  "deleted_at" bigint NOT NULL DEFAULT 0,
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" varchar(64) DEFAULT '',
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "item"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "item"."namespace_id" IS 'Cluster Namespace ID';
COMMENT ON COLUMN "item"."key" IS 'Configuration Item Key';
COMMENT ON COLUMN "item"."type" IS 'Configuration Item Type: 0: String, 1: Number, 2: Boolean, 3: JSON';
COMMENT ON COLUMN "item"."value" IS 'Configuration Item Value';
COMMENT ON COLUMN "item"."comment" IS 'Comment';
COMMENT ON COLUMN "item"."line_num" IS 'Line Number';
COMMENT ON COLUMN "item"."is_deleted" IS '1: Deleted, 0: Normal';
COMMENT ON COLUMN "item"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "item"."data_change_created_by" IS 'Created by email prefix';
COMMENT ON COLUMN "item"."data_change_created_time" IS 'Creation Time';
COMMENT ON COLUMN "item"."data_change_last_modified_by" IS 'Last Modified by email prefix';
COMMENT ON COLUMN "item"."data_change_last_time" IS 'Last Modified Time';

CREATE INDEX "ix_namespace_id" ON "item" ("namespace_id");
CREATE INDEX "ix_data_change_last_time" ON "item" ("data_change_last_time");

-- Dump of table "namespace"
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "namespace";

CREATE TABLE "namespace" (
  "id" serial PRIMARY KEY,
  "app_id" varchar(64) NOT NULL DEFAULT 'default',
  "cluster_name" varchar(32) NOT NULL DEFAULT 'default',
  "namespace_name" varchar(32) NOT NULL DEFAULT 'default',
  "is_deleted" boolean NOT NULL DEFAULT false,
  "deleted_at" bigint NOT NULL DEFAULT 0,
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" varchar(64) DEFAULT '',
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "namespace"."id" IS 'Auto-incremented primary key';
COMMENT ON COLUMN "namespace"."app_id" IS 'App ID';
COMMENT ON COLUMN "namespace"."cluster_name" IS 'Cluster Name';
COMMENT ON COLUMN "namespace"."namespace_name" IS 'Namespace Name';
COMMENT ON COLUMN "namespace"."is_deleted" IS '1: Deleted, 0: Normal';
COMMENT ON COLUMN "namespace"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "namespace"."data_change_created_by" IS 'Created by email prefix';
COMMENT ON COLUMN "namespace"."data_change_created_time" IS 'Creation Time';
COMMENT ON COLUMN "namespace"."data_change_last_modified_by" IS 'Last Modified by email prefix';
COMMENT ON COLUMN "namespace"."data_change_last_time" IS 'Last Modified Time';

CREATE UNIQUE INDEX "uk_app_id_cluster_name_namespace_name_deleted_at" ON "namespace" ("app_id", "cluster_name", "namespace_name", "deleted_at");
CREATE INDEX "ix_data_change_last_time" ON "namespace" ("data_change_last_time");
CREATE INDEX "ix_namespace_name" ON "namespace" ("namespace_name");

-- Dump of table "namespace_lock"
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "namespace_lock";

CREATE TABLE "namespace_lock" (
  "id" serial PRIMARY KEY,
  "namespace_id" integer NOT NULL DEFAULT 0,
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" varchar(64) DEFAULT '',
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  "is_deleted" boolean DEFAULT false,
  "deleted_at" bigint NOT NULL DEFAULT 0
);

COMMENT ON COLUMN "namespace_lock"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "namespace_lock"."namespace_id" IS 'Cluster Namespace ID';
COMMENT ON COLUMN "namespace_lock"."data_change_created_by" IS 'Created by email prefix';
COMMENT ON COLUMN "namespace_lock"."data_change_created_time" IS 'Creation Time';
COMMENT ON COLUMN "namespace_lock"."data_change_last_modified_by" IS 'Last Modified by email prefix';
COMMENT ON COLUMN "namespace_lock"."data_change_last_time" IS 'Last Modified Time';
COMMENT ON COLUMN "namespace_lock"."is_deleted" IS 'Soft delete status';
COMMENT ON COLUMN "namespace_lock"."deleted_at" IS 'Delete timestamp based on milliseconds';

CREATE UNIQUE INDEX "uk_namespace_id_deleted_at" ON "namespace_lock" ("namespace_id", "deleted_at");
CREATE INDEX "ix_data_change_last_time" ON "namespace_lock" ("data_change_last_time");

-- Dump of table "release"
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "release";

CREATE TABLE "release" (
  "id" serial PRIMARY KEY,
  "release_key" varchar(64) NOT NULL DEFAULT '',
  "name" varchar(64) NOT NULL DEFAULT 'default',
  "comment" varchar(256) DEFAULT NULL,
  "app_id" varchar(64) NOT NULL DEFAULT 'default',
  "cluster_name" varchar(32) NOT NULL DEFAULT 'default',
  "namespace_name" varchar(32) NOT NULL DEFAULT 'default',
  "configurations" text NOT NULL,
  "is_abandoned" boolean NOT NULL DEFAULT false,
  "is_deleted" boolean NOT NULL DEFAULT false,
  "deleted_at" bigint NOT NULL DEFAULT 0,
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" varchar(64) DEFAULT '',
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "release"."id" IS 'Auto-incremented primary key';
COMMENT ON COLUMN "release"."release_key" IS 'Release Key';
COMMENT ON COLUMN "release"."name" IS 'Release Name';
COMMENT ON COLUMN "release"."comment" IS 'Release Comment';
COMMENT ON COLUMN "release"."app_id" IS 'App ID';
COMMENT ON COLUMN "release"."cluster_name" IS 'Cluster Name';
COMMENT ON COLUMN "release"."namespace_name" IS 'Namespace Name';
COMMENT ON COLUMN "release"."configurations" IS 'Release Configurations';
COMMENT ON COLUMN "release"."is_abandoned" IS 'Is the release abandoned';
COMMENT ON COLUMN "release"."is_deleted" IS '1: Deleted, 0: Normal';
COMMENT ON COLUMN "release"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "release"."data_change_created_by" IS 'Created by email prefix';
COMMENT ON COLUMN "release"."data_change_created_time" IS 'Creation Time';
COMMENT ON COLUMN "release"."data_change_last_modified_by" IS 'Last Modified by email prefix';
COMMENT ON COLUMN "release"."data_change_last_time" IS 'Last Modified Time';

CREATE UNIQUE INDEX "uk_release_key_deleted_at" ON "release" ("release_key", "deleted_at");
CREATE INDEX "ix_app_id_cluster_name_namespace_name" ON "release" ("app_id", "cluster_name", "namespace_name");
CREATE INDEX "ix_data_change_last_time" ON "release" ("data_change_last_time");

-- Dump of table "release_history"
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "release_history";

CREATE TABLE "release_history" (
  "id" serial PRIMARY KEY,
  "app_id" varchar(64) NOT NULL DEFAULT 'default',
  "cluster_name" varchar(32) NOT NULL DEFAULT 'default',
  "namespace_name" varchar(32) NOT NULL DEFAULT 'default',
  "branch_name" varchar(32) NOT NULL DEFAULT 'default',
  "release_id" integer NOT NULL DEFAULT 0,
  "previous_release_id" integer NOT NULL DEFAULT 0,
  "operation" smallint NOT NULL DEFAULT 0,
  "operation_context" text NOT NULL,
  "is_deleted" boolean NOT NULL DEFAULT false,
  "deleted_at" bigint NOT NULL DEFAULT 0,
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" varchar(64) DEFAULT '',
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "release_history"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "release_history"."app_id" IS 'App ID';
COMMENT ON COLUMN "release_history"."cluster_name" IS 'Cluster Name';
COMMENT ON COLUMN "release_history"."namespace_name" IS 'Namespace Name';
COMMENT ON COLUMN "release_history"."branch_name" IS 'Release Branch Name';
COMMENT ON COLUMN "release_history"."release_id" IS 'Associated Release ID';
COMMENT ON COLUMN "release_history"."previous_release_id" IS 'Previous Release ID';
COMMENT ON COLUMN "release_history"."operation" IS 'Operation Type';
COMMENT ON COLUMN "release_history"."operation_context" IS 'Context of the Operation';
COMMENT ON COLUMN "release_history"."is_deleted" IS 'Soft delete status';
COMMENT ON COLUMN "release_history"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "release_history"."data_change_created_by" IS 'Created by email prefix';
COMMENT ON COLUMN "release_history"."data_change_created_time" IS 'Creation Time';
COMMENT ON COLUMN "release_history"."data_change_last_modified_by" IS 'Last Modified by email prefix';
COMMENT ON COLUMN "release_history"."data_change_last_time" IS 'Last Modified Time';

CREATE INDEX "ix_release_id" ON "release_history" ("release_id");
CREATE INDEX "ix_previous_release_id" ON "release_history" ("previous_release_id");
CREATE INDEX "ix_data_change_last_time" ON "release_history" ("data_change_last_time");




-- Dump of table releasemessage
-- ------------------------------------------------------------
-- Drop and create table release_message
DROP TABLE IF EXISTS "release_message";

CREATE TABLE "release_message" (
  "id" SERIAL PRIMARY KEY,  -- Auto increment primary key
  "message" VARCHAR(1024) NOT NULL DEFAULT '',  -- Message content
  "data_change_last_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP  -- Last modified time
);

COMMENT ON TABLE "release_message" IS 'Release messages';
COMMENT ON COLUMN "release_message"."id" IS 'Auto-increment primary key';
COMMENT ON COLUMN "release_message"."message" IS 'Content of the release message';
COMMENT ON COLUMN "release_message"."data_change_last_time" IS 'Last modified timestamp';

-- Indexes
CREATE INDEX "ix_release_message_data_change_last_time" ON "release_message" ("data_change_last_time");
CREATE INDEX "ix_release_message_message" ON "release_message" ("message");

-- Drop and create table server_config
DROP TABLE IF EXISTS "server_config";

CREATE TABLE "server_config" (
  "id" SERIAL PRIMARY KEY,  -- Auto-increment ID
  "key" VARCHAR(64) NOT NULL DEFAULT 'default',  -- Config key
  "cluster" VARCHAR(32) NOT NULL DEFAULT 'default',  -- Cluster name
  "value" VARCHAR(2048) NOT NULL DEFAULT 'default',  -- Config value
  "comment" VARCHAR(1024) DEFAULT '',  -- Optional comment
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,  -- Deletion flag
  "deleted_at" BIGINT NOT NULL DEFAULT 0,  -- Delete timestamp
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default',  -- Creator's email prefix
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',  -- Last modifier's email prefix
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP  -- Last modified time
);

COMMENT ON TABLE "server_config" IS 'Configuration service settings';
COMMENT ON COLUMN "server_config"."id" IS 'Auto-increment ID';
COMMENT ON COLUMN "server_config"."key" IS 'Config key';
COMMENT ON COLUMN "server_config"."cluster" IS 'Cluster name';
COMMENT ON COLUMN "server_config"."value" IS 'Config value';
COMMENT ON COLUMN "server_config"."comment" IS 'Optional comment';
COMMENT ON COLUMN "server_config"."is_deleted" IS 'Deletion flag';
COMMENT ON COLUMN "server_config"."deleted_at" IS 'Timestamp for deletion';
COMMENT ON COLUMN "server_config"."data_change_created_by" IS 'Creator email prefix';
COMMENT ON COLUMN "server_config"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "server_config"."data_change_last_modified_by" IS 'Last modifier email prefix';
COMMENT ON COLUMN "server_config"."data_change_last_time" IS 'Last modified timestamp';

-- Unique and other indexes
CREATE UNIQUE INDEX "uk_key_cluster_deleted_at" ON "server_config" ("key", "cluster", "deleted_at");
CREATE INDEX "ix_server_config_data_change_last_time" ON "server_config" ("data_change_last_time");

-- Drop and create table access_key
DROP TABLE IF EXISTS "access_key";

CREATE TABLE "access_key" (
  "id" SERIAL PRIMARY KEY,  -- Auto-increment ID
  "app_id" VARCHAR(64) NOT NULL DEFAULT 'default',  -- App ID
  "secret" VARCHAR(128) NOT NULL DEFAULT '',  -- Secret key
  "mode" SMALLINT NOT NULL DEFAULT 0,  -- Key mode, 0: filter, 1: observer
  "is_enabled" BOOLEAN NOT NULL DEFAULT FALSE,  -- Enable flag
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,  -- Deletion flag
  "deleted_at" BIGINT NOT NULL DEFAULT 0,  -- Delete timestamp
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default',  -- Creator's email prefix
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',  -- Last modifier's email prefix
  "data_change_last_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP  -- Last modified time
);

COMMENT ON TABLE "access_key" IS 'Access keys for applications';
COMMENT ON COLUMN "access_key"."id" IS 'Auto-increment primary key';
COMMENT ON COLUMN "access_key"."app_id" IS 'Application ID';
COMMENT ON COLUMN "access_key"."secret" IS 'Secret key';
COMMENT ON COLUMN "access_key"."mode" IS 'Key mode (0: filter, 1: observer)';
COMMENT ON COLUMN "access_key"."is_enabled" IS 'Enable flag';
COMMENT ON COLUMN "access_key"."is_deleted" IS 'Deletion flag';
COMMENT ON COLUMN "access_key"."deleted_at" IS 'Delete timestamp';
COMMENT ON COLUMN "access_key"."data_change_created_by" IS 'Creator email prefix';
COMMENT ON COLUMN "access_key"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "access_key"."data_change_last_modified_by" IS 'Last modifier email prefix';
COMMENT ON COLUMN "access_key"."data_change_last_time" IS 'Last modified timestamp';

-- Unique and other indexes
CREATE UNIQUE INDEX "uk_app_id_secret_deleted_at" ON "access_key" ("app_id", "secret", "deleted_at");
CREATE INDEX "ix_access_key_data_change_last_time" ON "access_key" ("data_change_last_time");

-- Drop and create table service_registry
DROP TABLE IF EXISTS "service_registry";

CREATE TABLE "service_registry" (
  "id" SERIAL PRIMARY KEY,  -- Auto-increment ID
  "service_name" VARCHAR(64) NOT NULL,  -- Service name
  "uri" VARCHAR(64) NOT NULL,  -- Service URI
  "cluster" VARCHAR(64) NOT NULL,  -- Cluster name
  "metadata" VARCHAR(1024) NOT NULL DEFAULT '{}',  -- Metadata (JSON)
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  "data_change_last_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP  -- Last modified time
);

COMMENT ON TABLE "service_registry" IS 'Service registry for managing services';
COMMENT ON COLUMN "service_registry"."id" IS 'Auto-increment ID';
COMMENT ON COLUMN "service_registry"."service_name" IS 'Name of the service';
COMMENT ON COLUMN "service_registry"."uri" IS 'URI for the service';
COMMENT ON COLUMN "service_registry"."cluster" IS 'Cluster or network partition';
COMMENT ON COLUMN "service_registry"."metadata" IS 'Metadata in key-value JSON format';
COMMENT ON COLUMN "service_registry"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "service_registry"."data_change_last_time" IS 'Last modified time';

-- Unique and other indexes
CREATE UNIQUE INDEX "ix_unique_key" ON "service_registry" ("service_name", "uri");
CREATE INDEX "ix_service_registry_data_change_last_time" ON "service_registry" ("data_change_last_time");

-- Drop and create table audit_log
DROP TABLE IF EXISTS "audit_log";

CREATE TABLE "audit_log" (
  "id" SERIAL PRIMARY KEY,  -- Primary key
  "trace_id" VARCHAR(32) NOT NULL DEFAULT '',  -- Trace ID
  "span_id" VARCHAR(32) NOT NULL DEFAULT '',  -- Span ID
  "parent_span_id" VARCHAR(32) DEFAULT NULL,  -- Parent Span ID
  "follows_from_span_id" VARCHAR(32) DEFAULT NULL,  -- Follows From Span ID
  "operator" VARCHAR(64) NOT NULL DEFAULT 'anonymous',  -- Operator
  "op_type" VARCHAR(50) NOT NULL DEFAULT 'default',  -- Operation type
  "op_name" VARCHAR(150) NOT NULL DEFAULT 'default',  -- Operation name
  "description" VARCHAR(200) DEFAULT NULL,  -- Description or remarks
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,  -- Deletion flag
  "deleted_at" BIGINT NOT NULL DEFAULT 0,  -- Delete timestamp
  "data_change_created_by" VARCHAR(64) DEFAULT NULL,  -- Creator's email prefix
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',  -- Last modifier's email prefix
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP  -- Last modified time
);

COMMENT ON TABLE "audit_log" IS 'Audit log table for tracking operations';
COMMENT ON COLUMN "audit_log"."id" IS 'Primary key';
COMMENT ON COLUMN "audit_log"."trace_id" IS 'Trace ID for the operation';
COMMENT ON COLUMN "audit_log"."span_id" IS 'Span ID for the operation';
COMMENT ON COLUMN "audit_log"."parent_span_id" IS 'Parent Span ID for the operation';
COMMENT ON COLUMN "audit_log"."follows_from_span_id" IS 'Follows From Span ID for the operation';
COMMENT ON COLUMN "audit_log"."operator" IS 'Operator performing the action';
COMMENT ON COLUMN "audit_log"."op_type" IS 'Type of the operation';
COMMENT ON COLUMN "audit_log"."op_name" IS 'Name of the operation';
COMMENT ON COLUMN "audit_log"."description" IS 'Description or remarks for the operation






















-- Drop table if exists app
DROP TABLE IF EXISTS "app";

-- Create table app
CREATE TABLE "app" (
  "id" SERIAL PRIMARY KEY, -- primary key
  "app_id" varchar(64) NOT NULL DEFAULT 'default', -- AppID
  "name" varchar(500) NOT NULL DEFAULT 'default', -- application name
  "org_id" varchar(32) NOT NULL DEFAULT 'default', -- department ID
  "org_name" varchar(64) NOT NULL DEFAULT 'default', -- department name
  "owner_name" varchar(500) NOT NULL DEFAULT 'default', -- owner name
  "owner_email" varchar(500) NOT NULL DEFAULT 'default', -- owner email
  "is_deleted" boolean NOT NULL DEFAULT false, -- 1: deleted, 0: normal
  "deleted_at" bigint NOT NULL DEFAULT 0, -- delete timestamp based on milliseconds
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default', -- created by email prefix
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- created time
  "data_change_last_modified_by" varchar(64) DEFAULT '', -- last modified by email prefix
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "app"."id" IS 'primary key';
COMMENT ON COLUMN "app"."app_id" IS 'AppID';
COMMENT ON COLUMN "app"."name" IS 'application name';
COMMENT ON COLUMN "app"."org_id" IS 'department ID';
COMMENT ON COLUMN "app"."org_name" IS 'department name';
COMMENT ON COLUMN "app"."owner_name" IS 'owner name';
COMMENT ON COLUMN "app"."owner_email" IS 'owner email';
COMMENT ON COLUMN "app"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "app"."deleted_at" IS 'delete timestamp based on milliseconds';
COMMENT ON COLUMN "app"."data_change_created_by" IS 'created by email prefix';
COMMENT ON COLUMN "app"."data_change_created_time" IS 'created time';
COMMENT ON COLUMN "app"."data_change_last_modified_by" IS 'last modified by email prefix';
COMMENT ON COLUMN "app"."data_change_last_time" IS 'last modified time';

-- Add unique index on app_id and deleted_at
CREATE UNIQUE INDEX "uk_app_id_deleted_at" ON "app" ("app_id", "deleted_at");

-- Add index on data_change_last_time
CREATE INDEX "data_change_last_time" ON "app" ("data_change_last_time");

-- Add index on name
CREATE INDEX "ix_name" ON "app" ("name");

-- Drop table if exists app_namespace
DROP TABLE IF EXISTS "app_namespace";

-- Create table app_namespace
CREATE TABLE "app_namespace" (
  "id" SERIAL PRIMARY KEY, -- auto increment primary key
  "name" varchar(32) NOT NULL DEFAULT '', -- namespace name, must be globally unique
  "app_id" varchar(64) NOT NULL DEFAULT '', -- app id
  "format" varchar(32) NOT NULL DEFAULT 'properties', -- namespace format type
  "is_public" boolean NOT NULL DEFAULT false, -- whether the namespace is public
  "comment" varchar(64) NOT NULL DEFAULT '', -- comment
  "is_deleted" boolean NOT NULL DEFAULT false, -- 1: deleted, 0: normal
  "deleted_at" bigint NOT NULL DEFAULT 0, -- delete timestamp based on milliseconds
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default', -- created by email prefix
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- created time
  "data_change_last_modified_by" varchar(64) DEFAULT '', -- last modified by email prefix
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "app_namespace"."id" IS 'auto increment primary key';
COMMENT ON COLUMN "app_namespace"."name" IS 'namespace name, must be globally unique';
COMMENT ON COLUMN "app_namespace"."app_id" IS 'app id';
COMMENT ON COLUMN "app_namespace"."format" IS 'namespace format type';
COMMENT ON COLUMN "app_namespace"."is_public" IS 'whether the namespace is public';
COMMENT ON COLUMN "app_namespace"."comment" IS 'comment';
COMMENT ON COLUMN "app_namespace"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "app_namespace"."deleted_at" IS 'delete timestamp based on milliseconds';
COMMENT ON COLUMN "app_namespace"."data_change_created_by" IS 'created by email prefix';
COMMENT ON COLUMN "app_namespace"."data_change_created_time" IS 'created time';
COMMENT ON COLUMN "app_namespace"."data_change_last_modified_by" IS 'last modified by email prefix';
COMMENT ON COLUMN "app_namespace"."data_change_last_time" IS 'last modified time';

-- Add unique index on app_id, name, and deleted_at
CREATE UNIQUE INDEX "uk_app_id_name_deleted_at" ON "app_namespace" ("app_id", "name", "deleted_at");

-- Add index on name and app_id
CREATE INDEX "name_app_id" ON "app_namespace" ("name", "app_id");

-- Add index on data_change_last_time
CREATE INDEX "data_change_last_time" ON "app_namespace" ("data_change_last_time");

-- Drop table if exists consumer
DROP TABLE IF EXISTS "consumer";

-- Create table consumer
CREATE TABLE "consumer" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "app_id" varchar(64) NOT NULL DEFAULT 'default', -- AppID
  "name" varchar(500) NOT NULL DEFAULT 'default', -- application name
  "org_id" varchar(32) NOT NULL DEFAULT 'default', -- department ID
  "org_name" varchar(64) NOT NULL DEFAULT 'default', -- department name
  "owner_name" varchar(500) NOT NULL DEFAULT 'default', -- owner name
  "owner_email" varchar(500) NOT NULL DEFAULT 'default', -- owner email
  "is_deleted" boolean NOT NULL DEFAULT false, -- 1: deleted, 0: normal
  "deleted_at" bigint NOT NULL DEFAULT 0, -- delete timestamp based on milliseconds
  "data_change_created_by" varchar(64) NOT NULL DEFAULT 'default', -- created by email prefix
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- created time
  "data_change_last_modified_by" varchar(64) DEFAULT '', -- last modified by email prefix
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "consumer"."id" IS 'auto increment Id';
COMMENT ON COLUMN "consumer"."app_id" IS 'AppID';
COMMENT ON COLUMN "consumer"."name" IS 'application name';
COMMENT ON COLUMN "consumer"."org_id" IS 'department ID';
COMMENT ON COLUMN "consumer"."org_name" IS 'department name';
COMMENT ON COLUMN "consumer"."owner_name" IS 'owner name';
COMMENT ON COLUMN "consumer"."owner_email" IS 'owner email';
COMMENT ON COLUMN "consumer"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "consumer"."deleted_at" IS 'delete timestamp based on milliseconds';
COMMENT ON COLUMN "consumer"."data_change_created_by" IS 'created by email prefix';
COMMENT ON COLUMN "consumer"."data_change_created_time" IS 'created time';
COMMENT ON COLUMN "consumer"."data_change_last_modified_by" IS 'last modified by email prefix';
COMMENT ON COLUMN "consumer"."data_change_last_time" IS 'last modified time';

-- Add unique index on app_id and deleted_at
CREATE UNIQUE INDEX "uk_app_id_deleted_at" ON "consumer" ("app_id", "deleted_at");

-- Add index on data_change_last_time
CREATE INDEX "data_change_last_time" ON "consumer" ("data_change_last_time");

-- Drop table if exists consumer_audit
DROP TABLE IF EXISTS "consumer_audit";

-- Create table consumer_audit
CREATE TABLE "consumer_audit" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "consumer_id" int NOT NULL, -- Consumer Id
  "uri" varchar(1024) NOT NULL DEFAULT '', -- accessed URI
  "method" varchar(16) NOT NULL DEFAULT '', -- accessed Method
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- created time
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "consumer_audit"."id" IS 'auto increment Id';
COMMENT ON COLUMN "consumer_audit"."consumer_id" IS 'Consumer Id';
COMMENT ON COLUMN "consumer_audit"."uri" IS 'accessed URI';
COMMENT ON COLUMN "consumer_audit"."method" IS 'accessed Method';
COMMENT ON COLUMN "consumer_audit"."data_change_created_time" IS 'created time';
COMMENT ON COLUMN "consumer_audit"."data_change_last_time" IS 'last modified time';

-- Add index on data_change_last_time
CREATE INDEX "ix_data_change_last_time" ON "consumer_audit" ("data_change_last_time");

-- Add index on consumer_id
CREATE INDEX "ix_consumer_id" ON "consumer_audit" ("consumer_id");

-- Drop table if exists consumer_role
DROP TABLE IF EXISTS "consumer_role";

-- Create table consumer_role
CREATE TABLE "consumer_role" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "consumer_id" int NOT NULL, -- Consumer Id
  "role" varchar(32) NOT NULL DEFAULT '', -- Role
  "data_change_created_time" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- created time
  "data_change_last_time" timestamp NULL DEFAULT CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "consumer_role"."id" IS 'auto increment Id';
COMMENT ON COLUMN "consumer_role"."consumer_id" IS 'Consumer Id';
COMMENT ON COLUMN "consumer_role"."role" IS 'Role';
COMMENT ON COLUMN "consumer_role"."data_change_created_time" IS 'created time';
COMMENT ON COLUMN "consumer_role"."data_change_last_time" IS 'last modified time';

-- Add index on consumer_id
CREATE INDEX "ix_consumer_id" ON "consumer_role" ("consumer_id");

-- Add index on role
CREATE INDEX "ix_role" ON "consumer_role" ("role");

-- Add index on data_change_last_time
CREATE INDEX "ix_data_change_last_time" ON "consumer_role" ("data_change_last_time");

-- Create table consumer_token
CREATE TABLE "consumer_token" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "consumer_id" INT NOT NULL, -- ConsumerId
  "token" VARCHAR(128) NOT NULL DEFAULT '', -- token
  "expires" TIMESTAMP NOT NULL DEFAULT '2099-01-01 00:00:00', -- token expiry time
  "is_deleted" BIT NOT NULL DEFAULT b'0', -- 1: deleted, 0: normal
  "deleted_at" BIGINT NOT NULL DEFAULT 0, -- Delete timestamp based on milliseconds
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default', -- created by (email prefix)
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '', -- last modified by (email prefix)
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "consumer_token"."id" IS 'auto increment Id';
COMMENT ON COLUMN "consumer_token"."consumer_id" IS 'ConsumerId';
COMMENT ON COLUMN "consumer_token"."token" IS 'token';
COMMENT ON COLUMN "consumer_token"."expires" IS 'token expiry time';
COMMENT ON COLUMN "consumer_token"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "consumer_token"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "consumer_token"."data_change_created_by" IS 'created by (email prefix)';
COMMENT ON COLUMN "consumer_token"."data_change_created_time" IS 'creation time';
COMMENT ON COLUMN "consumer_token"."data_change_last_modified_by" IS 'last modified by (email prefix)';
COMMENT ON COLUMN "consumer_token"."data_change_last_time" IS 'last modified time';

-- Add indexes
CREATE UNIQUE INDEX "uk_token_deleted_at" ON "consumer_token" ("token", "deleted_at");
CREATE INDEX "ix_data_change_last_time" ON "consumer_token" ("data_change_last_time");

-- Create table favorite
CREATE TABLE "favorite" (
  "id" SERIAL PRIMARY KEY, -- primary key
  "user_id" VARCHAR(32) NOT NULL DEFAULT 'default', -- user who favorited
  "app_id" VARCHAR(64) NOT NULL DEFAULT 'default', -- app ID
  "position" INT NOT NULL DEFAULT 10000, -- favorite order
  "is_deleted" BIT NOT NULL DEFAULT b'0', -- 1: deleted, 0: normal
  "deleted_at" BIGINT NOT NULL DEFAULT 0, -- Delete timestamp based on milliseconds
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default', -- created by (email prefix)
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '', -- last modified by (email prefix)
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "favorite"."id" IS 'primary key';
COMMENT ON COLUMN "favorite"."user_id" IS 'user who favorited';
COMMENT ON COLUMN "favorite"."app_id" IS 'app ID';
COMMENT ON COLUMN "favorite"."position" IS 'favorite order';
COMMENT ON COLUMN "favorite"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "favorite"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "favorite"."data_change_created_by" IS 'created by (email prefix)';
COMMENT ON COLUMN "favorite"."data_change_created_time" IS 'creation time';
COMMENT ON COLUMN "favorite"."data_change_last_modified_by" IS 'last modified by (email prefix)';
COMMENT ON COLUMN "favorite"."data_change_last_time" IS 'last modified time';

-- Add indexes
CREATE UNIQUE INDEX "uk_user_id_app_id_deleted_at" ON "favorite" ("user_id", "app_id", "deleted_at");
CREATE INDEX "ix_app_id" ON "favorite" ("app_id");
CREATE INDEX "ix_data_change_last_time" ON "favorite" ("data_change_last_time");

-- Create table permission
CREATE TABLE "permission" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "permission_type" VARCHAR(32) NOT NULL DEFAULT '', -- permission type
  "target_id" VARCHAR(256) NOT NULL DEFAULT '', -- permission target object type
  "is_deleted" BIT NOT NULL DEFAULT b'0', -- 1: deleted, 0: normal
  "deleted_at" BIGINT NOT NULL DEFAULT 0, -- Delete timestamp based on milliseconds
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default', -- created by (email prefix)
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '', -- last modified by (email prefix)
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "permission"."id" IS 'auto increment Id';
COMMENT ON COLUMN "permission"."permission_type" IS 'permission type';
COMMENT ON COLUMN "permission"."target_id" IS 'permission target object type';
COMMENT ON COLUMN "permission"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "permission"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "permission"."data_change_created_by" IS 'created by (email prefix)';
COMMENT ON COLUMN "permission"."data_change_created_time" IS 'creation time';
COMMENT ON COLUMN "permission"."data_change_last_modified_by" IS 'last modified by (email prefix)';
COMMENT ON COLUMN "permission"."data_change_last_time" IS 'last modified time';

-- Add indexes
CREATE UNIQUE INDEX "uk_target_id_permission_type_deleted_at" ON "permission" ("target_id", "permission_type", "deleted_at");
CREATE INDEX "ix_data_change_last_time" ON "permission" ("data_change_last_time");

-- Create table role
CREATE TABLE "role" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "role_name" VARCHAR(256) NOT NULL DEFAULT '', -- role name
  "is_deleted" BIT NOT NULL DEFAULT b'0', -- 1: deleted, 0: normal
  "deleted_at" BIGINT NOT NULL DEFAULT 0, -- Delete timestamp based on milliseconds
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default', -- created by (email prefix)
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '', -- last modified by (email prefix)
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "role"."id" IS 'auto increment Id';
COMMENT ON COLUMN "role"."role_name" IS 'role name';
COMMENT ON COLUMN "role"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "role"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "role"."data_change_created_by" IS 'created by (email prefix)';
COMMENT ON COLUMN "role"."data_change_created_time" IS 'creation time';
COMMENT ON COLUMN "role"."data_change_last_modified_by" IS 'last modified by (email prefix)';
COMMENT ON COLUMN "role"."data_change_last_time" IS 'last modified time';

-- Add indexes
CREATE UNIQUE INDEX "uk_role_name_deleted_at" ON "role" ("role_name", "deleted_at");
CREATE INDEX "ix_data_change_last_time" ON "role" ("data_change_last_time");

-- Create table role_permission
CREATE TABLE "role_permission" (
  "id" SERIAL PRIMARY KEY, -- auto increment Id
  "role_id" INT NOT NULL, -- Role Id
  "permission_id" INT NOT NULL, -- Permission Id
  "is_deleted" BIT NOT NULL DEFAULT b'0', -- 1: deleted, 0: normal
  "deleted_at" BIGINT NOT NULL DEFAULT 0, -- Delete timestamp based on milliseconds
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default', -- created by (email prefix)
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- creation time
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '', -- last modified by (email prefix)
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- last modified time
);

-- Add comments
COMMENT ON COLUMN "role_permission"."id" IS 'auto increment Id';
COMMENT ON COLUMN "role_permission"."role_id" IS 'Role Id';
COMMENT ON COLUMN "role_permission"."permission_id" IS 'Permission Id';
COMMENT ON COLUMN "role_permission"."is_deleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "role_permission"."deleted_at" IS 'Delete timestamp based on milliseconds';
COMMENT ON COLUMN "role_permission"."data_change_created_by" IS 'created by (email prefix)';
COMMENT ON COLUMN "role_permission"."data_change_created_time" IS 'creation time';
COMMENT ON COLUMN "role_permission"."data_change_last_modified_by" IS 'last modified by (email prefix)';
COMMENT ON COLUMN "role_permission"."data_change_last_time" IS 'last modified time';

-- Add indexes
CREATE UNIQUE INDEX "uk_role_id_permission_id_deleted_at" ON "role_permission" ("role_id", "permission_id",

-- Dump of table serverconfig
-- ------------------------------------------------------------

DROP TABLE IF EXISTS serverconfig;

-- Create table server_config
CREATE TABLE "server_config" (
  "id" SERIAL PRIMARY KEY,
  "key" VARCHAR(64) NOT NULL DEFAULT 'default',
  "value" VARCHAR(2048) NOT NULL DEFAULT 'default',
  "comment" VARCHAR(1024) DEFAULT '',
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "deleted_at" BIGINT NOT NULL DEFAULT 0,
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',
  "data_change_last_time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE "server_config" IS 'Server configuration table';
COMMENT ON COLUMN "server_config"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "server_config"."key" IS 'Configuration key';
COMMENT ON COLUMN "server_config"."value" IS 'Configuration value';
COMMENT ON COLUMN "server_config"."comment" IS 'Comment';
COMMENT ON COLUMN "server_config"."is_deleted" IS 'Whether it is deleted: TRUE means deleted, FALSE means normal';
COMMENT ON COLUMN "server_config"."deleted_at" IS 'Deletion timestamp (in milliseconds)';
COMMENT ON COLUMN "server_config"."data_change_created_by" IS 'Creator';
COMMENT ON COLUMN "server_config"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "server_config"."data_change_last_modified_by" IS 'Last modified by';
COMMENT ON COLUMN "server_config"."data_change_last_time" IS 'Last modification time';

CREATE UNIQUE INDEX "uk_key_deleted_at" ON "server_config" ("key", "deleted_at");
CREATE INDEX "data_change_last_time" ON "server_config" ("data_change_last_time");

-- Create table user_role
CREATE TABLE "user_role" (
  "id" SERIAL PRIMARY KEY,
  "user_id" VARCHAR(128) DEFAULT '',
  "role_id" INTEGER,
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "deleted_at" BIGINT NOT NULL DEFAULT 0,
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',
  "data_change_last_time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE "user_role" IS 'User-role binding table';
COMMENT ON COLUMN "user_role"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "user_role"."user_id" IS 'User ID';
COMMENT ON COLUMN "user_role"."role_id" IS 'Role ID';
COMMENT ON COLUMN "user_role"."is_deleted" IS 'Whether it is deleted: TRUE means deleted, FALSE means normal';
COMMENT ON COLUMN "user_role"."deleted_at" IS 'Deletion timestamp (in milliseconds)';
COMMENT ON COLUMN "user_role"."data_change_created_by" IS 'Creator';
COMMENT ON COLUMN "user_role"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "user_role"."data_change_last_modified_by" IS 'Last modified by';
COMMENT ON COLUMN "user_role"."data_change_last_time" IS 'Last modification time';

CREATE UNIQUE INDEX "uk_user_id_role_id_deleted_at" ON "user_role" ("user_id", "role_id", "deleted_at");
CREATE INDEX "data_change_last_time" ON "user_role" ("data_change_last_time");
CREATE INDEX "role_id" ON "user_role" ("role_id");

-- Create table users
CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "username" VARCHAR(64) NOT NULL DEFAULT 'default',
  "password" VARCHAR(512) NOT NULL DEFAULT 'default',
  "user_display_name" VARCHAR(512) NOT NULL DEFAULT 'default',
  "email" VARCHAR(64) NOT NULL DEFAULT 'default',
  "enabled" SMALLINT DEFAULT NULL
);

COMMENT ON TABLE "users" IS 'User table';
COMMENT ON COLUMN "users"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "users"."username" IS 'Username';
COMMENT ON COLUMN "users"."password" IS 'Password';
COMMENT ON COLUMN "users"."user_display_name" IS 'Display name';
COMMENT ON COLUMN "users"."email" IS 'Email address';
COMMENT ON COLUMN "users"."enabled" IS 'Whether the user is enabled';

CREATE UNIQUE INDEX "uk_username" ON "users" ("username");

-- Create table authorities
CREATE TABLE "authorities" (
  "id" SERIAL PRIMARY KEY,
  "username" VARCHAR(64) NOT NULL,
  "authority" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "authorities" IS 'Authority table';
COMMENT ON COLUMN "authorities"."id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "authorities"."username" IS 'Username';
COMMENT ON COLUMN "authorities"."authority" IS 'Authority type';

-- Create table spring_session
CREATE TABLE "spring_session" (
  "primary_id" CHAR(36) NOT NULL,
  "session_id" CHAR(36) NOT NULL,
  "creation_time" BIGINT NOT NULL,
  "last_access_time" BIGINT NOT NULL,
  "max_inactive_interval" INTEGER NOT NULL,
  "expiry_time" BIGINT NOT NULL,
  "principal_name" VARCHAR(100) DEFAULT NULL
);

COMMENT ON TABLE "spring_session" IS 'Spring Session storage';
COMMENT ON COLUMN "spring_session"."primary_id" IS 'Primary ID';
COMMENT ON COLUMN "spring_session"."session_id" IS 'Session ID';
COMMENT ON COLUMN "spring_session"."creation_time" IS 'Creation time (in milliseconds)';
COMMENT ON COLUMN "spring_session"."last_access_time" IS 'Last access time (in milliseconds)';
COMMENT ON COLUMN "spring_session"."max_inactive_interval" IS 'Max inactive interval (in seconds)';
COMMENT ON COLUMN "spring_session"."expiry_time" IS 'Expiry time (in milliseconds)';
COMMENT ON COLUMN "spring_session"."principal_name" IS 'Username';

CREATE UNIQUE INDEX "spring_session_ix1" ON "spring_session" ("session_id");
CREATE INDEX "spring_session_ix2" ON "spring_session" ("expiry_time");
CREATE INDEX "spring_session_ix3" ON "spring_session" ("principal_name");

-- Create table spring_session_attributes
CREATE TABLE "spring_session_attributes" (
  "session_primary_id" CHAR(36) NOT NULL,
  "attribute_name" VARCHAR(200) NOT NULL,
  "attribute_bytes" BYTEA NOT NULL,
  CONSTRAINT "spring_session_attributes_fk" FOREIGN KEY ("session_primary_id") REFERENCES "spring_session" ("primary_id") ON DELETE CASCADE
);

COMMENT ON TABLE "spring_session_attributes" IS 'Spring Session attributes';
COMMENT ON COLUMN "spring_session_attributes"."session_primary_id" IS 'Session ID';
COMMENT ON COLUMN "spring_session_attributes"."attribute_name" IS 'Attribute name';
COMMENT ON COLUMN "spring_session_attributes"."attribute_bytes" IS 'Attribute value (in bytes)';

-- Create table audit_log
CREATE TABLE "audit_log" (
  "id" SERIAL PRIMARY KEY,
  "trace_id" VARCHAR(32) NOT NULL DEFAULT '',
  "span_id" VARCHAR(32) NOT NULL DEFAULT '',
  "parent_span_id" VARCHAR(32) DEFAULT NULL,
  "follows_from_span_id" VARCHAR(32) DEFAULT NULL,
  "operator" VARCHAR(64) NOT NULL DEFAULT 'anonymous',
  "op_type" VARCHAR(50) NOT NULL DEFAULT 'default',
  "op_name" VARCHAR(150) NOT NULL DEFAULT 'default',
  "description" VARCHAR(200) DEFAULT NULL,
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "deleted_at" BIGINT NOT NULL DEFAULT 0,
  "data_change_created_by" VARCHAR(64) NOT NULL DEFAULT 'default',
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',
  "data_change_last_time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE "audit_log" IS 'Audit log table';
COMMENT ON COLUMN "audit_log"."id" IS 'Primary ID';
COMMENT ON COLUMN "audit_log"."trace_id" IS 'Trace ID';
COMMENT ON COLUMN "audit_log"."span_id" IS 'Span ID';
COMMENT ON COLUMN "audit_log"."parent_span_id" IS 'Parent Span ID';
COMMENT ON COLUMN "audit_log"."follows_from_span_id" IS 'Follows-from Span ID';
COMMENT ON COLUMN "audit_log"."operator" IS 'Operator';
COMMENT ON COLUMN "audit_log"."op_type" IS 'Operation type';
COMMENT ON COLUMN "audit_log"."op_name" IS 'Operation name';
COMMENT ON COLUMN "audit_log"."description" IS 'Description';
COMMENT ON COLUMN "audit_log"."is_deleted" IS 'Whether it is deleted';
COMMENT ON COLUMN "audit_log"."deleted_at" IS 'Deletion timestamp (in milliseconds)';
COMMENT ON COLUMN "audit_log"."data_change_created_by" IS 'Creator';
COMMENT ON COLUMN "audit_log"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "audit_log"."data_change_last_modified_by" IS 'Last modified by';
COMMENT ON COLUMN "audit_log"."data_change_last_time" IS 'Last modification time';

CREATE INDEX "op_type" ON "audit_log" ("op_type");
CREATE INDEX "op_name" ON "audit_log" ("op_name");


-- Dump of table audit_log_data_influence
-- ------------------------------------------------------------

-- Create table audit_log_data_influence
CREATE TABLE "audit_log_data_influence" (
  "id" SERIAL PRIMARY KEY,
  "span_id" CHAR(32) NOT NULL DEFAULT '',
  "influence_entity_id" VARCHAR(50) NOT NULL DEFAULT '0',
  "influence_entity_name" VARCHAR(50) NOT NULL DEFAULT 'default',
  "field_name" VARCHAR(50) DEFAULT NULL,
  "field_old_value" VARCHAR(500) DEFAULT NULL,
  "field_new_value" VARCHAR(500) DEFAULT NULL,
  "is_deleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "deleted_at" BIGINT NOT NULL DEFAULT 0,
  "data_change_created_by" VARCHAR(64) DEFAULT NULL,
  "data_change_created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "data_change_last_modified_by" VARCHAR(64) DEFAULT '',
  "data_change_last_time" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

COMMENT ON TABLE "audit_log_data_influence" IS 'Audit log data influence table';
COMMENT ON COLUMN "audit_log_data_influence"."id" IS 'Primary key';
COMMENT ON COLUMN "audit_log_data_influence"."span_id" IS 'Span ID';
COMMENT ON COLUMN "audit_log_data_influence"."influence_entity_id" IS 'Record ID';
COMMENT ON COLUMN "audit_log_data_influence"."influence_entity_name" IS 'Table name';
COMMENT ON COLUMN "audit_log_data_influence"."field_name" IS 'Field name';
COMMENT ON COLUMN "audit_log_data_influence"."field_old_value" IS 'Old value of the field';
COMMENT ON COLUMN "audit_log_data_influence"."field_new_value" IS 'New value of the field';
COMMENT ON COLUMN "audit_log_data_influence"."is_deleted" IS 'TRUE: deleted, FALSE: normal';
COMMENT ON COLUMN "audit_log_data_influence"."deleted_at" IS 'Deletion timestamp based on milliseconds';
COMMENT ON COLUMN "audit_log_data_influence"."data_change_created_by" IS 'Creator email prefix';
COMMENT ON COLUMN "audit_log_data_influence"."data_change_created_time" IS 'Creation time';
COMMENT ON COLUMN "audit_log_data_influence"."data_change_last_modified_by" IS 'Last modified by email prefix';
COMMENT ON COLUMN "audit_log_data_influence"."data_change_last_time" IS 'Last modification time';

CREATE INDEX "ix_span_id" ON "audit_log_data_influence" ("span_id");
CREATE INDEX "ix_data_change_created_time" ON "audit_log_data_influence" ("data_change_created_time");
CREATE INDEX "ix_entity_id" ON "audit_log_data_influence" ("influence_entity_id");



-- Insert into serverconfig
INSERT INTO "server_config" ("key", "value", "comment")
VALUES
    ('apollo.portal.envs', 'dev', 'Supported environment list'),
    ('organizations', '[{"orgId":"TEST1","orgName":"Sample Department 1"},{"orgId":"TEST2","orgName":"Sample Department 2"}]', 'Department list'),
    ('superAdmin', 'apollo', 'Portal super administrator'),
    ('api.readTimeout', '10000', 'HTTP API read timeout'),
    ('consumer.token.salt', 'someSalt', 'Consumer token salt'),
    ('admin.createPrivateNamespace.switch', 'true', 'Whether project administrators can create private namespaces'),
    ('configView.memberOnly.envs', 'pro', 'The list of environments where configuration information is displayed only to project members, multiple envs separated by commas'),
    ('apollo.portal.meta.servers', '{}', 'Meta Service list for each environment');

-- Insert into users
INSERT INTO "users" ("username", "password", "user_display_name", "email", "enabled")
VALUES
    ('apollo', '$2a$10$7r20uS.BQ9uBpf3Baj3uQOZvMVvB1RN3PYoKE94gtz2.WAOuiiwXS', 'apollo', 'apollo@acme.com', TRUE);

-- Insert into authorities
INSERT INTO "authorities" ("username", "authority")
VALUES
    ('apollo', 'ROLE_user');






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


