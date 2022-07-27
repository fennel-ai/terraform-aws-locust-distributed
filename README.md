# Locust Distributed Loadtest on AWS Terraform Module

This module proposes a simple and uncomplicated way to run your load tests created with Locust on AWS as IaaS.

NOTE: This is a fork of https://github.com/marcosborges/terraform-aws-loadtest-distribuited. Few changes:
1. Supports only locust - removed support for JMeter, K6 etc
2. Added support for running multiple locust "workers" in a single worker node (`input_locust_replicas_per_node`)
3. Fixed bug to execute custom entrypoint scripts when provided (previously only the default scripts were executed even if custom entrypoint scripts were provided)
4. Fixed few typos, lints etc

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.63 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.leader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [null_resource.executor](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.key_pair_exporter](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.setup_leader](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.setup_nodes](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.spliter_execute_command](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.loadtest](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_execute"></a> [auto\_execute](#input\_auto\_execute) | Execute Loadtest after leader and nodes available | `bool` | `true` | no |
| <a name="input_auto_setup"></a> [auto\_setup](#input\_auto\_setup) | Install and configure instances Amazon Linux2 with Locust | `bool` | `true` | no |
| <a name="input_executor"></a> [executor](#input\_executor) | Executor of the loadtest | `string` | `"locust"` | no |
| <a name="input_leader_ami_id"></a> [leader\_ami\_id](#input\_leader\_ami\_id) | Id of the AMI | `string` | `""` | no |
| <a name="input_leader_associate_public_ip_address"></a> [leader\_associate\_public\_ip\_address](#input\_leader\_associate\_public\_ip\_address) | Associate public IP address to the leader | `bool` | `true` | no |
| <a name="input_leader_custom_setup_base64"></a> [leader\_custom\_setup\_base64](#input\_leader\_custom\_setup\_base64) | Custom bash script encoded in base64 to setup the leader | `string` | `""` | no |
| <a name="input_leader_instance_type"></a> [leader\_instance\_type](#input\_leader\_instance\_type) | Instance type of the cluster leader | `string` | `"c5n.large"` | no |
| <a name="input_leader_monitoring"></a> [leader\_monitoring](#input\_leader\_monitoring) | Enable monitoring for the leader | `bool` | `true` | no |
| <a name="input_leader_tags"></a> [leader\_tags](#input\_leader\_tags) | Tags of the cluster leader | `map` | `{}` | no |
| <a name="input_loadtest_dir_destination"></a> [loadtest\_dir\_destination](#input\_loadtest\_dir\_destination) | Path to the destination loadtest directory | `string` | `"/loadtest"` | no |
| <a name="input_loadtest_dir_source"></a> [loadtest\_dir\_source](#input\_loadtest\_dir\_source) | Path to the source loadtest directory | `string` | n/a | yes |
| <a name="input_loadtest_entrypoint"></a> [loadtest\_entrypoint](#input\_loadtest\_entrypoint) | Path to the entrypoint command | `string` | `"bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"` | no |
| <a name="input_locust_plan_filename"></a> [locust\_plan\_filename](#input\_locust\_plan\_filename) | Filename locust plan | `string` | `""` | no |
| <a name="input_locust_replicas_per_node"></a> [locust\_replicas\_per\_node](#input\_locust\_replicas\_per\_node) | Number of locust replicas per node. You should typically run one worker instance per processor core on the worker machines in order to utilize all their computing power. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the provision | `string` | n/a | yes |
| <a name="input_node_custom_entrypoint"></a> [node\_custom\_entrypoint](#input\_node\_custom\_entrypoint) | Path to the entrypoint command | `string` | `""` | no |
| <a name="input_nodes_ami_id"></a> [nodes\_ami\_id](#input\_nodes\_ami\_id) | Id of the AMI | `string` | `""` | no |
| <a name="input_nodes_associate_public_ip_address"></a> [nodes\_associate\_public\_ip\_address](#input\_nodes\_associate\_public\_ip\_address) | Associate public IP address to the nodes | `bool` | `true` | no |
| <a name="input_nodes_custom_setup_base64"></a> [nodes\_custom\_setup\_base64](#input\_nodes\_custom\_setup\_base64) | Custom bash script encoded in base64 to setup the nodes | `string` | `""` | no |
| <a name="input_nodes_intance_type"></a> [nodes\_intance\_type](#input\_nodes\_intance\_type) | Instance type of the cluster nodes | `string` | `"c5n.xlarge"` | no |
| <a name="input_nodes_monitoring"></a> [nodes\_monitoring](#input\_nodes\_monitoring) | Enable monitoring for the leader | `bool` | `true` | no |
| <a name="input_nodes_size"></a> [nodes\_size](#input\_nodes\_size) | Total number of nodes in the cluster | `number` | `2` | no |
| <a name="input_nodes_tags"></a> [nodes\_tags](#input\_nodes\_tags) | Tags of the cluster nodes | `map` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | Name of the region | `string` | `"us-east-1"` | no |
| <a name="input_split_data_mass_between_nodes"></a> [split\_data\_mass\_between\_nodes](#input\_split\_data\_mass\_between\_nodes) | Split data mass between nodes | <pre>object({<br>        enable = bool<br>        data_mass_filenames = list(string)<br>    })</pre> | <pre>{<br>  "data_mass_filenames": [],<br>  "enable": false<br>}</pre> | no |
| <a name="input_ssh_cidr_ingress_blocks"></a> [ssh\_cidr\_ingress\_blocks](#input\_ssh\_cidr\_ingress\_blocks) | SSH user for the leader | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_ssh_export_pem"></a> [ssh\_export\_pem](#input\_ssh\_export\_pem) | n/a | `bool` | `false` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH user for the leader | `string` | `"ec2-user"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Id of the subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags | `map` | `{}` | no |
| <a name="input_web_cidr_ingress_blocks"></a> [web\_cidr\_ingress\_blocks](#input\_web\_cidr\_ingress\_blocks) | web for the leader | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_leader_private_ip"></a> [leader\_private\_ip](#output\_leader\_private\_ip) | The private IP address of the leader server instance. |
| <a name="output_leader_public_ip"></a> [leader\_public\_ip](#output\_leader\_public\_ip) | The public IP address of the leader server instance. |
| <a name="output_nodes_private_ip"></a> [nodes\_private\_ip](#output\_nodes\_private\_ip) | The private IP address of the nodes instances. |
| <a name="output_nodes_public_ip"></a> [nodes\_public\_ip](#output\_nodes\_public\_ip) | The public IP address of the nodes instances. |
<!-- END_TF_DOCS -->