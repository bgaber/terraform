resource "aws_opensearch_domain" "digital_assistant" {
  domain_name    = var.os_domain_name
  engine_version = "Elasticsearch_7.10"

  cluster_config {
    instance_type = "r4.large.search"
  }
}