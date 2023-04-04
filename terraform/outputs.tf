output "resource-ids" {
  value = <<-EOT
  BOOTSTRAP_SERVERS="${replace(confluent_kafka_cluster.basic.bootstrap_endpoint, "SASL_SSL://", "")}"
  SASL_USERNAME="${confluent_api_key.service-account-kafka-api-key.id}"
  SASL_PASSWORD="${confluent_api_key.service-account-kafka-api-key.secret}"
  SCHEMA_REGISTRY_URL="${confluent_schema_registry_cluster.essentials.rest_endpoint}"
  BASIC_AUTH_USER_INFO="${confluent_api_key.service-account-schema-registry-api-key.id}":"${confluent_api_key.service-account-schema-registry-api-key.secret}"
  KSQL_ENDPOINT="${confluent_ksql_cluster.streaming-applications.rest_endpoint}"
  KSQL_CLUSTER_ID="${confluent_ksql_cluster.streaming-applications.id}"
  KSQL_API_KEY="${confluent_api_key.ksqldb-api-key.id}"
  KSQL_API_SECRET="${confluent_api_key.ksqldb-api-key.secret}"
  EOT

  sensitive = true
}
