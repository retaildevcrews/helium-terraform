# Helium IAC User Story

## User Stories

- As a DevOps engineer, I want a repeatable way to deploy infrastructure as code via CI-CD that is secure by default and follows engineering best practices.

### Acceptance Criteria

- Provide a step-by-step quick start that delivers a positive developer experience
- Securely build, deploy and alert on key infrastructure components (development, testing, staging, and production)
- Securely build, deploy and adhere to guidelines and engineering best practices
- Use Managed Identity to securely access resources
- Securely store, access, and maintain secrets in Key Vault
- Securely build and deploy the Docker container from Azure Container Registry (ACR), Azure DevOps or GitHub Actions
- Securely create a Cosmos DB
- Automatically create the resources to send telemetry and logs to Azure Monitor
- Automatically generate documentation (README's) from markdown text in each module

Also, here are a few points that could be addressed:

1. Provide the developers the ability to limit the roles that can deploy infrastructure as code

### Key Features

- Security
  - "Secure by Design"
  - Key Vaults
  - Developer Experience

- Cloud Native Platform (containerization)
  - ACR
  - App Services
  - DevOps
  - IaC Standard components
  - CI-CD validation
  - Application Insights
  - Health Checks
  - Alerting
  - Dashboards

- CosmosDB Infrastructure

  - RU variable-ization
  - Secure setup
  
- Observability
  - Logging
  - Monitoring
  - Alerting
  - Dashboards

- Developer Experience
  - Secure by Design
  - Fork and Code
  - Easily customizable
