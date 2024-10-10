-- Set encoding and timezone.
SET client_encoding = 'UTF8';
SET timezone = 'UTC';

-- Create database if it doesn't exist.
CREATE DATABASE IF NOT EXISTS ApolloConfigDB;

\c ApolloConfigDB;

-- Create table App.
CREATE TABLE "App" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for App table.',
    "AppId" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "Name" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Application name.',
    "OrgId" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Department ID.',
    "OrgName" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Department name.',
    "OwnerName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Owner name.',
    "OwnerEmail" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Owner email.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "AppId_idx" ON "App" ("AppId" varchar_pattern_ops);
CREATE INDEX "DataChange_LastTime_idx" ON "App" ("DataChange_LastTime");
CREATE INDEX "IX_Name_idx" ON "App" ("Name" varchar_pattern_ops);

COMMENT ON TABLE "App" IS 'Application table.';

-- Create table AppNamespace.
CREATE TABLE "AppNamespace" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for AppNamespace table.',
    "Name" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Namespace name. Needs to be globally unique.',
    "AppId" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'App ID.',
    "Format" VARCHAR(32) NOT NULL DEFAULT 'properties' COMMENT 'Namespace format type.',
    "IsPublic" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the namespace is public.',
    "Comment" VARCHAR(64) NOT NULL DEFAULT '' COMMENT 'Comment.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_AppId_idx" ON "AppNamespace" ("AppId");
CREATE INDEX "Name_AppId_idx" ON "AppNamespace" ("Name", "AppId");
CREATE INDEX "DataChange_LastTime_idx" ON "AppNamespace" ("DataChange_LastTime");

COMMENT ON TABLE "AppNamespace" IS 'Application namespace definition table.';

-- Create table Audit.
CREATE TABLE "Audit" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Audit table.',
    "EntityName" VARCHAR(50) NOT NULL DEFAULT 'default' COMMENT 'Table name.',
    "EntityId" INT NULL COMMENT 'Record ID.',
    "OpName" VARCHAR(50) NOT NULL DEFAULT 'default' COMMENT 'Operation type.',
    "Comment" VARCHAR(500) NULL COMMENT 'Remark.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "DataChange_LastTime_idx" ON "Audit" ("DataChange_LastTime");

COMMENT ON TABLE "Audit" IS 'Log audit table.';

-- Create table Cluster.
CREATE TABLE "Cluster" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Cluster table.',
    "Name" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Cluster name.',
    "AppId" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'App ID.',
    "ParentClusterId" INT NOT NULL DEFAULT 0 COMMENT 'Parent cluster ID.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_AppId_Name_idx" ON "Cluster" ("AppId", "Name");
CREATE INDEX "IX_ParentClusterId_idx" ON "Cluster" ("ParentClusterId");
CREATE INDEX "DataChange_LastTime_idx" ON "Cluster" ("DataChange_LastTime");

COMMENT ON TABLE "Cluster" IS 'Cluster table.';

-- Create table Commit.
CREATE TABLE "Commit" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Commit table.',
    "ChangeSets" TEXT NOT NULL COMMENT 'Change sets.',
    "AppId" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "ClusterName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Cluster name.',
    "NamespaceName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Namespace name.',
    "Comment" VARCHAR(500) NULL COMMENT 'Remark.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "DataChange_LastTime_idx" ON "Commit" ("DataChange_LastTime");
CREATE INDEX "AppId_idx" ON "Commit" ("AppId" varchar_pattern_ops);
CREATE INDEX "ClusterName_idx" ON "Commit" ("ClusterName" varchar_pattern_ops);
CREATE INDEX "NamespaceName_idx" ON "Commit" ("NamespaceName" varchar_pattern_ops);

COMMENT ON TABLE "Commit" IS 'Commit history table.';

-- Create table GrayReleaseRule.
CREATE TABLE "GrayReleaseRule" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for GrayReleaseRule table.',
    "AppId" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "ClusterName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Cluster name.',
    "NamespaceName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Namespace name.',
    "BranchName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Branch name.',
    "Rules" VARCHAR(16000) DEFAULT '[]' COMMENT 'Gray scale rules.',
    "ReleaseId" INT NOT NULL DEFAULT 0 COMMENT 'Gray scale corresponding release ID.',
    "BranchStatus" SMALLINT DEFAULT 1 COMMENT 'Gray scale branch status: 0: delete branch, 1: in-use rule, 2: full release.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "DataChange_LastTime_idx" ON "GrayReleaseRule" ("DataChange_LastTime");
CREATE INDEX "IX_Namespace_idx" ON "GrayReleaseRule" ("AppId", "ClusterName", "NamespaceName");

COMMENT ON TABLE "GrayReleaseRule" IS 'Gray scale rule table.';

-- Create table Instance.
CREATE TABLE "Instance" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Instance table.',
    "AppId" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "ClusterName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Cluster name.',
    "DataCenter" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Data center name.',
    "Ip" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Instance IP.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE UNIQUE INDEX "IX_UNIQUE_KEY_idx" ON "Instance" ("AppId", "ClusterName", "Ip", "DataCenter");
CREATE INDEX "IX_IP_idx" ON "Instance" ("Ip");
CREATE INDEX "IX_DataChange_LastTime_idx" ON "Instance" ("DataChange_LastTime");

COMMENT ON TABLE "Instance" IS 'Application instance using configuration table.';

-- Create table InstanceConfig.
CREATE TABLE "InstanceConfig" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for InstanceConfig table.',
    "InstanceId" INT NULL COMMENT 'Instance ID.',
    "ConfigAppId" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Config App ID.',
    "ConfigClusterName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Config cluster name.',
    "ConfigNamespaceName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Config namespace name.',
    "ReleaseKey" VARCHAR(64) NOT NULL DEFAULT '' COMMENT 'Release key.',
    "ReleaseDeliveryTime" TIMESTAMP NULL COMMENT 'Configuration acquisition time.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE UNIQUE INDEX "IX_UNIQUE_KEY_idx" ON "InstanceConfig" ("InstanceId", "ConfigAppId", "ConfigNamespaceName");
CREATE INDEX "IX_ReleaseKey_idx" ON "InstanceConfig" ("ReleaseKey");
CREATE INDEX "IX_DataChange_LastTime_idx" ON "InstanceConfig" ("DataChange_LastTime");
CREATE INDEX "IX_Valid_Namespace_idx" ON "InstanceConfig" ("ConfigAppId", "ConfigClusterName", "ConfigNamespaceName", "DataChange_LastTime");

COMMENT ON TABLE "InstanceConfig" IS 'Application instance configuration information table.';

-- Create table Item.
CREATE TABLE "Item" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Item table.',
    "NamespaceId" INT NOT NULL DEFAULT 0 COMMENT 'Cluster Namespace ID.',
    "Key" VARCHAR(128) NOT NULL DEFAULT 'default' COMMENT 'Configuration item key.',
    "Value" TEXT NOT NULL COMMENT 'Configuration item value.',
    "Comment" VARCHAR(1024) DEFAULT '' COMMENT 'Comment.',
    "LineNum" INT NOT NULL DEFAULT 0 COMMENT 'Line number.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_GroupId_idx" ON "Item" ("NamespaceId");
CREATE INDEX "DataChange_LastTime_idx" ON "Item" ("DataChange_LastTime");

COMMENT ON TABLE "Item" IS 'Configuration item table.';

-- Create table Namespace.
CREATE TABLE "Namespace" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Namespace table.',
    "AppId" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "ClusterName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Cluster name.',
    "NamespaceName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Namespace name.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "AppId_ClusterName_NamespaceName_idx" ON "Namespace" ("AppId" varchar_pattern_ops, "ClusterName" varchar_pattern_ops, "NamespaceName" varchar_pattern_ops);
CREATE INDEX "DataChange_LastTime_idx" ON "Namespace" ("DataChange_LastTime");
CREATE INDEX "IX_NamespaceName_idx" ON "Namespace" ("NamespaceName" varchar_pattern_ops);

COMMENT ON TABLE "Namespace" IS 'Namespace table.';

-- Create table NamespaceLock.
CREATE TABLE "NamespaceLock" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for NamespaceLock table.',
    "NamespaceId" INT NOT NULL DEFAULT 0 COMMENT 'Cluster Namespace ID.',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT 'default' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.',
    "IsDeleted" BOOLEAN DEFAULT FALSE COMMENT 'Soft delete flag.'
);

CREATE UNIQUE INDEX "IX_NamespaceId_idx" ON "NamespaceLock" ("NamespaceId");
CREATE INDEX "DataChange_LastTime_idx" ON "NamespaceLock" ("DataChange_LastTime");

COMMENT ON TABLE "NamespaceLock" IS 'Namespace edit lock table.';

-- Create table Release.
CREATE TABLE "Release" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Release table.',
    "ReleaseKey" VARCHAR(64) NOT NULL DEFAULT '' COMMENT 'Release key.',
    "Name" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Release name.',
    "Comment" VARCHAR(256) NULL COMMENT 'Release description.',
    "AppId" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "ClusterName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Cluster name.',
    "NamespaceName" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'Namespace name.',
    "Configurations" TEXT NOT NULL COMMENT 'Release configuration.',
    "IsAbandoned" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the release is abandoned.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "AppId_ClusterName_GroupName_idx" ON "Release" ("AppId" varchar_pattern_ops, "ClusterName" varchar_pattern_ops, "NamespaceName" varchar_pattern_ops);
CREATE INDEX "DataChange_LastTime_idx" ON "Release" ("DataChange_LastTime");
CREATE INDEX "IX_ReleaseKey_idx" ON "Release" ("ReleaseKey");

COMMENT ON TABLE "Release" IS 'Release table.';

-- Create table ReleaseHistory.
CREATE TABLE "ReleaseHistory" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Auto-incremented ID for release history.',
    "AppId" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Application ID.',
    "ClusterName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Cluster name.',
    "NamespaceName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Namespace name.',
    "BranchName" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Release branch name.',
    "ReleaseId" INT NOT NULL DEFAULT 0 COMMENT 'Associated release ID.',
    "PreviousReleaseId" INT NOT NULL DEFAULT 0 COMMENT 'Previous release ID.',
    "Operation" SMALLINT NOT NULL DEFAULT 0 COMMENT 'Release operation type: 0 - normal release, 1 - rollback, 2 - gray-scale release, 3 - gray-scale rule update, 4 - merge gray-scale back to main branch release, 5 - automatic gray-scale release on main branch release, 6 - automatic gray-scale release on main branch rollback, 7 - abandon gray-scale.',
    "OperationContext" TEXT NOT NULL COMMENT 'Release operation context information.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_Namespace_idx" ON "ReleaseHistory" ("AppId", "ClusterName", "NamespaceName", "BranchName");
CREATE INDEX "IX_ReleaseId_idx" ON "ReleaseHistory" ("ReleaseId");
CREATE INDEX "IX_DataChange_LastTime_idx" ON "ReleaseHistory" ("DataChange_LastTime");

COMMENT ON TABLE "ReleaseHistory" IS 'Release history table.';

-- Create table ReleaseMessage.
CREATE TABLE "ReleaseMessage" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Auto-incremented primary key for release message.',
    "Message" VARCHAR(1024) NOT NULL DEFAULT '' COMMENT 'Release message content.',
    "DataChange_LastTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "DataChange_LastTime_idx" ON "ReleaseMessage" ("DataChange_LastTime");
CREATE INDEX "IX_Message_idx" ON "ReleaseMessage" ("Message" varchar_pattern_ops);

COMMENT ON TABLE "ReleaseMessage" IS 'Release message table.';

-- Create table ServerConfig.
CREATE TABLE "ServerConfig" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Auto-incremented ID for server configuration.',
    "Key" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Configuration item key.',
    "Cluster" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Cluster corresponding to the configuration. Default means not for a specific cluster.',
    "Value" VARCHAR(2048) NOT NULL DEFAULT 'default' COMMENT 'Configuration item value.',
    "Comment" VARCHAR(1024) DEFAULT '' COMMENT 'Comment.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_Key_idx" ON "ServerConfig" ("Key");
CREATE INDEX "DataChange_LastTime_idx" ON "ServerConfig" ("DataChange_LastTime");

COMMENT ON TABLE "ServerConfig" IS 'Server configuration table.';

-- Insert data into ServerConfig table.
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES
    ('eureka.service.url', 'default', 'http://localhost:8080/eureka/', 'Eureka service URL. Multiple services separated by commas.'),
    ('namespace.lock.switch', 'default', 'false', 'Switch for one person can only modify one release at a time.'),
    ('item.value.length.limit', 'default', '20000', 'Maximum length limit for item value.'),
    ('config-service.cache.enabled', 'default', 'false', 'Whether to enable cache for ConfigService. Enabling can improve performance but increase memory consumption.'),
    ('item.key.length.limit', 'default', '128', 'Maximum length limit for item key.');

-- Insert data into App table.
INSERT INTO "App" ("AppId", "Name", "OrgId", "OrgName", "OwnerName", "OwnerEmail")
VALUES
    ('SampleApp', 'Sample App', 'TEST1', 'Sample department 1', 'apollo', 'apollo@acme.com');

-- Insert data into AppNamespace table.
INSERT INTO "AppNamespace" ("Name", "AppId", "Format", "IsPublic", "Comment")
VALUES
    ('application', 'SampleApp', 'properties', false, 'Default app namespace.');

-- Insert data into Cluster table.
INSERT INTO "Cluster" ("Name", "AppId")
VALUES
    ('default', 'SampleApp');

-- Insert data into Namespace table.
INSERT INTO "Namespace" ("Id", "AppId", "ClusterName", "NamespaceName")
VALUES
    (1, 'SampleApp', 'default', 'application');

-- Insert data into Item table.
INSERT INTO "Item" ("NamespaceId", "Key", "Value", "Comment", "LineNum")
VALUES
    (1, 'timeout', '100', 'Sample timeout configuration.', 1);

-- Insert data into Release table.
INSERT INTO "Release" ("ReleaseKey", "Name", "Comment", "AppId", "ClusterName", "NamespaceName", "Configurations")
VALUES
    ('20161009155425-d3a0749c6e20bc15', '20161009155424-release', 'Sample release.', 'SampleApp', 'default', 'application', '{"timeout":"100"}');

-- Insert data into ReleaseHistory table.
INSERT INTO "ReleaseHistory" ("AppId", "ClusterName", "NamespaceName", "BranchName", "ReleaseId", "PreviousReleaseId", "Operation", "OperationContext", "DataChange_CreatedBy", "DataChange_LastModifiedBy")
VALUES
    ('SampleApp', 'default', 'application', 'default', 1, 0, 0, '{}', 'apollo', 'apollo');
