terraform {
  backend "s3" {
    key            = "task-02/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    bucket         = "tfstate-bucket"
    kms_key_id     = "arn:aws:kms:us-east-1:111122223333:alias/tfstate-kms-key"
    dynamodb_table = "terraform-state-locks"

    #use_lockfile = true
  }
}