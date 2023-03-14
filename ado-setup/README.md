# Azure DevOps setup #

### Purpose ###

* One off initial deployment to create Azure DevOps project, YAML pipeline(s) and supporting Azure services using Terraform and Terraform Cloud.
* Pipeline execution intended to provision baseline Azure infrastructure (Api Management, Vnet, Service Bus...) in src folder within an Azure Subscription. See 'src/azure-pipelines.yml'.
* Additional pipelines can be added for cloud infrastructure and/or application deployment using a mono-repo scenario and updating azuredevops.tf

### Supporting Azure services ###
Required azure services created after ado setup execution:
* Storage Account for remote backend to store terraform state
* Key Vault to securely hold credentials for ADO to execute pipeline(s) and configure azure infrastructure
* Azure Active Directory for relevant auth credentials, service principles for Terraform backend and ADO pipeline execution

### Dev ops skills/knowledge utilized ###
Terraform
Terraform CLoud
Azure DevOps, YAML pipelines
Azure services - Storage/Containers/Blobs, Azure Active Directory, Key Vault

### Requirements ###
* Microsoft Account
* Azure Subscription
* Azure DevOps Organization
* Git code repository
* Terraform Cloud account

### Terraform Cloud Variables
Terraform Cloud (https://app.terraform.io) backend is used to execute the ado-setup. A Terraform Cloud account, project and workspace is required in order to set the following list of variables and environment variables required for the config to work:

** Terraform Variables**
* `TF_VAR_ado_org_service_url` - Azure DevOPs Org service url
* `TF_VAR_ado_github_repo` - Name of the repository in the format `<GitHub Org>/<RepoName>`. You'll need to fork my repo and use your own.
* `TF_VAR_ado_github_pat` (**sensitive** ) - Personal authentication token for GitHub repo.
* `TF_VAR_ado_pipeline_yaml_path` (**sensitive** ) - Yaml pipeline file location.
* `TF_VAR_az_location` (**sensitive** ) - Chosen data centre location.
* `TF_VAR_prefix` (**sensitive** ) - Prefix for used for service naming.

** Environment Variables**

* `ARM_SUBSCRIPTION_ID` - Subscription ID where you will create the Azure Storage Account.
* `ARM_CLIENT_ID` (**sensitive**) - Client ID of service principal with the necessary rights in the referenced subscription.
* `ARM_CLIENT_SECRET` (**sensitive**) - Secret associated with the Client ID.
* `ARM_TENANT_ID` - Azure AD tenant where the Client ID is located.

### Solution Components ###
AAD - 2 Service Principles
* Connect to KV with access policy to grant the pipeline access to [get,list] secrets from the KV
* Used in pipeline to create resources in the same or another subscription or restrict to specific resource group (ie Dev, Test, Prod)

KV
* Access policy to grant the pipeline access to [get,list] secrets from the KV
* Access policy with get and list access Policy
* List of secrets from Terraform Cloud or EVs

ADO
* project and pipeline
* git repository service endpoint
* variable group with variables to connect and map to Key Vault
* build definition (ie pipeline)

Storage Account with container, blobs configuration for terraform state storage.


### Future considerations ###
Adopt mono repo scenario, each folder could be a microservice

YAML pipelines perform the following steps:
Aquire terraform config in git repository
Validate the Terraform code as part of the pipeline (validate and format)
Create ADO project and pipeline(s)
YAML steps use commands rather than tasks for better understanding of operations

### Execution ###
Login to Terraform cloud in preffered browser
From command line, login to Terraform Cloud
Execute Terraform commands as usual and click on provided url to see execution run status in browser

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy -auto-approve
```
