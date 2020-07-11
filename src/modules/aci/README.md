# Module Properties

This module is used to create the webvalidate instances needed for End to End testing of the [Helium](https://github.com/retaildevcrews/helium) Application stack

Visit the [webvalidate](https://github.com/retaildevcrews/webvalidate) project for more information on how it works

Example usage and testing

```hcl
module "aci" {
source              = "../modules/aci"
NAME                = var.NAME
LOCATION            = var.LOCATION
INSTANCES           = var.INSTANCES
CONTAINER_FILE_NAME = var.CONTAINER_FILE_NAME
ACI_RG_NAME         = azurerm_resource_group.helium-aci.name
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ACI\_RG\_NAME | The Azure Resource Group the resource should be added to | `string` | n/a | yes |
| CONTAINER\_FILE\_NAME | The file name to pass to the container command. | `string` | n/a | yes |
| IMDB\_IMPORT\_DONE | ACI module dependency complete | `any` | n/a | yes |
| INSTANCES | Map of the environment name and the helium application language to use i.e {myinstance1 = csharp, myinstance2 = typescript} | `map(string)` | n/a | yes |
| LOCATION | The Azure Region in which all resources in this example should be created. | `string` | n/a | yes |
| NAME | The prefix which should be used for all resources in this example | `string` | n/a | yes |
| SLEEP\_TIME | The amount of time to sleep before allowing another backend db request. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instrumentation\_key | Instrumentation Key for the webvalidate instance to be used by a dashboard module if you want a dashboard to monitor webv metrics |
