module "remote-backend" {
  source = "./modules/remote-backend"

  # ---------- S3 ---------- #
  s3_bucket_name = var.s3_bucket_name

}