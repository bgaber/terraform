variable lambda_attributes {
  description = "List of Lambda Objects"
  type = list(object({
    name                  = string
    description           = string
    runtime               = string
    lambda_deployment_pkg = string
    timeout               = number
  }))
  default = [
    {
      name                  = "show_tickets",
      description           = "Show tickets function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "show_tickets-65c2351e-0aaf-49a7-be7f-a72c9fa50dc9.zip"
      timeout               = 30
    },
    {
      name                  = "ticket-details",
      description           = "Ticket details function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "ticket-details-e924ebc0-10d8-4d43-8b1d-38f462e96714.zip"
      timeout               = 30
    },
    {
      name                  = "genesys-post-utterance",
      description           = "Genesys post utterance function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "genesys-post-utterance-7ea37660-5238-45a6-a882-cb8cbabb46c5.zip"
      timeout               = 60
    },
    {
      name                  = "create_self_ticket_service",
      description           = "Create Self-Service ticket function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "create_self_ticket_service-6be21a98-7067-41ac-9265-a570c428a79a.zip"
      timeout               = 30
    }
  ]
}

variable "s3_bucket" {
  description = "S3 Bucket that contains Lambda Deployment Package archives"
  default     = "connect-genesys-iac-bucket"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda Handler"
  default     = "index.handler"
  type        = string
}

variable "genesys_post_utterance_layer_pkg" {
  description = "Genesys post utterance layer deployment package"
  default     = "genesys-post-utterance-layer-4510815a-4ef2-4f74-8941-a19e06873255.zip"
  type        = string
}

variable "create_self_ticket_service_layer_pkg" {
  description = "Create self-service ticket layer deployment package"
  default     = "create_self_ticket_layer-4e50653d-46c5-4a04-80a6-b0c3267085c4.zip"
  type        = string
}