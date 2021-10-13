terraform {
  required_version = "~>0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.62.0"
    }
  }

  backend "remote" {
    organization = "Artis3nal"

    workspaces {
      name = "personal-wiki"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-east-2"
}
