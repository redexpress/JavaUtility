-- Set encoding and collation.
SET client_encoding = 'UTF8';
SET collation_connection = 'en_US.UTF-8';

-- Create database if it doesn't exist.
CREATE DATABASE IF NOT EXISTS ApolloPortalDB;

\c ApolloPortalDB;

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

-- Create table Consumer.
CREATE TABLE "Consumer" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Consumer table.',
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

CREATE INDEX "AppId_idx" ON "Consumer" ("AppId" varchar_pattern_ops);
CREATE INDEX "DataChange_LastTime_idx" ON "Consumer" ("DataChange_LastTime");

COMMENT ON TABLE "Consumer" IS 'Open API consumer table.';

-- Create table ConsumerAudit.
CREATE TABLE "ConsumerAudit" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for ConsumerAudit table.',
    "ConsumerId" INT NULL COMMENT 'Consumer ID.',
    "Uri" VARCHAR(1024) NOT NULL DEFAULT '' COMMENT 'Accessed URI.',
    "Method" VARCHAR(16) NOT NULL DEFAULT '' COMMENT 'Accessed method.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_DataChange_LastTime_idx" ON "ConsumerAudit" ("DataChange_LastTime");
CREATE INDEX "IX_ConsumerId_idx" ON "ConsumerAudit" ("ConsumerId");

COMMENT ON TABLE "ConsumerAudit" IS 'Consumer audit table.';

-- Create table ConsumerRole.
CREATE TABLE "ConsumerRole" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for ConsumerRole table.',
    "ConsumerId" INT NULL COMMENT 'Consumer ID.',
    "RoleId" INT NULL COMMENT 'Role ID.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_DataChange_LastTime_idx" ON "ConsumerRole" ("DataChange_LastTime");
CREATE INDEX "IX_RoleId_idx" ON "ConsumerRole" ("RoleId");
CREATE INDEX "IX_ConsumerId_RoleId_idx" ON "ConsumerRole" ("ConsumerId", "RoleId");

COMMENT ON TABLE "ConsumerRole" IS 'Binding table for consumer and role.';

-- Create table ConsumerToken.
CREATE TABLE "ConsumerToken" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for ConsumerToken table.',
    "ConsumerId" INT NULL COMMENT 'Consumer ID.',
    "Token" VARCHAR(128) NOT NULL DEFAULT '' COMMENT 'Token.',
    "Expires" TIMESTAMP NOT NULL DEFAULT '2099-01-01 00:00:00' COMMENT 'Token expiration time.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE UNIQUE INDEX "IX_Token_idx" ON "ConsumerToken" ("Token");
CREATE INDEX "DataChange_LastTime_idx" ON "ConsumerToken" ("DataChange_LastTime");

COMMENT ON TABLE "ConsumerToken" IS 'Consumer token table.';

-- Create table Favorite.
CREATE TABLE "Favorite" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Favorite table.',
    "UserId" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'User who favorited.',
    "AppId" VARCHAR(500) NOT NULL DEFAULT 'default' COMMENT 'App ID.',
    "Position" INT NOT NULL DEFAULT 10000 COMMENT 'Favorite order.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "AppId_idx" ON "Favorite" ("AppId" varchar_pattern_ops);
CREATE INDEX "IX_UserId_idx" ON "Favorite" ("UserId");
CREATE INDEX "DataChange_LastTime_idx" ON "Favorite" ("DataChange_LastTime");

COMMENT ON TABLE "Favorite" IS 'Application favorite table.';

-- Create table Permission.
CREATE TABLE "Permission" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Permission table.',
    "PermissionType" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Permission type.',
    "TargetId" VARCHAR(256) NOT NULL DEFAULT '' COMMENT 'Permission target type.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_TargetId_PermissionType_idx" ON "Permission" ("TargetId" varchar_pattern_ops, "PermissionType");
CREATE INDEX "IX_DataChange_LastTime_idx" ON "Permission" ("DataChange_LastTime");

COMMENT ON TABLE "Permission" IS 'Permission table.';

-- Create table Role.
CREATE TABLE "Role" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Role table.',
    "RoleName" VARCHAR(256) NOT NULL DEFAULT '' COMMENT 'Role name.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_RoleName_idx" ON "Role" ("RoleName" varchar_pattern_ops);
CREATE INDEX "IX_DataChange_LastTime_idx" ON "Role" ("DataChange_LastTime");

COMMENT ON TABLE "Role" IS 'Role table.';

-- Create table RolePermission.
CREATE TABLE "RolePermission" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for RolePermission table.',
    "RoleId" INT NULL COMMENT 'Role ID.',
    "PermissionId" INT NULL COMMENT 'Permission ID.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_DataChange_LastTime_idx" ON "RolePermission" ("DataChange_LastTime");
CREATE INDEX "IX_RoleId_idx" ON "RolePermission" ("RoleId");
CREATE INDEX "IX_PermissionId_idx" ON "RolePermission" ("PermissionId");

COMMENT ON TABLE "RolePermission" IS 'Binding table for role and permission.';

-- Create table ServerConfig.
CREATE TABLE "ServerConfig" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for ServerConfig table.',
    "Key" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Configuration item key.',
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

COMMENT ON TABLE "ServerConfig" IS 'Configuration service self-configuration table.';

-- Create table UserRole.
CREATE TABLE "UserRole" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for UserRole table.',
    "UserId" VARCHAR(128) DEFAULT '' COMMENT 'User identity.',
    "RoleId" INT NULL COMMENT 'Role ID.',
    "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if the record is deleted (1: deleted, 0: normal).',
    "DataChange_CreatedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the creator.',
    "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time.',
    "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Email prefix of the last modifier.',
    "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification time.'
);

CREATE INDEX "IX_DataChange_LastTime_idx" ON "UserRole" ("DataChange_LastTime");
CREATE INDEX "IX_RoleId_idx" ON "UserRole" ("RoleId");
CREATE INDEX "IX_UserId_RoleId_idx" ON "UserRole" ("UserId", "RoleId");

COMMENT ON TABLE "UserRole" IS 'Binding table for user and role.';

-- Create table Users.
CREATE TABLE "Users" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Users table.',
    "Username" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Username.',
    "Password" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Password.',
    "Email" VARCHAR(64) NOT NULL DEFAULT 'default' COMMENT 'Email address.',
    "Enabled" SMALLINT DEFAULT NULL COMMENT 'Flag indicating if the user is enabled.'
);

COMMENT ON TABLE "Users" IS 'User table.';

-- Create table Authorities.
CREATE TABLE "Authorities" (
    "Id" SERIAL NOT NULL PRIMARY KEY COMMENT 'Primary key for Authorities table.',
    "Username" VARCHAR(64) NOT NULL,
    "Authority" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "Authorities" IS 'Authorities table.';

-- Insert data into ServerConfig table.
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES
    ('apollo.portal.envs', 'dev', 'List of supported environments.'),
    ('organizations', '[{\"orgId\":\"TEST1\",\"orgName\":\"Sample department 1\"},{\"orgId\":\"TEST2\",\"orgName\":\"Sample department 2\"}]', 'Department list.'),
    ('superAdmin', 'apollo', 'Portal super administrator.'),
    ('api.readTimeout', '10000', 'HTTP interface read timeout.'),
    ('consumer.token.salt', 'someSalt', 'Consumer token salt.'),
    ('admin.createPrivateNamespace.switch', 'true', 'Whether project administrators are allowed to create private namespaces.');

-- Insert data into Users table.
INSERT INTO "Users" ("Username", "Password", "Email", "Enabled")
VALUES
    ('apollo', '$2a$10$7r20uS.BQ9uBpf3Baj3uQOZvMVvB1RN3PYoKE94gtz2.WAOuiiwXS', 'apollo@acme.com', 1);

-- Insert data into Authorities table.
INSERT INTO "Authorities" ("Username", "Authority")
VALUES
    ('apollo', 'ROLE_user');

-- Sample data section.
-- Insert data into App table.
INSERT INTO "App" ("AppId", "Name", "OrgId", "OrgName", "OwnerName", "OwnerEmail")
VALUES
    ('SampleApp', 'Sample App', 'TEST1', 'Sample department 1', 'apollo', 'apollo@acme.com');

-- Insert data into AppNamespace table.
INSERT INTO "AppNamespace" ("Name", "AppId", "Format", "IsPublic", "Comment")
VALUES
    ('application', 'SampleApp', 'properties', false, 'Default app namespace.');

-- Insert data into Permission table.
INSERT INTO "Permission" ("Id", "PermissionType", "TargetId")
VALUES
    (1, 'CreateCluster', 'SampleApp'),
    (2, 'CreateNamespace', 'SampleApp'),
    (3, 'AssignRole', 'SampleApp'),
    (4, 'ModifyNamespace', 'SampleApp+application'),
    (5, 'ReleaseNamespace', 'SampleApp+application');

-- Insert data into Role table.
INSERT INTO "Role" ("Id", "RoleName")
VALUES
    (1, 'Master+SampleApp'),
    (2, 'ModifyNamespace+SampleApp+application'),
    (3, 'ReleaseNamespace+SampleApp+application');

-- Insert data into RolePermission table.
INSERT INTO "RolePermission" ("RoleId", "PermissionId")
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (3, 5);

-- Insert data into UserRole table.
INSERT INTO "UserRole" ("UserId", "RoleId")
VALUES
    ('apollo', 1),
    ('apollo', 2),
    ('apollo', 3);
