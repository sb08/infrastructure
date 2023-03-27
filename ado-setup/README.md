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
* Terraform
* Terraform Cloud
* Azure DevOps, YAML pipelines
* Azure services - Storage/Containers/Blobs, Azure Active Directory, Key Vault

### Terraform Cloud service principle ###
Multiple steps:
Login to az cli
Create sp local from command line:

```bash
az ad sp create-for-rbac --name Terraform_Cloud --role Owner --scopes /subscriptions/26949461-ce0f-417c-9706-68a3ed9f3dd6
```

Creating 'Contributor' role assignment under scope '/subscriptions/26949461-ce0f-417c-9706-68a3ed9f3dd6'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "131f34cf-....",
  "displayName": "Terraform_Cloud",
  "password": "KGc8Q....",
  "tenant": "9ad2484f-...."
}


Assign the application administrator role to the service principal previously created Terraform_Cloud.
Go to Azure Active Directory then the Roles and administrators blade. Click on the Application administrator role, then the + Add assignments button and then Select Members link. Search for Terraform_Cloud.

As above, this worked for everything except "azurerm_role_assignment. result is Sub > IAM > role assignments
```bash
az ad sp create-for-rbac --name Terraform_Cloud --role Contributor --scopes /subscriptions/26949461-ce0f-417c-9706-68a3ed9f3dd6
```

Perhaps a contributor cannot create another contributor?

### Terraform Cloud Variables ###
Terraform Cloud (https://app.terraform.io) backend is used to execute the ado-setup. A Terraform Cloud account, project and workspace is required in order to set the following list of variables and environment variables required for the config to work:

** Terraform Variables**
* `TF_VAR_ado_org_service_url` - Azure DevOPs Org service url
* `TF_VAR_ado_github_repo` - Name of the repository in the format `<GitHub Org>/<RepoName>`. You'll need to fork my repo and use your own.
* `TF_VAR_ado_github_pat` (**sensitive** ) - Personal authentication token for GitHub repo.
* `TF_VAR_ado_pipeline_yaml_path` (**sensitive** ) - Yaml pipeline file location.
* `TF_VAR_az_location` (**sensitive** ) - Chosen data centre location.
* `TF_VAR_prefix` (**sensitive** ) - Prefix for used for service naming.

** Environment Variables from Terraform_Cloud SP creation above**

* `ARM_SUBSCRIPTION_ID` - Subscription ID where you will create the Azure Storage Account.
* `ARM_CLIENT_ID` (**sensitive**) - Client ID (appId) of service principal with the necessary rights in the referenced subscription.
* `ARM_CLIENT_SECRET` (**sensitive**) - Secret (password) associated with the Client ID.
* `ARM_TENANT_ID` - Azure AD tenant where the Client ID is located.

### Solution Components ###
AAD - 2 Service Principles
1. Connect to KV with access policy to grant the pipeline access to [get,list] secrets from the KV
2. Used in pipeline to create resources in the same or another subscription or restrict to specific resource group (ie Dev, Test, Prod)

KV
* Access policy to grant the pipeline access to [get,list] secrets from the KV
* Access policy with get and list access Policy
* List of secrets from Terraform Cloud or EVs
* After creating key vault, add logged in user to access policies in portal - https://stackoverflow.com/questions/42902130/azure-keyvault-operation-list-is-not-allowed-by-vault-policy-but-all-permi

ADO
* project and pipeline
* git repository service endpoint
* variable group with variables to connect and map to Key Vault
* build definition (ie pipeline)

Storage Account with container, blobs configuration for terraform state storage.

DONE. GO TO ADO RL AND EXECUTE A PIPELINE!!

### Future considerations ###
Adopt mono repo scenario, each folder could be a microservice
Complete automation of initial TF Cloud service principles
Futher configure pipeline settings to execute on a branch commit

Add more yaml pipeline steps where appropriate. YAML pipelines perform the following steps:
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

update tf cloud state example
terraform import azurerm_key_vault_access_policy.you /subscriptions/26949461-ce0f-417c-9706-68a3ed9f3dd6/resourceGroups/rg-destin-destin-dev/providers/Microsoft.KeyVault/service/kv-destin-dev

https://stackoverflow.com/questions/42134892/the-client-with-object-id-does-not-have-authorization-to-perform-action-microso
after successful deployment, need to add service connection IAM contributor role in subscriptions > IAM in portal
