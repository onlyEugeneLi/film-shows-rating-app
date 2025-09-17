module "remote-backend" {
  source = "./modules/remote-backend"

  # ---------- S3 ---------- #
  s3_bucket_name                    = var.s3_bucket_name
  bootstrap_s3_bucket_kms_key_alias = var.kms_key_alias

  # ------- DynamoDB ------- #
  dynamobd_table_name = var.dynamobd_table_name
}