-- Create Database
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ApolloConfigDB ENCODING 'UTF8';

-- Use the created database
\c ApolloConfigDB;

-- Dump of table app
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "App";

CREATE TABLE "App" (
  "Id" SERIAL PRIMARY KEY,
  "AppId" varchar(500) NOT NULL DEFAULT 'default',
  "Name" varchar(500) NOT NULL DEFAULT 'default',
  "OrgId" varchar(32) NOT NULL DEFAULT 'default',
  "OrgName" varchar(64) NOT NULL DEFAULT 'default',
  "OwnerName" varchar(500) NOT NULL DEFAULT 'default',
  "OwnerEmail" varchar(500) NOT NULL DEFAULT 'default',
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "App"."Id" IS 'Primary key';
COMMENT ON COLUMN "App"."AppId" IS 'App ID';
COMMENT ON COLUMN "App"."Name" IS 'Application name';
COMMENT ON COLUMN "App"."OrgId" IS 'Organization ID';
COMMENT ON COLUMN "App"."OrgName" IS 'Organization name';
COMMENT ON COLUMN "App"."OwnerName" IS 'Owner name';
COMMENT ON COLUMN "App"."OwnerEmail" IS 'Owner email';
COMMENT ON COLUMN "App"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "App"."DataChange_CreatedBy" IS 'Created by (email prefix)';
COMMENT ON COLUMN "App"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "App"."DataChange_LastModifiedBy" IS 'Last modified by (email prefix)';
COMMENT ON COLUMN "App"."DataChange_LastTime" IS 'Last modified time';

CREATE INDEX IF NOT EXISTS "AppId" ON "App" ("AppId");
CREATE INDEX IF NOT EXISTS "DataChange_LastTime" ON "App" ("DataChange_LastTime");
CREATE INDEX IF NOT EXISTS "IX_Name" ON "App" ("Name");

-- Dump of table appnamespace
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "AppNamespace";

CREATE TABLE "AppNamespace" (
  "Id" SERIAL PRIMARY KEY,
  "Name" varchar(32) NOT NULL DEFAULT '',
  "AppId" varchar(32) NOT NULL DEFAULT '',
  "Format" varchar(32) NOT NULL DEFAULT 'properties',
  "IsPublic" boolean NOT NULL DEFAULT FALSE,
  "Comment" varchar(64) NOT NULL DEFAULT '',
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "AppNamespace"."Id" IS 'Auto-increment primary key';
COMMENT ON COLUMN "AppNamespace"."Name" IS 'Namespace name, must be globally unique';
COMMENT ON COLUMN "AppNamespace"."AppId" IS 'App ID';
COMMENT ON COLUMN "AppNamespace"."Format" IS 'Namespace format type';
COMMENT ON COLUMN "AppNamespace"."IsPublic" IS 'Whether the namespace is public';
COMMENT ON COLUMN "AppNamespace"."Comment" IS 'Comments';
COMMENT ON COLUMN "AppNamespace"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "AppNamespace"."DataChange_CreatedBy" IS 'Created by (email prefix)';
COMMENT ON COLUMN "AppNamespace"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "AppNamespace"."DataChange_LastModifiedBy" IS 'Last modified by (email prefix)';
COMMENT ON COLUMN "AppNamespace"."DataChange_LastTime" IS 'Last modified time';

CREATE INDEX IF NOT EXISTS "IX_AppId" ON "AppNamespace" ("AppId");
CREATE UNIQUE INDEX IF NOT EXISTS "Name_AppId" ON "AppNamespace" ("Name", "AppId");
CREATE INDEX IF NOT EXISTS "DataChange_LastTime" ON "AppNamespace" ("DataChange_LastTime");

-- Dump of table audit
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Audit";

CREATE TABLE "Audit" (
  "Id" SERIAL PRIMARY KEY,
  "EntityName" varchar(50) NOT NULL DEFAULT 'default',
  "EntityId" integer,
  "OpName" varchar(50) NOT NULL DEFAULT 'default',
  "Comment" varchar(500) DEFAULT NULL,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "Audit"."Id" IS 'Primary key';
COMMENT ON COLUMN "Audit"."EntityName" IS 'Table name';
COMMENT ON COLUMN "Audit"."EntityId" IS 'Record ID';
COMMENT ON COLUMN "Audit"."OpName" IS 'Operation type';
COMMENT ON COLUMN "Audit"."Comment" IS 'Remarks';
COMMENT ON COLUMN "Audit"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Audit"."DataChange_CreatedBy" IS 'Created by (email prefix)';
COMMENT ON COLUMN "Audit"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Audit"."DataChange_LastModifiedBy" IS 'Last modified by (email prefix)';
COMMENT ON COLUMN "Audit"."DataChange_LastTime" IS 'Last modified time';

CREATE INDEX IF NOT EXISTS "DataChange_LastTime" ON "Audit" ("DataChange_LastTime");

-- Dump of table cluster
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Cluster";

CREATE TABLE "Cluster" (
  "Id" SERIAL PRIMARY KEY,
  "Name" varchar(32) NOT NULL DEFAULT '',
  "AppId" varchar(32) NOT NULL DEFAULT '',
  "ParentClusterId" integer NOT NULL DEFAULT 0,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "Cluster"."Id" IS 'Auto-increment primary key';
COMMENT ON COLUMN "Cluster"."Name" IS 'Cluster name';
COMMENT ON COLUMN "Cluster"."AppId" IS 'App ID';
COMMENT ON COLUMN "Cluster"."ParentClusterId" IS 'Parent cluster';
COMMENT ON COLUMN "Cluster"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Cluster"."DataChange_CreatedBy" IS 'Created by (email prefix)';
COMMENT ON COLUMN "Cluster"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Cluster"."DataChange_LastModifiedBy" IS 'Last modified by (email prefix)';
COMMENT ON COLUMN "Cluster"."DataChange_LastTime" IS 'Last modified time';

CREATE INDEX IF NOT EXISTS "IX_AppId_Name" ON "Cluster" ("AppId", "Name");
CREATE INDEX IF NOT EXISTS "IX_ParentClusterId" ON "Cluster" ("ParentClusterId");
CREATE INDEX IF NOT EXISTS "DataChange_LastTime" ON "Cluster" ("DataChange_LastTime");

-- Dump of table commit
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Commit";

CREATE TABLE "Commit" (
  "Id" SERIAL PRIMARY KEY,
  "ChangeSets" text NOT NULL,
  "AppId" varchar(500) NOT NULL DEFAULT 'default',
  "ClusterName" varchar(500) NOT NULL DEFAULT 'default',
  "NamespaceName" varchar(500) NOT NULL DEFAULT 'default',
  "Comment" varchar(500) DEFAULT NULL,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "Commit"."Id" IS 'Primary key';
COMMENT ON COLUMN "Commit"."ChangeSets" IS 'Change set';
COMMENT ON COLUMN "Commit"."AppId" IS 'App ID';
COMMENT ON COLUMN "Commit"."ClusterName" IS 'Cluster name';
COMMENT ON COLUMN "Commit"."NamespaceName" IS 'Namespace name';
COMMENT ON COLUMN "Commit"."Comment" IS 'Remarks';
COMMENT ON COLUMN "Commit"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Commit"."DataChange_CreatedBy" IS 'Created by (email prefix)';
COMMENT ON COLUMN "Commit"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Commit"."DataChange_LastModifiedBy" IS 'Last modified by (email prefix)';
COMMENT ON COLUMN "Commit"."DataChange_LastTime" IS 'Last modified time';

CREATE INDEX IF NOT EXISTS "DataChange_LastTime" ON "Commit" ("DataChange_LastTime");
CREATE INDEX IF NOT EXISTS "AppId" ON "Commit" ("AppId");
CREATE INDEX IF NOT EXISTS "ClusterName" ON "Commit" ("ClusterName");
CREATE INDEX IF NOT EXISTS "NamespaceName" ON "Commit" ("NamespaceName");

-- Dump of table grayreleaserule
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "GrayReleaseRule";

CREATE TABLE "GrayReleaseRule" (
  "Id" SERIAL PRIMARY KEY,
  "AppId" varchar(32) NOT NULL DEFAULT 'default',
  "ClusterName" varchar(32) NOT NULL DEFAULT 'default',
  "NamespaceName" varchar(32) NOT NULL DEFAULT 'default',
  "BranchName" varchar(32) NOT NULL DEFAULT 'default',
  "Rules" varchar(16000) DEFAULT '[]',
  "ReleaseId" integer NOT NULL DEFAULT 0,
  "BranchStatus" smallint DEFAULT 1,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "GrayReleaseRule"."Id" IS 'Primary key';
COMMENT ON COLUMN "GrayReleaseRule"."AppId" IS 'App ID';
COMMENT ON COLUMN "GrayReleaseRule"."ClusterName" IS 'Cluster name';
COMMENT ON COLUMN "GrayReleaseRule"."NamespaceName" IS 'Namespace name';
COMMENT ON COLUMN "GrayReleaseRule"."BranchName" IS 'Branch name';
COMMENT ON COLUMN "GrayReleaseRule"."Rules" IS 'Release rules';
COMMENT ON COLUMN "GrayReleaseRule"."ReleaseId" IS 'Release ID';
COMMENT ON COLUMN "GrayReleaseRule"."BranchStatus" IS 'Branch status: 0: deleted branch, 1: active rule, 2: full release';
COMMENT ON COLUMN "GrayReleaseRule"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "GrayReleaseRule"."DataChange_CreatedBy" IS 'Created by (email prefix)';
COMMENT ON COLUMN "GrayReleaseRule"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "GrayReleaseRule"."DataChange_LastModifiedBy" IS 'Last modified by (email prefix)';
COMMENT ON COLUMN "GrayReleaseRule"."DataChange_LastTime" IS 'Last modified time';

CREATE INDEX IF NOT EXISTS "DataChange_LastTime" ON "GrayReleaseRule" ("DataChange_LastTime");
CREATE INDEX IF NOT EXISTS "IX_Namespace" ON "GrayReleaseRule" ("AppId", "ClusterName", "NamespaceName");

-- Dump of table instance
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Instance";

CREATE TABLE "Instance" (
  "Id" SERIAL PRIMARY KEY,
  "AppId" varchar(32) NOT NULL DEFAULT 'default',
  "ClusterName" varchar(32) NOT NULL DEFAULT 'default',
  "DataCenter" varchar(64) NOT NULL DEFAULT 'default',
  "Ip" varchar(32) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "Instance"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "Instance"."AppId" IS 'App ID';
COMMENT ON COLUMN "Instance"."ClusterName" IS 'Cluster name';
COMMENT ON COLUMN "Instance"."DataCenter" IS 'Data center name';
COMMENT ON COLUMN "Instance"."Ip" IS 'Instance IP';
COMMENT ON COLUMN "Instance"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Instance"."DataChange_LastTime" IS 'Last modified time';

CREATE UNIQUE INDEX IF NOT EXISTS "IX_UNIQUE_KEY" ON "Instance" ("AppId", "ClusterName", "Ip", "DataCenter");
CREATE INDEX IF NOT EXISTS "IX_IP" ON "Instance" ("Ip");
CREATE INDEX IF NOT EXISTS "IX_DataChange_LastTime" ON "Instance" ("DataChange_LastTime");

-- Dump of table instanceconfig
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "InstanceConfig";

CREATE TABLE "InstanceConfig" (
  "Id" SERIAL PRIMARY KEY,
  "InstanceId" integer,
  "ConfigAppId" varchar(32) NOT NULL DEFAULT 'default',
  "ConfigClusterName" varchar(32) NOT NULL DEFAULT 'default',
  "ConfigNamespaceName" varchar(32) NOT NULL DEFAULT 'default',
  "ReleaseKey" varchar(64) NOT NULL DEFAULT '',
  "ReleaseDeliveryTime" timestamp without time zone,
  "DataChange_CreatedTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastTime" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "InstanceConfig"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "InstanceConfig"."InstanceId" IS 'Instance ID';
COMMENT ON COLUMN "InstanceConfig"."ConfigAppId" IS 'Config App ID';
COMMENT ON COLUMN "InstanceConfig"."ConfigClusterName" IS 'Config Cluster Name';
COMMENT ON COLUMN "InstanceConfig"."ConfigNamespaceName" IS 'Config Namespace Name';
COMMENT ON COLUMN "InstanceConfig"."ReleaseKey" IS 'Release key';
COMMENT ON COLUMN "InstanceConfig"."ReleaseDeliveryTime" IS 'Configuration delivery time';
COMMENT ON COLUMN "InstanceConfig"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "InstanceConfig"."DataChange_LastTime" IS 'Last modified time';

CREATE UNIQUE INDEX IF NOT EXISTS "IX_UNIQUE_KEY" ON "InstanceConfig" ("InstanceId", "ConfigAppId", "ConfigNamespaceName");
CREATE INDEX IF NOT EXISTS "IX_ReleaseKey" ON "InstanceConfig" ("ReleaseKey");
CREATE INDEX IF NOT EXISTS "IX_DataChange_LastTime" ON "InstanceConfig" ("DataChange_LastTime");
CREATE INDEX IF NOT EXISTS "IX_Valid_Namespace" ON "InstanceConfig" ("ConfigAppId", "ConfigClusterName", "ConfigNamespaceName", "DataChange_LastTime");

-- Drop and create table Item
DROP TABLE IF EXISTS "Item";

CREATE TABLE "Item" (
  "Id" serial NOT NULL,
  "NamespaceId" integer NOT NULL DEFAULT 0,
  "Key" varchar(128) NOT NULL DEFAULT 'default',
  "Value" text NOT NULL,
  "Comment" varchar(1024) DEFAULT '',
  "LineNum" integer DEFAULT 0,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("Id"),
  CONSTRAINT "IX_GroupId" UNIQUE ("NamespaceId"),
  CONSTRAINT "DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);
COMMENT ON TABLE "Item" IS 'Configuration Items';
COMMENT ON COLUMN "Item"."Id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "Item"."NamespaceId" IS 'Cluster Namespace ID';
COMMENT ON COLUMN "Item"."Key" IS 'Configuration Key';
COMMENT ON COLUMN "Item"."Value" IS 'Configuration Value';
COMMENT ON COLUMN "Item"."Comment" IS 'Comments';
COMMENT ON COLUMN "Item"."LineNum" IS 'Line Number';
COMMENT ON COLUMN "Item"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Item"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Item"."DataChange_CreatedTime" IS 'Creation Time';
COMMENT ON COLUMN "Item"."DataChange_LastModifiedBy" IS 'Last Modifier email prefix';
COMMENT ON COLUMN "Item"."DataChange_LastTime" IS 'Last Modification Time';

-- Dump of table Namespace
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Namespace";

CREATE TABLE "Namespace" (
  "Id" serial NOT NULL,
  "AppId" varchar(500) NOT NULL DEFAULT 'default',
  "ClusterName" varchar(500) NOT NULL DEFAULT 'default',
  "NamespaceName" varchar(500) NOT NULL DEFAULT 'default',
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("Id"),
  CONSTRAINT "AppId_ClusterName_NamespaceName" UNIQUE ("AppId"(191),"ClusterName"(191),"NamespaceName"(191)),
  CONSTRAINT "DataChange_LastTime" UNIQUE ("DataChange_LastTime"),
  CONSTRAINT "IX_NamespaceName" UNIQUE ("NamespaceName"(191))
) WITH (OIDS=FALSE);
COMMENT ON TABLE "Namespace" IS 'Namespaces';
COMMENT ON COLUMN "Namespace"."Id" IS 'Auto-incremented Primary Key';
COMMENT ON COLUMN "Namespace"."AppId" IS 'Application ID';
COMMENT ON COLUMN "Namespace"."ClusterName" IS 'Cluster Name';
COMMENT ON COLUMN "Namespace"."NamespaceName" IS 'Namespace Name';
COMMENT ON COLUMN "Namespace"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Namespace"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Namespace"."DataChange_CreatedTime" IS 'Creation Time';
COMMENT ON COLUMN "Namespace"."DataChange_LastModifiedBy" IS 'Last Modifier email prefix';
COMMENT ON COLUMN "Namespace"."DataChange_LastTime" IS 'Last Modification Time';

-- Dump of table NamespaceLock
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "NamespaceLock";

CREATE TABLE "NamespaceLock" (
  "Id" serial NOT NULL,
  "NamespaceId" integer NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT 'default',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "IsDeleted" boolean DEFAULT FALSE,
  PRIMARY KEY ("Id"),
  CONSTRAINT "IX_NamespaceId" UNIQUE ("NamespaceId"),
  CONSTRAINT "DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);
COMMENT ON TABLE "NamespaceLock" IS 'Namespace Edit Lock';
COMMENT ON COLUMN "NamespaceLock"."Id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "NamespaceLock"."NamespaceId" IS 'Cluster Namespace ID';
COMMENT ON COLUMN "NamespaceLock"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "NamespaceLock"."DataChange_CreatedTime" IS 'Creation Time';
COMMENT ON COLUMN "NamespaceLock"."DataChange_LastModifiedBy" IS 'Last Modifier email prefix';
COMMENT ON COLUMN "NamespaceLock"."DataChange_LastTime" IS 'Last Modification Time';
COMMENT ON COLUMN "NamespaceLock"."IsDeleted" IS 'Soft Delete';

-- Dump of table Release
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Release";

CREATE TABLE "Release" (
  "Id" serial NOT NULL,
  "ReleaseKey" varchar(64) NOT NULL DEFAULT '',
  "Name" varchar(64) NOT NULL DEFAULT 'default',
  "Comment" varchar(256) DEFAULT NULL,
  "AppId" varchar(500) NOT NULL DEFAULT 'default',
  "ClusterName" varchar(500) NOT NULL DEFAULT 'default',
  "NamespaceName" varchar(500) NOT NULL DEFAULT 'default',
  "Configurations" text NOT NULL,
  "IsAbandoned" boolean NOT NULL DEFAULT FALSE,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("Id"),
  CONSTRAINT "AppId_ClusterName_GroupName" UNIQUE ("AppId"(191),"ClusterName"(191),"NamespaceName"(191)),
  CONSTRAINT "DataChange_LastTime" UNIQUE ("DataChange_LastTime"),
  CONSTRAINT "IX_ReleaseKey" UNIQUE ("ReleaseKey")
) WITH (OIDS=FALSE);
COMMENT ON TABLE "Release" IS 'Releases';
COMMENT ON COLUMN "Release"."Id" IS 'Auto-incremented Primary Key';
COMMENT ON COLUMN "Release"."ReleaseKey" IS 'Release Key';
COMMENT ON COLUMN "Release"."Name" IS 'Release Name';
COMMENT ON COLUMN "Release"."Comment" IS 'Release Description';
COMMENT ON COLUMN "Release"."AppId" IS 'Application ID';
COMMENT ON COLUMN "Release"."ClusterName" IS 'Cluster Name';
COMMENT ON COLUMN "Release"."NamespaceName" IS 'Namespace Name';
COMMENT ON COLUMN "Release"."Configurations" IS 'Release Configurations';
COMMENT ON COLUMN "Release"."IsAbandoned" IS 'Whether abandoned';
COMMENT ON COLUMN "Release"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Release"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Release"."DataChange_CreatedTime" IS 'Creation Time';
COMMENT ON COLUMN "Release"."DataChange_LastModifiedBy" IS 'Last Modifier email prefix';
COMMENT ON COLUMN "Release"."DataChange_LastTime" IS 'Last Modification Time';

-- Dump of table ReleaseHistory
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "ReleaseHistory";

CREATE TABLE "ReleaseHistory" (
  "Id" serial NOT NULL,
  "AppId" varchar(32) NOT NULL DEFAULT 'default',
  "ClusterName" varchar(32) NOT NULL DEFAULT 'default',
  "NamespaceName" varchar(32) NOT NULL DEFAULT 'default',
  "BranchName" varchar(32) NOT NULL DEFAULT 'default',
  "ReleaseId" integer NOT NULL DEFAULT 0,
  "PreviousReleaseId" integer NOT NULL DEFAULT 0,
  "Operation" smallint NOT NULL DEFAULT 0,
  "OperationContext" text NOT NULL,
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("Id"),
  CONSTRAINT "IX_Namespace" UNIQUE ("AppId","ClusterName","NamespaceName","BranchName"),
  CONSTRAINT "IX_ReleaseId" UNIQUE ("ReleaseId"),
  CONSTRAINT "IX_DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);
COMMENT ON TABLE "ReleaseHistory" IS 'Release History';
COMMENT ON COLUMN "ReleaseHistory"."Id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "ReleaseHistory"."AppId" IS 'Application ID';
COMMENT ON COLUMN "ReleaseHistory"."ClusterName" IS 'Cluster Name';
COMMENT ON COLUMN "ReleaseHistory"."NamespaceName" IS 'Namespace Name';
COMMENT ON COLUMN "ReleaseHistory"."BranchName" IS 'Release Branch Name';
COMMENT ON COLUMN "ReleaseHistory"."ReleaseId" IS 'Associated Release ID';
COMMENT ON COLUMN "ReleaseHistory"."PreviousReleaseId" IS 'Previous Release ID';
COMMENT ON COLUMN "ReleaseHistory"."Operation" IS 'Release Type, 0: Normal Release, 1: Rollback, 2: Gray Release, 3: Gray Rule Update, 4: Merge Gray to Main Branch Release, 5: Auto Release Gray from Main Branch, 6: Auto Rollback Gray from Main Branch, 7: Abandon Gray';
COMMENT ON COLUMN "ReleaseHistory"."OperationContext" IS 'Release Context Information';
COMMENT ON COLUMN "ReleaseHistory"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "ReleaseHistory"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "ReleaseHistory"."DataChange_CreatedTime" IS 'Creation Time';
COMMENT ON COLUMN "ReleaseHistory"."DataChange_LastModifiedBy" IS 'Last Modifier email prefix';
COMMENT ON COLUMN "ReleaseHistory"."DataChange_LastTime" IS 'Last Modification Time';

-- Dump of table ReleaseMessage
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "ReleaseMessage";

CREATE TABLE "ReleaseMessage" (
  "Id" serial NOT NULL,
  "Message" varchar(1024) NOT NULL DEFAULT '',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("Id"),
  CONSTRAINT "DataChange_LastTime" UNIQUE ("DataChange_LastTime"),
  CONSTRAINT "IX_Message" UNIQUE ("Message"(191))
) WITH (OIDS=FALSE);
COMMENT ON TABLE "ReleaseMessage" IS 'Release Messages';
COMMENT ON COLUMN "ReleaseMessage"."Id" IS 'Auto-incremented Primary Key';
COMMENT ON COLUMN "ReleaseMessage"."Message" IS 'Release Message Content';
COMMENT ON COLUMN "ReleaseMessage"."DataChange_LastTime" IS 'Last Modification Time';

-- Dump of table ServerConfig
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "ServerConfig";

CREATE TABLE "ServerConfig" (
  "Id" serial NOT NULL,
  "Key" varchar(64) NOT NULL DEFAULT 'default',
  "Cluster" varchar(32) NOT NULL DEFAULT 'default',
  "Value" varchar(2048) NOT NULL DEFAULT 'default',
  "Comment" varchar(1024) DEFAULT '',
  "IsDeleted" boolean NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" varchar(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" varchar(32) DEFAULT '',
  "DataChange_LastTime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("Id"),
  CONSTRAINT "IX_Key" UNIQUE ("Key"),
  CONSTRAINT "DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);
COMMENT ON TABLE "ServerConfig" IS 'Configuration Service Own Configuration';
COMMENT ON COLUMN "ServerConfig"."Id" IS 'Auto-incremented ID';
COMMENT ON COLUMN "ServerConfig"."Key" IS 'Configuration Key';
COMMENT ON COLUMN "ServerConfig"."Cluster" IS 'Cluster, default for no specific cluster';
COMMENT ON COLUMN "ServerConfig"."Value" IS 'Configuration Value';
COMMENT ON COLUMN "ServerConfig"."Comment" IS 'Comments';
COMMENT ON COLUMN "ServerConfig"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "ServerConfig"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "ServerConfig"."DataChange_CreatedTime" IS 'Creation Time';
COMMENT ON COLUMN "ServerConfig"."DataChange_LastModifiedBy" IS 'Last Modifier email prefix';
COMMENT ON COLUMN "ServerConfig"."DataChange_LastTime" IS 'Last Modification Time';

-- Insertion of sample data
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES
    ('eureka.service.url', 'default', 'http://localhost:8080/eureka/', 'Eureka Service URLs, multiple services separated by commas'),
    ('namespace.lock.switch', 'default', 'false', 'Switch for only one person can edit at a time'),
    ('item.value.length.limit', 'default', '20000', 'Maximum length limit for item value'),
    ('config-service.cache.enabled', 'default', 'false', 'Whether Config Service cache is enabled, enabling it can improve performance but will increase memory consumption!'),
    ('item.key.length.limit', 'default', '128', 'Maximum length limit for item key');

INSERT INTO "App" ("AppId", "Name", "OrgId", "OrgName", "OwnerName", "OwnerEmail")
VALUES
  ('SampleApp', 'Sample App', 'TEST1', 'Sample Department 1', 'apollo', 'apollo@acme.com');

INSERT INTO "AppNamespace" ("Name", "AppId", "Format", "IsPublic", "Comment")
VALUES
  ('application', 'SampleApp', 'properties', 0, 'Default application namespace');

INSERT INTO "Cluster" ("Name", "AppId")
VALUES
  ('default', 'SampleApp');

INSERT INTO "Namespace" ("Id", "AppId", "ClusterName", "NamespaceName")
VALUES
  (1, 'SampleApp', 'default', 'application');

INSERT INTO "Item" ("NamespaceId", "Key", "Value", "Comment", "LineNum")
VALUES
  (1, 'timeout', '100', 'Sample timeout configuration', 1);

INSERT INTO "Release" ("ReleaseKey", "Name", "Comment", "AppId", "ClusterName", "NamespaceName", "Configurations")
VALUES
  ('20161009155425-d3a0749c6e20bc15', '20161009155424-release', 'Sample Release', 'SampleApp', 'default', 'application', '{\"timeout\":\"100\"}');

INSERT INTO "ReleaseHistory" ("AppId", "ClusterName", "NamespaceName", "BranchName", "ReleaseId", "PreviousReleaseId", "Operation", "OperationContext", "DataChange_CreatedBy", "DataChange_LastModifiedBy")
VALUES
  ('SampleApp', 'default', 'application', 'default', 1, 0, 0, '{}', 'apollo', 'apollo');
