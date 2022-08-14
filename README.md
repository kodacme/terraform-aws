# Terraform Docker environment
Building a Docker environment for building AWS infrastructure using Terraform. And simple network redundancy code.

# Feature
* Install terraform & AWS CLI v2 on alpine linux.

# Set up
git clone & delete terraform code & docker-compose up
```shell
$ git clone https://github.com/kodacme/terraform-aws.git

$ cd terraform-aws

# Delete terraform code
$ rm -rf src

$ docker-compose up -d
```

connect to container
```shell
$ docker container -it tf-aws sh
```

set environment variable for aws cli
```shell
/ $ cd terraform
/terraform $ source set-env.sh
```

Then we can code.
