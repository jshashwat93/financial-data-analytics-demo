output "resource-ids" {
  value = <<-EOT
  BOOTSTRAP_SERVERS="${replace(confluent_kafka_cluster.basic.bootstrap_endpoint, "SASL_SSL://", "")}"
  SASL_USERNAME="${confluent_api_key.service-account-kafka-api-key.id}"
  SASL_PASSWORD="${confluent_api_key.service-account-kafka-api-key.secret}"
  SCHEMA_REGISTRY_URL="${confluent_schema_registry_cluster.essentials.rest_endpoint}"
  BASIC_AUTH_USER_INFO="${confluent_api_key.service-account-schema-registry-api-key.id}":"${confluent_api_key.service-account-schema-registry-api-key.secret}"
  EOT

  sensitive = true
}