param WebsiteName string
param PUL_ServerName string
param PUL_DBLogin string = 'AdminUser'

@secure()
param PUL_DBPassword string = 'P2ssw0rd'

@secure()
param PUL_DBPasswordForTest string
param PUL_DBName string = 'PartsUnlimitedDB'
param PUL_DBCollation string = 'SQL_Latin1_General_CP1_CI_AS'
param PUL_DBEdition string = 'Basic'
param PUL_HostingPlanName string
param PUL_HostingPlanSKU string = 'Standard'
param PUL_HostingPlanWorkerSize string = '0'
param EnableRules bool = false

var PartsUnlimitedServerName_var = toLower(PUL_ServerName)
var PartsUnlimitedServerNameDev_var = '${PartsUnlimitedServerName_var}dev'
var PartsUnlimitedServerNameStage_var = '${PartsUnlimitedServerName_var}stage'

resource PartsUnlimitedServerName 'Microsoft.Sql/servers@2014-04-01-preview' = {
  name: PartsUnlimitedServerName_var
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedServer'
  }
  properties: {
    administratorLogin: PUL_DBLogin
    administratorLoginPassword: PUL_DBPassword
  }
}

resource PartsUnlimitedServerName_AllowAllIps_PartsUnlimitedServerName 'Microsoft.Sql/servers/firewallrules@2014-04-01-preview' = {
  parent: PartsUnlimitedServerName
  name: 'AllowAllIps${PartsUnlimitedServerName_var}'
  location: resourceGroup().location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource PartsUnlimitedServerName_PUL_DBName 'Microsoft.Sql/servers/databases@2014-04-01-preview' = {
  parent: PartsUnlimitedServerName
  name: '${PUL_DBName}'
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedDB'
  }
  properties: {
    collation: PUL_DBCollation
    edition: PUL_DBEdition
    maxSizeBytes: '1073741824'
  }
}

resource PartsUnlimitedServerNameDev 'Microsoft.Sql/servers@2014-04-01-preview' = {
  name: PartsUnlimitedServerNameDev_var
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedServer'
  }
  properties: {
    administratorLogin: PUL_DBLogin
    administratorLoginPassword: PUL_DBPasswordForTest
  }
  dependsOn: []
}

resource PartsUnlimitedServerNameDev_AllowAllIps_PartsUnlimitedServerNameDev 'Microsoft.Sql/servers/firewallrules@2014-04-01-preview' = {
  parent: PartsUnlimitedServerNameDev
  name: 'AllowAllIps${PartsUnlimitedServerNameDev_var}'
  location: resourceGroup().location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource PartsUnlimitedServerNameDev_PUL_DBName 'Microsoft.Sql/servers/databases@2014-04-01-preview' = {
  parent: PartsUnlimitedServerNameDev
  name: '${PUL_DBName}'
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedDB'
  }
  properties: {
    collation: PUL_DBCollation
    edition: PUL_DBEdition
    maxSizeBytes: '1073741824'
  }
}

resource PartsUnlimitedServerNameStage 'Microsoft.Sql/servers@2014-04-01-preview' = {
  name: PartsUnlimitedServerNameStage_var
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedServer'
  }
  properties: {
    administratorLogin: PUL_DBLogin
    administratorLoginPassword: PUL_DBPasswordForTest
  }
  dependsOn: []
}

resource PartsUnlimitedServerNameStage_AllowAllIps_PartsUnlimitedServerNameStage 'Microsoft.Sql/servers/firewallrules@2014-04-01-preview' = {
  parent: PartsUnlimitedServerNameStage
  name: 'AllowAllIps${PartsUnlimitedServerNameStage_var}'
  location: resourceGroup().location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource PartsUnlimitedServerNameStage_PUL_DBName 'Microsoft.Sql/servers/databases@2014-04-01-preview' = {
  parent: PartsUnlimitedServerNameStage
  name: '${PUL_DBName}'
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedDB'
  }
  properties: {
    collation: PUL_DBCollation
    edition: PUL_DBEdition
    maxSizeBytes: '1073741824'
  }
}

resource WebsiteName_Insights 'Microsoft.Insights/components@2014-04-01' = {
  name: '${WebsiteName}-Insights'
  location: 'eastus'
  tags: {
    displayName: 'insightsComponents'
  }
  properties: {
    ApplicationId: '${WebsiteName}-Insights'
  }
}

resource WebsiteName_DevInsights 'Microsoft.Insights/components@2014-04-01' = {
  name: '${WebsiteName}-DevInsights'
  location: 'eastus'
  tags: {
    displayName: 'insightsComponents'
  }
  properties: {
    ApplicationId: '${WebsiteName}-DevInsights'
  }
}

resource WebsiteName_StagingInsights 'Microsoft.Insights/components@2014-04-01' = {
  name: '${WebsiteName}-StagingInsights'
  location: 'eastus'
  tags: {
    displayName: 'insightsComponents'
  }
  properties: {
    ApplicationId: '${WebsiteName}-StagingInsights'
  }
}

resource PUL_HostingPlanName_resource 'Microsoft.Web/serverfarms@2014-06-01' = {
  name: PUL_HostingPlanName
  location: resourceGroup().location
  tags: {
    displayName: 'PartsUnlimitedHostingPlan'
  }
  properties: {
    name: PUL_HostingPlanName
    sku: PUL_HostingPlanSKU
    workerSize: PUL_HostingPlanWorkerSize
    numberOfWorkers: 1
  }
  dependsOn: []
}

resource PUL_HostingPlanName_name 'Microsoft.Insights/autoscalesettings@2014-04-01' = {
  name: '${PUL_HostingPlanName}-${resourceGroup().name}'
  location: 'East US'
  tags: {
    'hidden-link:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${PUL_HostingPlanName}': 'Resource'
    displayName: 'WebsiteHostingPlanAutoScale'
  }
  properties: {
    name: '${PUL_HostingPlanName}-${resourceGroup().name}'
    profiles: [
      {
        name: 'Default'
        capacity: {
          minimum: '1'
          maximum: '4'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: '${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${PUL_HostingPlanName}'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 80
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT10M'
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: '${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${PUL_HostingPlanName}'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT1H'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 60
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1H'
            }
          }
        ]
      }
    ]
    enabled: EnableRules
    targetResourceUri: '${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${PUL_HostingPlanName}'
  }
  dependsOn: [
    PUL_HostingPlanName_resource
  ]
}

resource WebSiteName_resource 'Microsoft.Web/sites@2014-06-01' = {
  name: WebsiteName
  location: resourceGroup().location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${PUL_HostingPlanName}': 'Resource'
    displayName: 'PartsUnlimitedWebsite'
  }
  properties: {
    name: WebsiteName
    serverFarm: PUL_HostingPlanName
  }
  dependsOn: [
    PUL_HostingPlanName_resource
    PartsUnlimitedServerName
    PartsUnlimitedServerNameDev
    PartsUnlimitedServerNameStage
    WebsiteName_Insights
    WebsiteName_DevInsights
    WebsiteName_StagingInsights
  ]
}

resource WebSiteName_connectionstrings 'Microsoft.Web/sites/config@2014-11-01' = {
  parent: WebSiteName_resource
  name: 'connectionstrings'
  properties: {
    DefaultConnectionString: {
      value: 'Data Source=tcp:${PartsUnlimitedServerName.properties.fullyQualifiedDomainName},1433;Initial Catalog=${PUL_DBName};User Id=${PUL_DBLogin}@${PartsUnlimitedServerName_var};Password=${PUL_DBPassword};'
      type: 'SQLAzure'
    }
  }
}

resource WebSiteName_appsettings 'Microsoft.Web/sites/config@2014-11-01' = {
  parent: WebSiteName_resource
  name: 'appsettings'
  properties: {
    'Keys:ApplicationInsights:InstrumentationKey': reference('Microsoft.Insights/components/${WebsiteName}-Insights').InstrumentationKey
  }
}

resource WebSiteName_slotconfignames 'Microsoft.Web/sites/config@2014-11-01' = {
  parent: WebSiteName_resource
  name: 'slotconfignames'
  properties: {
    connectionStringNames: [
      'DefaultConnectionString'
    ]
    appSettingNames: [
      'keys:ApplicationInsights:InstrumentationKey'
    ]
  }
}

resource WebSiteName_Dev 'Microsoft.Web/sites/slots@2014-11-01' = {
  parent: WebSiteName_resource
  name: 'Dev'
  location: resourceGroup().location
  properties: {
  }
}

resource WebSiteName_Dev_connectionstrings 'Microsoft.Web/sites/slots/config@2014-11-01' = {
  parent: WebSiteName_Dev
  name: 'connectionstrings'
  properties: {
    DefaultConnectionString: {
      value: 'Data Source=tcp:${PartsUnlimitedServerNameDev.properties.fullyQualifiedDomainName},1433;Initial Catalog=${PUL_DBName};User Id=${PUL_DBLogin}@${PartsUnlimitedServerNameDev_var};Password=${PUL_DBPasswordForTest};'
      type: 'SQLAzure'
    }
  }
}

resource WebSiteName_Dev_appsettings 'Microsoft.Web/sites/slots/config@2014-11-01' = {
  parent: WebSiteName_Dev
  name: 'appsettings'
  properties: {
    'Keys:ApplicationInsights:InstrumentationKey': reference('Microsoft.Insights/components/${WebsiteName}-DevInsights').InstrumentationKey
  }
}

resource WebSiteName_Staging 'Microsoft.Web/sites/slots@2014-11-01' = {
  parent: WebSiteName_resource
  name: 'Staging'
  location: resourceGroup().location
  properties: {
  }
}

resource WebSiteName_Staging_connectionstrings 'Microsoft.Web/sites/slots/config@2014-11-01' = {
  parent: WebSiteName_Staging
  name: 'connectionstrings'
  properties: {
    DefaultConnectionString: {
      value: 'Data Source=tcp:${PartsUnlimitedServerNameStage.properties.fullyQualifiedDomainName},1433;Initial Catalog=${PUL_DBName};User Id=${PUL_DBLogin}@${PartsUnlimitedServerNameStage_var};Password=${PUL_DBPasswordForTest};'
      type: 'SQLAzure'
    }
  }
}

resource WebSiteName_Staging_appsettings 'Microsoft.Web/sites/slots/config@2014-11-01' = {
  parent: WebSiteName_Staging
  name: 'appsettings'
  properties: {
    'Keys:ApplicationInsights:InstrumentationKey': reference('Microsoft.Insights/components/${WebsiteName}-StagingInsights').InstrumentationKey
  }
}
