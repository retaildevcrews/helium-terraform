# Module Properties

This module is used to create the CosmosDB instance, Databases and collections for the [Helium](https://github.com/retaildevcrews/helium) application

For this to work the system running the TF `apply` will need to have the docker runtime installed and working.

Example usage and Testing

```hcl
module "db" {
source         = "../modules/db"
COSMOS_RG_NAME = azurerm_resource_group.cosmos.name
NAME           = var.NAME
LOCATION       = var.LOCATION
INSTANCES      = var.INSTANCES
COSMOS_RU      = var.COSMOS_RU
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| docker | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| COSMOS\_RG\_NAME | The Azure Resource Group the resource should be added to | `string` | n/a | yes |
| COSMOS\_RU | n/a | `number` | n/a | yes |
| INSTANCES | Map of the environment name and the helium application language to use i.e {myinstance1 = csharp, myinstance2 = typescript} | `map(string)` | n/a | yes |
| LOCATION | The Azure Region in which all resources in this example should be created. | `string` | n/a | yes |
| NAME | The prefix which should be used for all resources in this example | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| COSMOS\_RG\_NAME | The name of the CosmosDb resource group |
| IMDB\_IMPORT\_DONE | ACI module dependency complete |
| cosmos\_name | The name of the CosmosDb instance |
| ro\_key | The read Only key for the CsomosDB to be used by the Helium Application. This is used to pass into the webapp module |

