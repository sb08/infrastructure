# Infrastructure repo #

Infrastructure as code repository to define both cloud and on-prem resources in Terraform configuration files.

### Repository purpose ###

* Originally a Proof of Concept using terraform and [azure](https://portal.azure.com/) portal.
* Currently two terraform configurations:
* One off execution to create azure devops project and base infrastructure pipeline (ado-setup)
* Base infrastructure configuration to deploy azure services such as Api Management, Service Bus, vNets, Key Vault etc

### Requirements ###
* Microsoft Account
* Azure Subscription
* Azure DevOps Organization
* Git code repository
* Terraform Cloud account

### Online Resources & Documentation ###
* Azure [cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* Terraform [docs](https://developer.hashicorp.com/terraform/intro), [registry](https://registry.terraform.io/)
* Terraform Cloud [docs] (https://app.terraform.io/)

### Set up ###
* Goto ado-setup > README for instructions to create initial Azure DevOps deployment environment via central location - Terraform Cloud.
* Local dev environment:
* Install azure [cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* Install terraform [cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

* Configure local azure cli environment
```bash
az login
```
```bash
az account set -s SUB_NAME
```

* From src file, initialize local terraform environment (ie get providers)
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
terraform plan -out infra.tfplan
```
```bash
terraform apply [fileName].tfplan
```

### Other common commands ###
```bash
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
```

Notes:
Once Api Management is running, apis should have terraform deployment step to update api management accordingly
Create a sas policy via portal for service bus to get connection string until ps script can be executed via dev ops
Bug - gensas.ps1 needs relative reference
