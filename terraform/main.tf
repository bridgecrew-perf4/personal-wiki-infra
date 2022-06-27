terraform {
  required_version = "~>1.0.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.1"
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
