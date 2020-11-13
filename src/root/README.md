# Parent Template Properties

This is the parent Terraform Template used to call the component modules to create the infrastructure and deploy the [Helium](https://github.com/retaildevcrews/helium) application.

The only resurces created in the template are the resource groups that each Service will go into. It is advised to create a terraform.tfvars file to assign values to the variables in the `variables.tf` file.

To keep sensitive keys from being stored on disk or source control you can set local environment variables that start with TF\_VAR\_\*\*NameOfVariable\*\*. This can be used with the Terraform Service Principal Variables

tfstate usage (not real values)

```shell
export TF_VAR_TF_SUB_ID="gy6tgh5t-9876-3uud-87y3-r5ygytd6uuyr"
export TF_VAR_TF_TENANT_ID="frf34ft5-gtfv-wr34-343fw-hfgtry657uk8"
export TF_VAR_TF_CLIENT_ID="ju76y5h8-98uh-oin8-n7ui-ger43k87d5nl"
export TF_VAR_TF_CLIENT_SECRET="<client-secret-value>"
```

## Requirements

| Name | Version |
|------|---------|
| azurerm | 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ACTION\_GROUP\_NAME | The action group name to pass to the web insights alert creation command.  Used by the ALERTS Module | `string` | n/a | yes |
| CONTAINER\_FILE\_NAME | The file name to pass to the container command. Used by the ACI Module | `string` | n/a | yes |
| COSMOS\_RU | The Number of Resource Units allocated to the CosmosDB. This is used by the DB module | `number` | n/a | yes |
| EMAIL\_FOR\_ALERTS | The name of the email or email group to receive alerts | `string` | n/a | yes |
| INSTANCES | Map of the environment name and the helium application language to use i.e {myinstance1 = csharp, myinstance2 = typescript}. This is used by the DB, ACI and Webapp modules | `map(string)` | n/a | yes |
| LOCATION | The Azure Region in which all resources in this example should be created. Used by all modules | `string` | n/a | yes |
| MR\_FREQUENCY | The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be less than windowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D | `string` | n/a | yes |
| MR\_OPERATOR | The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual | `string` | n/a | yes |
| MR\_SEVERITY | The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3 | `string` | n/a | yes |
| MR\_THRESHOLD | This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21 | `string` | n/a | yes |
| MR\_WINDOW\_SIZE | The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default if PT5M | `string` | n/a | yes |
| NAME | The prefix which should be used for all resources in this example. Used by all modules | `string` | n/a | yes |
| RT\_FREQUENCY | The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be les than WindowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D | `string` | n/a | yes |
| RT\_OPERATOR | The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual | `string` | n/a | yes |
| RT\_SEVERITY | The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3 | `string` | n/a | yes |
| RT\_THRESHOLD | This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21 | `string` | n/a | yes |
| RT\_WINDOW\_SIZE | The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default if PT5M | `string` | n/a | yes |
| SLEEP\_TIME | The amount of time to sleep before allowing another backend db request. Used by the ACI Module | `number` | n/a | yes |
| TF\_CLIENT\_ID | The Client ID(AppID) of the Service Principal that TF will use to Authenticate and build resources as. This account should have at least Contributor Role on the subscription. This is only used by the parent main.tf | `string` | n/a | yes |
| TF\_CLIENT\_SECRET | The Client Secret of the Service Principal that TF will use to Authenticate and build resources as. This account should have at least Contributor Role on the subscription. This is only used by the parent main.tf | `string` | n/a | yes |
| TF\_SUB\_ID | The Subscription ID for the Terrafrom Service Principal to build resources in.This is only used by the parent main.tf | `string` | n/a | yes |
| TF\_TENANT\_ID | This is the tenant ID of the Azure subscription. This is only used by the parent main.tf | `string` | n/a | yes |
| WT\_FREQUENCY | The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be less than windowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D | `string` | n/a | yes |
| WT\_OPERATOR | The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual | `string` | n/a | yes |
| WT\_SEVERITY | The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3 | `string` | n/a | yes |
| WT\_THRESHOLD | This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21 | `string` | n/a | yes |
| WT\_WINDOW\_SIZE | The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default if PT5M | `string` | n/a | yes |
| WV\_FREQUENCY | The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be less than windowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D | `string` | n/a | yes |
| WV\_OPERATOR | The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual | `string` | n/a | yes |
| WV\_SEVERITY | The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3 | `string` | n/a | yes |
| WV\_THRESHOLD | This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21 | `string` | n/a | yes |
| WV\_WINDOW\_SIZE | The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default is PT5M | `string` | n/a | yes |

## Outputs

No output.
