## Gengo ETCD cluster terraform module

Terraform module which creates EC2 instance(s) in multiple availability zones for ETCD cluster on AWS.
The ETCD setup is (currently) not implemented in this module. It needs chef cookbooks to provision the service.

### Dependencies
- terraform 0.11
- To install chef, please refer to [daidokoro](https://github.com/gengo/devops-tools/tree/master/daidokoro) for the setup.


### Example
```terraform
module "etcd" {
    source           = "git@github.com:gengo/etcd-tf-module.git?ref=1.0.0"

    hostname         = "etcd-staging"
    route53_zone_id  = "Z3FZA2A0A@FS25"
    count            = 3 # number of etcd nodes
    key_name         = "yoursshkeyname"

    subnet_ids       = [
        "subnet-0f57ad36rhe72334f",
        "subnet-0fba77f64f4ed4fad"
    ]
}
```

### Inputs

| Input              | Description                                                | Type   | default                     | Required |
|--------------------|------------------------------------------------------------|--------|-----------------------------|----------|
| hostname           | Hostname of the instance                                   | string | etcd-staging                | yes      |
| subnet_ids         | Multizone subnet IDs. All subnets must be in the same VPC  | list   | n/a                         | yes      |
| route53_zone_id    | Route53 hosted zone id                                     | string | n/a                         | yes      |
| count              | Number of ETCD nodes                                       | int    | 3                           | no       |
| key_name           | The access key name                                        | string | yoursshkeyname              | no       |
| instance_type      | EC2 instance type                                          | string | t2.medium                   | no       |
| security_group_ids | Security groups of the nodes                               | list   | []                          | no       |
| cookbooks_dir      | Local chef cookbooks directory                             | string | /src/devops-tools/daidokoro | no       |
