resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = "dev1-snowflake-s3"

  queue {
    id            = "XLI_IAAS_INCIDENT"
    queue_arn     = "arn:aws:sqs:us-east-1:021712061285:sf-snowpipe-AIDAJNSSNGSI3AOENRT4O-23sgQ_nXspCybdUEgvjUXw"
    events        = ["s3:ObjectCreated:Put", "s3:ObjectCreated:Post"]
    filter_prefix = "enrique_test/"
    filter_suffix = ".json"
  }

}

