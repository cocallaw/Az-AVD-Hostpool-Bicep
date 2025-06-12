# Az-AVD-Hostpool-Bicep

## Overview

This repository contains Azure Bicep templates for deploying and managing an Azure Virtual Desktop (AVD) environment. The templates include resources for host pools, session hosts, application groups, workspaces, and retrieval of the registration token.

### Templates

1. **`main.bicep`**: Deploys the core AVD resources, including host pools, session hosts, application groups, and workspaces.

2. **`token.bicep`**: Manages the secure generation and update of AVD registration tokens.

## `main.bicep` Template

### Purpose

The `main.bicep` template is designed to deploy the core components of an Azure Virtual Desktop environment. It includes resources for:

- Host pools

- Application groups

- Workspaces

- Session hosts

- Network interfaces

### Parameters

- **`location`**: The Azure region where resources will be deployed.

- **`tags`**: Tags to apply to all resources.

- **`vnetName`**: Name of the existing virtual network.

- **`subnetName`**: Name of the subnet within the virtual network.

- **`vnetResourceGroup`**: Resource group containing the virtual network.

- **`hostPoolName`**: Name of the AVD host pool.

- **`friendlyName`**: Friendly name for the host pool (default: same as `hostPoolName`).

- **`loadBalancerType`**: Load balancing algorithm for the host pool (default: `BreadthFirst`).

- **`preferredAppGroupType`**: Preferred application group type (default: `Desktop`).

- **`sessionHostCount`**: Number of session hosts to deploy.

- **`maxSessionLimit`**: Maximum number of sessions per host.

- **`tokenValidityLength`**: Duration for which the registration token is valid (default: `PT8H`).

- **`baseTime`**: Base time for token generation (default: current UTC time).

- **`agentUpdate`**: Configuration for agent updates.

- **`vmNamePrefix`**: Prefix for session host VM names.

- **`vmSize`**: Size of the session host VMs (default: `Standard_DS2_v2`).

- **`adminUsername`**: Administrator username for the session hosts.

- **`adminPassword`**: Administrator password for the session hosts.

## `token.bicep` Template

### Purpose

The `token.bicep` template is responsible for securely generating and updating registration tokens for the AVD host pool. These tokens are required to register session hosts with the host pool.

### Parameters

- **`location`**: The Azure region where the host pool is located.

- **`tags`**: Tags to apply to the host pool.

- **`hostPoolName`**: Name of the AVD host pool.

- **`friendlyName`**: Friendly name for the host pool.

- **`hostPoolType`**: Type of the host pool (e.g., `Pooled`).

- **`loadBalancerType`**: Load balancing algorithm for the host pool.

- **`preferredAppGroupType`**: Preferred application group type.

- **`maxSessionLimit`**: Maximum number of sessions per host.

- **`startVMOnConnect`**: Whether to start VMs on user connection.

- **`validationEnvironment`**: Whether the host pool is a validation environment.

- **`agentUpdate`**: Configuration for agent updates.

- **`tokenValidityLength`**: Duration for which the registration token is valid (default: `PT8H`).

- **`baseTime`**: Base time for token generation (default: current UTC time).

### Outputs

- **`registrationToken`**: The generated registration token for the host pool.

## Deployment Instructions

### Prerequisites

1. Ensure you have the Azure CLI and Bicep CLI installed.

2. Log in to your Azure account using `az login`.

3. Set the desired subscription using `az account set --subscription <subscription-id>`.

### Steps

1. Clone this repository:

   ```bash
   git clone <repository-url>
   cd Az-AVD-Hostpool-Bicep
   ```

2. Deploy the `main.bicep` template:

   ```bash
   az deployment group create \
     --resource-group <resource-group-name> \
     --template-file main.bicep \
     --parameters @main.bicepparam
   ```

3. Verify the deployment in the Azure portal.

## Best Practices

- Use secure passwords and rotate them regularly.

- Monitor the AVD environment using Azure Monitor and Log Analytics.

- Follow Azure's [Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/) for reliability, security, and performance.

## Extensibility

- Add Intune integration for device management.

- Configure advanced scaling policies for session hosts.

- Enable diagnostics and monitoring for better observability.