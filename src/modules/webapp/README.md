# Module Properties

This module is used to create the AppService, WebApp for Containers(linux), Azure Key Vault and the AppInsights used by the [Helium](https://github.com/retaildevcrews/helium) application.

This module is broken into 4 separate files for ease of organization but are treated as 1 single flat Terraform template when called by the module.  
This module also securely stores the tfstate files in an encrypted Azure blob

** Four alerts for  AppInsights are also provided as part of the service.  They are:  
 Web Test (WT) Availability (Service up / down)  
 Response Time (RT) (over 300 milliseconds)  
 Maximum requests (MR) (over 600)  
 Webv requests below 1 (WV) (less than 1)

Additional Parameters to Customize Alerts are available to you outside of Helium.

(See complete list [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/app-insights-metrics))

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ACTION\_GROUP\_NAME | Name of action group or email group to receive alerts | `string` | n/a | yes |
| APP\_RG\_NAME | The Azure Resource Group the resource should be added to | `string` | n/a | yes |
| COSMOS\_COL | This is the collection name of the Cosmos DB and will be an output from the resource command. | `string` | n/a | yes |
| COSMOS\_KEY | This is the managed identify key from the Cosmos DB and will be an output from the resource command. | `any` | n/a | yes |
| COSMOS\_RG\_NAME | The Azure Resource Group the Cosmos DB is in | `string` | n/a | yes |
| COSMOS\_URL | This is the primary connection string of the Cosmos DB and will be an output from the resource command. | `string` | n/a | yes |
| EMAIL\_FOR\_ALERTS | The name of the email or email group to receive alerts | `string` | n/a | yes |
| INSTANCES | Map of the environment name and the helium application language to use i.e {myinstance1 = csharp, myinstance2 = typescript} | `map(string)` | n/a | yes |
| LOCATION | The Azure Region in which all resources in this example should be created. | `string` | n/a | yes |
| MR\_FREQUENCY | The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M | `string` | n/a | yes |
| MR\_OPERATOR | (Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual. | `string` | n/a | yes |
| MR\_SEVERITY | The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. | `number` | n/a | yes |
| MR\_THRESHOLD | (Required) The criteria threshold value that activates the alert. | `string` | n/a | yes |
| MR\_WINDOW\_SIZE | The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. | `string` | n/a | yes |
| NAME | The prefix which should be used for all resources in this example | `string` | n/a | yes |
| RT\_FREQUENCY | The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be les than WindowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D | `string` | n/a | yes |
| RT\_OPERATOR | (Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual. | `string` | n/a | yes |
| RT\_SEVERITY | The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. | `number` | n/a | yes |
| RT\_THRESHOLD | (Required) The criteria threshold value that activates the alert. | `string` | n/a | yes |
| RT\_WINDOW\_SIZE | The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. | `string` | n/a | yes |
| TENANT\_ID | This is the tenant ID of the Azure subscription. | `string` | n/a | yes |
| TF\_SUB\_ID | The subscription ID in which to create these appInsights alerts | `string` | n/a | yes |
| WT\_FREQUENCY | The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M | `string` | n/a | yes |
| WT\_OPERATOR | (Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual. | `string` | n/a | yes |
| WT\_SEVERITY | The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. | `number` | n/a | yes |
| WT\_THRESHOLD | (Required) The criteria threshold value that activates the alert. | `string` | n/a | yes |
| WT\_WINDOW\_SIZE | The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. | `string` | n/a | yes |

## Outputs

No output.

