param appInsightsName string = 'SOP-integration1'

@description('The name of the resource')

param logicAppName string = 'Workday-Integration'

@description('The resource location')

param location string = 'North Europe'

param keyvaultName string

param keyvaultConnectionName string

var logicAppDefinition = json(loadTextContent('../WorkdayLogicApp/workflow.json'))

resource keyvault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyvaultName
  location: location

  properties: {
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
}
output keyVaultName string = keyvault.name
output keyVaultId string = keyvault.id

resource keyvaultConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: keyvaultConnectionName
  location:location
  properties: {
    api: {
      id: 'subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/keyvault'
    }
    displayName:keyvaultConnectionName
    parameterValueType: 'Alternative'
    alternativeParameterValues: {
      'vaultName': keyvaultName
    }
  }
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {

  name: logicAppName
  location: location

  properties: {

    definition: logicAppDefinition.definition

  }

}

output logicAppName string = logicApp.name

@description('The retention period in days for Application Insights, default of 90')

param retentionDays int = 90

@description('Log Analytics Workspace Name')

param logAnalyticsWorkspaceName string = 'workday-loganalytics'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {

  name: logAnalyticsWorkspaceName

  location: location

}

/*@description('The name of the Application Insights resource') 

param appInsightsName string = 'ai-${environment}-01-${logicAppName}' */

resource applicationInsights 'microsoft.insights/components@2020-02-02' = {

  name: appInsightsName

  location: location

  kind: 'web'

  properties: {

    Application_Type: 'web'

    Flow_Type: 'Bluefield'

    Request_Source: 'rest'

    RetentionInDays: retentionDays

    DisableIpMasking: true

    WorkspaceResourceId: logAnalyticsWorkspace.id

    IngestionMode: 'LogAnalytics'

    publicNetworkAccessForIngestion: 'Enabled'

    publicNetworkAccessForQuery: 'Enabled'

  }

}

resource logicappsKeyVaultAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('Key Vault Secret User', logicAppName, subscription().subscriptionId)
  scope: keyvault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: logicApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
