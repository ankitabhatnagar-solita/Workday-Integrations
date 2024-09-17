param sitesWorkdayIntegrationsName string = 'Workday-Integrations'
param serverfarmsASPAnkitadevA00eExternalId string = '/subscriptions/ae6cbacb-2eac-42cc-978e-516b8ef7628d/resourceGroups/Ankita-dev/providers/Microsoft.Web/serverfarms/ASP-Ankitadev-8185'

resource sitesWorkdayIntegrations 'Microsoft.Web/sites@2023-12-01' = {
  name: sitesWorkdayIntegrationsName
  location: 'North Europe'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/ae6cbacb-2eac-42cc-978e-516b8ef7628d/resourceGroups/Ankita-dev/providers/Microsoft.Insights/components/Workday-Integrations'
    DueDate: '2024-08-12'
    Owner: 'Ankita'
  }
  kind: 'functionapp,workflowapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverfarmsASPAnkitadevA00eExternalId
    siteConfig: {
      numberOfWorkers: 1
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 3
      use32BitWorkerProcess: false
      webSocketsEnabled: false
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      preWarmedInstanceCount: 1
      functionsRuntimeScaleMonitoringEnabled: false
      azureStorageAccounts: {}
      ipSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 2147483647
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 2147483647
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictionsUseMain: false
    }
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

/*resource sitesWorkdayIntegrationsFTP 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: sitesWorkdayIntegrations
  name: 'ftp'
  properties: {
    allow: false
  }
}

resource sitesWorkdayIntegrationsSCM 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: sitesWorkdayIntegrations
  name: 'scm'
  properties: {
    allow: false
  }
}*/

resource sitesWorkdayIntegrationsConfig 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: sitesWorkdayIntegrations
  name: 'web'
  properties: {
    numberOfWorkers: 1
    netFrameworkVersion: 'v6.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    scmType: 'None'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    localMySqlEnabled: false
  }
}

resource sitesWorkdayIntegrationsDeployment 'Microsoft.Web/sites/deployments@2023-12-01' = {
  parent: sitesWorkdayIntegrations
  name: '299972482842439b9665cc70df4bfbb3'
  properties: {
    status: 4
    author: 'ms-azuretools-vscode'
    deployer: 'ms-azuretools-vscode'
    message: 'Created via a push deployment'
    start_time: '2024-09-06T09:52:12.675096Z'
    end_time: '2024-09-06T09:52:28.2124157Z'
    active: true
  }
}

resource sitesWorkdayIntegrationsHostNameBinding 'Microsoft.Web/sites/hostNameBindings@2023-12-01' = {
  parent: sitesWorkdayIntegrations
  name: '${sitesWorkdayIntegrationsName}.azurewebsites.net'
  properties: {
    siteName: sitesWorkdayIntegrationsName
    hostNameType: 'Verified'
  }
}
