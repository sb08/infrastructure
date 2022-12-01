# Infrastructure repo #

Infrastructure as code repository to define both cloud and on-prem resources in human-readable configuration files.

### What is this repository for? ###

* Project Status: Proof of Concept using terraform and [azure](https://portal.azure.com/) portal.

### Dev set up ###

* Install azure [cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* Install terraform [cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


* Configure local azure cli environment
```bash
az login
```
```bash
az account set -s SUB_NAME
```

* From project root, initialize local terraform environment (ie get providers)
```bash
 terraform init
```
```bash
terraform workspace new dev
```

### Make changes to commit ###
....start working on .tf files....

* Verify changes (optional):
```bash
terraform fmt
```
```bash
terraform validate
```

* Make cloud environment changes
```bash
terraform plan -out [fileName].tfplan
```
```bash
terraform apply [fileName].tfplan
```

### Other common commands ###
```bash
=======
>>>>>>> c115ef1... readme wip
terraform workspace list
```
```bash
terraform workspace show
```
```bash
terraform workspace select dev
```
```bash
terraform workspace delete dev
```

### delete cloud environment ###
```bash
terraform destroy -auto-approve
```

```bash
terraform state rm azurerm_resource_group.rg

Importing (ie manual change in portal)
1. Add the required terraform
2. Exec the plan command
3. Construct the terraform import command: terraform import --var-file="[optional file].tfvars" [tf id] [resource id from portal]

Examples
terraform import --var-file="terraform.tfvars" azurerm_resource_group.rg /subscriptions/2621f205-e4c6-463a-9c55-da7913b7ca0d/resourceGroups/ltf-rg

terraform state rm azurerm_public_ip.public_ip2
terraform import --var-file="terraform.tfvars" azurerm_public_ip.public_ip2 /subscriptions/2621f205-e4c6-463a-9c55-da7913b7ca0d/resourceGroups/ltf-rg/providers/Microsoft.Network/publicIPAddresses/myPublicIp
terraform import module.apim.azurerm_api_management.apim /subscriptions/2621f205-e4c6-463a-9c55-da7913b7ca0d/resourceGroups/ltf-rg/providers/Microsoft.ApiManagement/service/ltf-api-management-42901-dev
```

Notes:
Manual step required. Azure portal was required to add the vnet configuration to api management. correct terraform import and plan worked as expected after.
Created a sas policy via portal for service bus to get connection string
### Resources & Documentation
* Azure [cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* Terraform [docs](https://developer.hashicorp.com/terraform/intro), [registry](https://registry.terraform.io/)
