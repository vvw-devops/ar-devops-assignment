# Common Configurations
account_id  = "111122223333"
region      = "us-east-1"
environment = "dev"


# EC2 instances configuration
ec2_instances = {
  web_01 = {
    name            = "web-01"
    subnet_id       = "subnet-aaa111bbb222"
    instance_type   = "t4g.medium"
    prevent_destroy = false
    root_volume = {
      size = 50
      type = "gp3"
    }
  }
  web_02 = {
    name            = "web-02"
    subnet_id       = "subnet-aaa111bbb222"
    instance_type   = "t4g.medium"
    prevent_destroy = false
    root_volume = {
      size = 50
      type = "gp3"
    }
  }

  app_01 = {
    name            = "app-01"
    subnet_id       = "subnet-aaa111bbb222"
    instance_type   = "c7g.large"
    prevent_destroy = false
    root_volume = {
      size = 50
      type = "gp3"
    }
  }

  app_02 = {
    name            = "app-02"
    subnet_id       = "subnet-aaa111bbb222"
    instance_type   = "c7g.large"
    prevent_destroy = false
    root_volume = {
      size = 50
      type = "gp3"
    }
  }

  db_01 = {
    name            = "db-01"
    subnet_id       = "subnet-aaa111bbb222"
    instance_type   = "r8g.xlarge"
    prevent_destroy = true
    root_volume = {
      size = 100
      type = "io2"
    }
  }
}
