-- Drop and create table App
DROP TABLE IF EXISTS "App";

CREATE TABLE "App" (
  "Id" SERIAL PRIMARY KEY,
  "AppId" VARCHAR(500) NOT NULL DEFAULT 'default',
  "Name" VARCHAR(500) NOT NULL DEFAULT 'default',
  "OrgId" VARCHAR(32) NOT NULL DEFAULT 'default',
  "OrgName" VARCHAR(64) NOT NULL DEFAULT 'default',
  "OwnerName" VARCHAR(500) NOT NULL DEFAULT 'default',
  "OwnerEmail" VARCHAR(500) NOT NULL DEFAULT 'default',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_AppId" UNIQUE ("AppId"),
  CONSTRAINT "IX_Name" UNIQUE ("Name")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "App" IS 'Application table';
COMMENT ON COLUMN "App"."Id" IS 'Primary key';
COMMENT ON COLUMN "App"."AppId" IS 'App ID';
COMMENT ON COLUMN "App"."Name" IS 'Application name';
COMMENT ON COLUMN "App"."OrgId" IS 'Organization ID';
COMMENT ON COLUMN "App"."OrgName" IS 'Organization name';
COMMENT ON COLUMN "App"."OwnerName" IS 'Owner name';
COMMENT ON COLUMN "App"."OwnerEmail" IS 'Owner email';
COMMENT ON COLUMN "App"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "App"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "App"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "App"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "App"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table AppNamespace
DROP TABLE IF EXISTS "AppNamespace";

CREATE TABLE "AppNamespace" (
  "Id" SERIAL PRIMARY KEY,
  "Name" VARCHAR(32) NOT NULL,
  "AppId" VARCHAR(32) NOT NULL,
  "Format" VARCHAR(32) NOT NULL DEFAULT 'properties',
  "IsPublic" BOOLEAN NOT NULL DEFAULT FALSE,
  "Comment" VARCHAR(64) NOT NULL DEFAULT '',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_Name_AppId" UNIQUE ("Name", "AppId"),
  CONSTRAINT "IX_DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "AppNamespace" IS 'Application namespace definition';
COMMENT ON COLUMN "AppNamespace"."Id" IS 'Auto-increment primary key';
COMMENT ON COLUMN "AppNamespace"."Name" IS 'Namespace name, must be globally unique';
COMMENT ON COLUMN "AppNamespace"."AppId" IS 'App ID';
COMMENT ON COLUMN "AppNamespace"."Format" IS 'Namespace format type';
COMMENT ON COLUMN "AppNamespace"."IsPublic" IS 'Whether the namespace is public';
COMMENT ON COLUMN "AppNamespace"."Comment" IS 'Comments';
COMMENT ON COLUMN "AppNamespace"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "AppNamespace"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "AppNamespace"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "AppNamespace"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "AppNamespace"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table Consumer
DROP TABLE IF EXISTS "Consumer";

CREATE TABLE "Consumer" (
  "Id" SERIAL PRIMARY KEY,
  "AppId" VARCHAR(500) NOT NULL DEFAULT 'default',
  "Name" VARCHAR(500) NOT NULL DEFAULT 'default',
  "OrgId" VARCHAR(32) NOT NULL DEFAULT 'default',
  "OrgName" VARCHAR(64) NOT NULL DEFAULT 'default',
  "OwnerName" VARCHAR(500) NOT NULL DEFAULT 'default',
  "OwnerEmail" VARCHAR(500) NOT NULL DEFAULT 'default',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_AppId" UNIQUE ("AppId")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "Consumer" IS 'Open API consumer';
COMMENT ON COLUMN "Consumer"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "Consumer"."AppId" IS 'App ID';
COMMENT ON COLUMN "Consumer"."Name" IS 'Application name';
COMMENT ON COLUMN "Consumer"."OrgId" IS 'Organization ID';
COMMENT ON COLUMN "Consumer"."OrgName" IS 'Organization name';
COMMENT ON COLUMN "Consumer"."OwnerName" IS 'Owner name';
COMMENT ON COLUMN "Consumer"."OwnerEmail" IS 'Owner email';
COMMENT ON COLUMN "Consumer"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Consumer"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Consumer"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Consumer"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "Consumer"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table ConsumerAudit
DROP TABLE IF EXISTS "ConsumerAudit";

CREATE TABLE "ConsumerAudit" (
  "Id" SERIAL PRIMARY KEY,
  "ConsumerId" INTEGER,
  "Uri" VARCHAR(1024) NOT NULL DEFAULT '',
  "Method" VARCHAR(16) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_DataChange_LastTime" UNIQUE ("DataChange_LastTime"),
  CONSTRAINT "IX_ConsumerId" UNIQUE ("ConsumerId")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "ConsumerAudit" IS 'Consumer audit table';
COMMENT ON COLUMN "ConsumerAudit"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "ConsumerAudit"."ConsumerId" IS 'Consumer ID';
COMMENT ON COLUMN "ConsumerAudit"."Uri" IS 'Visited URI';
COMMENT ON COLUMN "ConsumerAudit"."Method" IS 'Visited method';
COMMENT ON COLUMN "ConsumerAudit"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "ConsumerAudit"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table ConsumerRole
DROP TABLE IF EXISTS "ConsumerRole";

CREATE TABLE "ConsumerRole" (
  "Id" SERIAL PRIMARY KEY,
  "ConsumerId" INTEGER,
  "RoleId" INTEGER,
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_DataChange_LastTime" UNIQUE ("DataChange_LastTime"),
  CONSTRAINT "IX_RoleId" UNIQUE ("RoleId"),
  CONSTRAINT "IX_ConsumerId_RoleId" UNIQUE ("ConsumerId", "RoleId")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "ConsumerRole" IS 'Consumer and role binding table';
COMMENT ON COLUMN "ConsumerRole"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "ConsumerRole"."ConsumerId" IS 'Consumer ID';
COMMENT ON COLUMN "ConsumerRole"."RoleId" IS 'Role ID';
COMMENT ON COLUMN "ConsumerRole"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "ConsumerRole"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "ConsumerRole"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "ConsumerRole"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "ConsumerRole"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table ConsumerToken
DROP TABLE IF EXISTS "ConsumerToken";

CREATE TABLE "ConsumerToken" (
  "Id" SERIAL PRIMARY KEY,
  "ConsumerId" INTEGER,
  "Token" VARCHAR(128) NOT NULL DEFAULT '',
  "Expires" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT '2099-01-01 00:00:00',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_Token" UNIQUE ("Token"),
  CONSTRAINT "IX_DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "ConsumerToken" IS 'Consumer token table';
COMMENT ON COLUMN "ConsumerToken"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "ConsumerToken"."ConsumerId" IS 'Consumer ID';
COMMENT ON COLUMN "ConsumerToken"."Token" IS 'Token';
COMMENT ON COLUMN "ConsumerToken"."Expires" IS 'Token expiration time';
COMMENT ON COLUMN "ConsumerToken"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "ConsumerToken"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "ConsumerToken"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "ConsumerToken"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "ConsumerToken"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table Favorite
DROP TABLE IF EXISTS "Favorite";

CREATE TABLE "Favorite" (
  "Id" SERIAL PRIMARY KEY,
  "UserId" VARCHAR(32) NOT NULL DEFAULT 'default',
  "AppId" VARCHAR(500) NOT NULL DEFAULT 'default',
  "Position" INTEGER NOT NULL DEFAULT 10000,
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_UserId" UNIQUE ("UserId")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "Favorite" IS 'Application favorites table';
COMMENT ON COLUMN "Favorite"."Id" IS 'Primary key';
COMMENT ON COLUMN "Favorite"."UserId" IS 'User who favorited';
COMMENT ON COLUMN "Favorite"."AppId" IS 'App ID';
COMMENT ON COLUMN "Favorite"."Position" IS 'Favorite order';
COMMENT ON COLUMN "Favorite"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Favorite"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Favorite"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Favorite"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "Favorite"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table Permission
DROP TABLE IF EXISTS "Permission";

CREATE TABLE "Permission" (
  "Id" SERIAL PRIMARY KEY,
  "PermissionType" VARCHAR(32) NOT NULL DEFAULT '',
  "TargetId" VARCHAR(256) NOT NULL DEFAULT '',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_TargetId_PermissionType" UNIQUE ("TargetId", "PermissionType"),
  CONSTRAINT "IX_DataChange_LastTime" UNIQUE ("DataChange_LastTime")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "Permission" IS 'Permission table';
COMMENT ON COLUMN "Permission"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "Permission"."PermissionType" IS 'Permission type';
COMMENT ON COLUMN "Permission"."TargetId" IS 'Permission target type';
COMMENT ON COLUMN "Permission"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Permission"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Permission"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Permission"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "Permission"."DataChange_LastTime" IS 'Last modified time';

-- Dump of table Role
DROP TABLE IF EXISTS "Role";

CREATE TABLE "Role" (
  "Id" SERIAL PRIMARY KEY,
  "RoleName" VARCHAR(256) NOT NULL DEFAULT '',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32),
  "DataChange_LastTime" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "IX_RoleName" UNIQUE ("RoleName")
) WITH (OIDS=FALSE);

COMMENT ON TABLE "Role" IS 'Role table';
COMMENT ON COLUMN "Role"."Id" IS 'Auto-increment ID';
COMMENT ON COLUMN "Role"."RoleName" IS 'Role name';
COMMENT ON COLUMN "Role"."IsDeleted" IS '1: deleted, 0: normal';
COMMENT ON COLUMN "Role"."DataChange_CreatedBy" IS 'Creator email prefix';
COMMENT ON COLUMN "Role"."DataChange_CreatedTime" IS 'Creation time';
COMMENT ON COLUMN "Role"."DataChange_LastModifiedBy" IS 'Last modifier email prefix';
COMMENT ON COLUMN "Role"."DataChange_LastTime" IS 'Last modified time';


-- Dump of table RolePermission
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "RolePermission";

CREATE TABLE "RolePermission" (
  "Id" SERIAL PRIMARY KEY,
  "RoleId" INTEGER,
  "PermissionId" INTEGER,
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE COMMENT '1: deleted, 0: normal',
  "DataChange_CreatedBy" VARCHAR(32) DEFAULT '' COMMENT 'Creator email prefix',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
  "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '' COMMENT 'Last modifier email prefix',
  "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modified time'
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "RolePermission" IS 'Role and permission binding table';

-- Dump of table ServerConfig
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "ServerConfig";

CREATE TABLE "ServerConfig" (
  "Id" SERIAL PRIMARY KEY,
  "Key" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Value" VARCHAR(2048) NOT NULL DEFAULT 'default',
  "Comment" VARCHAR(1024) DEFAULT '',
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "ServerConfig" IS 'Configuration service own configuration';

-- Dump of table UserRole
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "UserRole";

CREATE TABLE "UserRole" (
  "Id" SERIAL PRIMARY KEY,
  "UserId" VARCHAR(128) DEFAULT '',
  "RoleId" INTEGER,
  "IsDeleted" BOOLEAN NOT NULL DEFAULT FALSE,
  "DataChange_CreatedBy" VARCHAR(32) DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "DataChange_LastModifiedBy" VARCHAR(32) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "UserRole" IS 'User and role binding table';

-- Dump of table Users
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Users";

CREATE TABLE "Users" (
  "Id" SERIAL PRIMARY KEY,
  "Username" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Password" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Email" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Enabled" BOOLEAN
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "Users" IS 'User table';

-- Dump of table Authorities
-- ------------------------------------------------------------

DROP TABLE IF EXISTS "Authorities";

CREATE TABLE "Authorities" (
  "Id" SERIAL PRIMARY KEY,
  "Username" VARCHAR(64) NOT NULL,
  "Authority" VARCHAR(50) NOT NULL
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "Authorities" IS 'Authorities table';

-- Indexes
CREATE INDEX IX_DataChange_LastTime ON "RolePermission" ("DataChange_LastTime");
CREATE INDEX IX_RoleId ON "RolePermission" ("RoleId");
CREATE INDEX IX_PermissionId ON "RolePermission" ("PermissionId");

CREATE INDEX IX_Key ON "ServerConfig" ("Key");
CREATE INDEX IX_DataChange_LastTime ON "ServerConfig" ("DataChange_LastTime");

CREATE INDEX IX_DataChange_LastTime ON "UserRole" ("DataChange_LastTime");
CREATE INDEX IX_RoleId ON "UserRole" ("RoleId");
CREATE INDEX IX_UserId_RoleId ON "UserRole" ("UserId", "RoleId");

-- Insert statements for sample data

INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES
('apollo.portal.envs', 'dev', 'Supported environment list'),
('organizations', '[{"orgId":"TEST1","orgName":"Example Department 1"},{"orgId":"TEST2","orgName":"Example Department 2"}]', 'List of departments'),
('superAdmin', 'apollo', 'Portal super admin'),
('api.readTimeout', '10000', 'HTTP interface read timeout'),
('consumer.token.salt', 'someSalt', 'Consumer token salt'),
('admin.createPrivateNamespace.switch', 'true', 'Allow project admin to create private namespaces'),
('configView.memberOnly.envs', 'dev', 'Environment list where config info is only shown to project members, separated by commas');

INSERT INTO "Users" ("Username", "Password", "Email", "Enabled")
VALUES
('apollo', '$2a$10$7r20uS.BQ9uBpf3Baj3uQOZvMVvB1RN3PYoKE94gtz2.WAOuiiwXS', 'apollo@acme.com', TRUE);

INSERT INTO "Authorities" ("Username", "Authority") VALUES ('apollo', 'ROLE_user');

-- Sample Data

INSERT INTO "App" ("AppId", "Name", "OrgId", "OrgName", "OwnerName", "OwnerEmail")
VALUES
('SampleApp', 'Sample App', 'TEST1', 'Example Department 1', 'apollo', 'apollo@acme.com');

INSERT INTO "AppNamespace" ("Name", "AppId", "Format", "IsPublic", "Comment")
VALUES
('application', 'SampleApp', 'properties', FALSE, 'Default app namespace');

INSERT INTO "Permission" ("Id", "PermissionType", "TargetId")
VALUES
(1, 'CreateCluster', 'SampleApp'),
(2, 'CreateNamespace', 'SampleApp'),
(3, 'AssignRole', 'SampleApp'),
(4, 'ModifyNamespace', 'SampleApp+application'),
(5, 'ReleaseNamespace', 'SampleApp+application');

INSERT INTO "Role" ("Id", "RoleName")
VALUES
(1, 'Master+SampleApp'),
(2, 'ModifyNamespace+SampleApp+application'),
(3, 'ReleaseNamespace+SampleApp+application');

INSERT INTO "RolePermission" ("RoleId", "PermissionId")
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(3, 5);

INSERT INTO "UserRole" ("UserId", "RoleId")
VALUES
('apollo', 1),
('apollo', 2),
('apollo', 3);
