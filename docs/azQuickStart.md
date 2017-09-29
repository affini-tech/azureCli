---
# AZ CLI Quick Start Guide
---
## Authentication
### Authenticate with device
* az login
### list all enable accounts
az account list
### set your default account
az account set --subscription abf9a60a-e2b0-49a3-bf80-73cf41574d48
## Resource groups
### list all enabled resource groups
az group list --output table
### create new resource group
az group create -l westeurope -n lcotest
### list all resources of a specific resource group
az resource list -g lcotest --output table
## Compute : VM
### list popular images for vm
az vm image list --output table
### list available sizes for vms
az vm list-sizes -l westeurope --output table
### create new vm from image with on data disk
az vm create -n lcotestvm -g lcotest --image Debian --data-disk-sizes-gb 50 --size Standard_A1 --admin-username lco --generate-ssh-keys
### retrieve vm infos
az vm show -g lcotest -n lcotestvm | jq .
### retrieve only attached disk infos for example
az vm show -g lcotest -n lcotestvm | jq '.storageProfile.dataDisks[0]'
## Storage accounts
### list storage accounts
az storage account list --output table
### create storage account
az storage account create -g lcotest -n lcostore --sku Standard_LRS
### set connection string to work on storage account
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string -n lcostore -g lcotest)
### create new storage container
az storage container create -n lcocont
### upload blob to container
az storage blob upload -c lcocont -f /scripts/azQuickStart.txt -n azQuickStart.txt
### list blobs inside container
az storage blob list -c lcocont --output table

---
* Use "az interactive" for interactive session with completion and documentation
* Examples and quickstart guide are available in /docs
* Markdown files could be rendered to the terminal with : mdv file.md
* Azure CLI 1.0 is available with command *azure ...*
---



