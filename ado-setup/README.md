# Infrastructure Azure DevOps setup #

### What does 'ado-setup do'? ###

* One off initial deployment to creates Azure DevOps project, YAML pipeline(s) and supporting Azure services using Terraform
* Pipeline execution intended to create & update Azure infrastructure (Api Management, Vnet, Service Bus...) in src folder within an Azure Subscription
* Future pipelines can be added for cloud infrastructure and/or application deployment

### Supporting Azure services ###
Storage Account to for remote backend to store terraform plan
Key Vault to securely hold credentials for ADO to execute pipeline and configure azure infrastructure
Azure Active Directory for relevant auth credentials to create service connections and Terraform backend

YAML pipelines perform the following steps:
Aquire iaac in git repository

Validate the Terraform code as part of the pipeline (validate and format)
 create ADO project and pipeline(s)
Separate the pipeline into two pipelines, one for PR and one for merge
Add testing to the process using terratest or Module Testing
* Pipeline to Azure authorization with secrets in
& configure required azure services for tf state (storage, kv, aad)
YAML steps use commands rather than tasks

### Dev ops skills required ###
Terraform
Azure DevOps & YAML pipelines
Azure services - Storage/Containers/Blobs, AAD, Key Vault,

### Requirements ###
* Microsoft Account
* Azure Subscription
* Azure DevOps Organization
* Git code repository

**Terraform Variables (used locally or in TF Cloud)**

* `ado_org_service_url` - Azure DevOPs Org service url
* `ado_github_repo` - Name of the repository in the format `<GitHub Org>/<RepoName>`. You'll need to fork my repo and use your own.
* `ado_github_pat` (**sensitive**) - Personal authentication token for GitHub repo.

**Environment Variables**

* `AZDO_PERSONAL_ACCESS_TOKEN` (**sensitive**) - Personal authentication token for Azure DevOps.
* `ARM_SUBSCRIPTION_ID` - Subscription ID where you will create the Azure Storage Account.
* `ARM_CLIENT_ID` (**sensitive**) - Client ID of service principal with the necessary rights in the referenced subscription.
* `ARM_CLIENT_SECRET` (**sensitive**) - Secret associated with the Client ID.
* `ARM_TENANT_ID` - Azure AD tenant where the Client ID is located.

### Solution Components ###
AAD - 2 Service Principles
* Connect to KV with permissions to get secrets for pipeline run
* Used in pipeline to create resources in the same or another subscription or restrict to specific resource group (ie Dev, Test, Prod)

KV
Access Policy with full Access
Access policy with get and list access Policy
Secrets to be used in pipeline from variables.tf

ADO
project
github service endpoint
azurerm connection service endpoint to connect to KV

Storage Account with container, blobs configuration for tfplan


### Future considerations ###
Utilize Terraform Cloud for tf backend
Add more folders to solution for mono repo, each folder could be a microservice
Add code scanning to the process using Checkov
initial local set up, populate and run env.ps1. do not check in.
