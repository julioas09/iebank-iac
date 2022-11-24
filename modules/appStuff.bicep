
param location string = resourceGroup().location
param appServiceAppName string
param appServicePlanName string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param dbhost string
param dbuser string
param dbpass string
param dbname string


var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}
resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
name: appServiceAppName
location: location
properties: {
  serverFarmId: appServicePlan.id
  httpsOnly: true
  siteConfig: {
    appSettings: [
      {
        name: 'DBUSER'
        value: dbuser
      }
      {
        name: 'DBPASS'
        value: dbpass
      }
      {
        name: 'DBNAME'
        value: dbname
      }
      {
        name: 'DBHOST'
        value: dbhost
      }
    ]
  }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName

