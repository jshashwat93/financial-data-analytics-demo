terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.36.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_environment" "demo" {
  display_name = "FinancialDataAnalytics"
}

data "confluent_schema_registry_region" "essentials" {
  cloud   = "AWS"
  region  = "us-east-2"
  package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "essentials" {
  package = data.confluent_schema_registry_region.essentials.package

  environment {
    id = confluent_environment.demo.id
  }

  region {
    id = data.confluent_schema_registry_region.essentials.id
  }
}

resource "confluent_kafka_cluster" "basic" {
  display_name = "BitcoinAnalysis"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  basic {}
  environment {
    id = confluent_environment.demo.id
  }
}

resource "confluent_service_account" "service-account" {
  display_name = "service-account"
  description  = "Service account to run microservices producing and consuming to and from Kafka"
}


resource "confluent_api_key" "service-account-kafka-api-key" {
  display_name = "service-account-kafka-api-key"
  description  = "Kafka API Key that is owned by service account"
  disable_wait_for_ready = true
  owner {
    id          = confluent_service_account.service-account.id
    api_version = confluent_service_account.service-account.api_version
    kind        = confluent_service_account.service-account.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = confluent_environment.demo.id
    }
  }

  depends_on = [
    confluent_role_binding.service-account-cluster-admin
  ]
}

resource "confluent_api_key" "service-account-schema-registry-api-key" {
  display_name = "service-account-schema-registry-api-key"
  description  = "Schema Registry API Key that is owned by service account"
  disable_wait_for_ready = true
  owner {
    id          = confluent_service_account.service-account.id
    api_version = confluent_service_account.service-account.api_version
    kind        = confluent_service_account.service-account.kind  
}

  managed_resource {
    id          = confluent_schema_registry_cluster.essentials.id
    api_version = confluent_schema_registry_cluster.essentials.api_version
    kind        = confluent_schema_registry_cluster.essentials.kind

    environment {
      id = confluent_environment.demo.id
    }
  }
}

resource "confluent_role_binding" "service-account-cluster-admin" {
  principal   = "User:${confluent_service_account.service-account.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.basic.rbac_crn
}

resource "confluent_role_binding" "all-subjects-rb" {
  principal   = "User:${confluent_service_account.service-account.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${confluent_schema_registry_cluster.essentials.resource_name}/subject=*"
}

resource "confluent_ksql_cluster" "example" {
  display_name = "StreamingApplication"
  csu          = 1
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  credential_identity {
    id = confluent_service_account.service-account.id
  }
  environment {
    id = confluent_environment.demo.id
  }
  depends_on = [
    confluent_role_binding.service-account-cluster-admin,
    confluent_role_binding.all-subjects-rb,
    confluent_schema_registry_cluster.essentials
  ]
}
