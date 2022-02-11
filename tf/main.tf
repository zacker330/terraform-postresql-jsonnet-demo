

terraform {
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.15.0"
    }
  }
}

provider "postgresql" {
  host            = "172.18.8.101"
  port            = 30002
  database        = "postgres"
  username        = "postgres"
  password        = "postgres"
  sslmode         = "disable"
  connect_timeout = 15
}

resource "postgresql_role" "app_www" {
  name = "app_www1"
}

resource "postgresql_role" "app_dba" {
  name = "app_dba1"
}

resource "postgresql_role" "app_releng" {
  name = "app_releng1"
}

resource "postgresql_schema" "my_schema" {
  name = "my_schema"
  owner = "postgres"

  policy {
    usage = true
    role = "${postgresql_role.app_www.name}"
  }

  # app_releng can create new objects in the schema.  This is the role that
  # migrations are executed as.
  policy {
    create = true
    usage = true
    role = "${postgresql_role.app_releng.name}"
  }

  policy {
    create_with_grant = true
    usage_with_grant = true
    role = "${postgresql_role.app_dba.name}"
  }
}