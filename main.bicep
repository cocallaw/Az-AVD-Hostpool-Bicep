param location string = resourceGroup().location
param tags object = {}

// AVD Resource Parameters
param hostPoolName string
param friendlyName string = hostPoolName
param loadBalancerType string = 'BreadthFirst'
param preferredAppGroupType string = 'Desktop'
param maxSessionLimit int = 2
@description('Token validity duration in ISO 8601 format')
param tokenValidityLength string = 'PT8H' // 8 hours by default
@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')
@description('Agent update configuration')
param agentUpdate object = {
  type: 'Scheduled'
  useSessionHostLocalTime: true
  maintenanceWindowTimeZone: 'UTC'
  maintenanceWindows: [
    {
      dayOfWeek: 'Saturday'
      hour: 2
      duration: '02:00'
    }
  ]
}

// Create AVD Host Pool
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2024-04-03' = {
  name: hostPoolName
  location: location
  tags: tags
  properties: {
    friendlyName: friendlyName
    hostPoolType: 'Pooled'
    preferredAppGroupType: preferredAppGroupType
    loadBalancerType: loadBalancerType
    maxSessionLimit: maxSessionLimit
    startVMOnConnect: false
    validationEnvironment: false
    agentUpdate: agentUpdate
    registrationInfo: {
      expirationTime: dateTimeAdd(baseTime, tokenValidityLength)
      registrationTokenOperation: 'Update'
    }
  }
}

// Create Desktop Application Group
resource desktopAppGroup 'Microsoft.DesktopVirtualization/applicationGroups@2024-04-03' = {
  name: '${hostPoolName}-desktopAppGroup'
  location: location
  tags: tags
  properties: {
    applicationGroupType: 'Desktop'
    hostPoolArmPath: resourceId('Microsoft.DesktopVirtualization/hostpools', hostPool.name)
  }
}

// Create Workspace
resource workspace 'Microsoft.DesktopVirtualization/workspaces@2024-11-01-preview' = {
  name: '${hostPoolName}-workspace'
  location: location
  tags: tags
  properties: {
    friendlyName: '${friendlyName} Workspace'
    applicationGroupReferences: [
      resourceId('Microsoft.DesktopVirtualization/applicationGroups', desktopAppGroup.name)
    ]
  }
}


module hostPoolRegistrationToken 'token.bicep' = {
  name: 'hostPoolRegistrationToken'
  params: {
    hostPoolName: hostPoolName
    tags: hostPool.tags
    location: hostPool.location
    hostPoolType: hostPool.properties.hostPoolType
    friendlyName: hostPool.properties.friendlyName
    loadBalancerType: hostPool.properties.loadBalancerType
    preferredAppGroupType: hostPool.properties.preferredAppGroupType
    maxSessionLimit: hostPool.properties.maxSessionLimit
    startVMOnConnect: hostPool.properties.startVMOnConnect
    validationEnvironment: hostPool.properties.validationEnvironment
    agentUpdate: hostPool.properties.agentUpdate

  }
    dependsOn: [
    desktopAppGroup
    workspace
  ]
}

// Optionally, output the registration token for host pool joining
output hostPoolRegistrationToken string = hostPoolRegistrationToken.outputs.registrationToken
