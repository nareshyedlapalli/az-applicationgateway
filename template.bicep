param location string
param applicationGatewayName string
param tier string
param skuSize string
param capacity int = 2
param subnetName string
param zones array
param wafPolicyName string
param publicIpZones array
param publicIpAddressName array
param sku array
param allocationMethod array
param ipAddressVersion array
param privateIpAddress array
param autoScaleMaxCapacity int

var vnetId = '/subscriptions/61114f65-fccb-47d8-9dba-c77be4f114ea/resourceGroups/fbitn-vnet-eastus2/providers/Microsoft.Network/virtualNetworks/vnet-online-development-01-eastus2-01'
var publicIPRef = [
  publicIpAddressName_0.id
]
var subnetRef = '${vnetId}/subnets/${subnetName}'
var applicationGatewayId = applicationGateway.id

resource applicationGateway 'Microsoft.Network/applicationGateways@2023-02-01' = {
  name: applicationGatewayName
  location: location
  zones: zones
  tags: {}
  properties: {
    sku: {
      name: skuSize
      tier: tier
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIpIPv4'
        properties: {
          publicIPAddress: {
            id: publicIPRef[0]
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'pool-lfndoc-dev'
        properties: {
          backendAddresses: [
            {
              ipAddress: '172.16.250.45'
              fqdn: null
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'http-settings'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 20
        }
      }
    ]
    backendSettingsCollection: []
    httpListeners: [
      {
        name: 'listener-dev-http'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGatewayId}/frontendIPConfigurations/appGwPublicFrontendIpIPv4'
          }
          frontendPort: {
            id: '${applicationGatewayId}/frontendPorts/port_80'
          }
          protocol: 'Http'
          sslCertificate: null
          customErrorConfigurations: []
        }
      }
    ]
    listeners: []
    requestRoutingRules: [
      {
        name: 'rule-lfndoc-dev-http'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGatewayId}/httpListeners/listener-dev-http'
          }
          priority: 10
          backendAddressPool: {
            id: '${applicationGatewayId}/backendAddressPools/pool-lfndoc-dev'
          }
          backendHttpSettings: {
            id: '${applicationGatewayId}/backendHttpSettingsCollection/http-settings'
          }
        }
      }
    ]
    routingRules: []
    enableHttp2: true
    sslCertificates: []
    probes: []
    autoscaleConfiguration: {
      minCapacity: capacity
      maxCapacity: autoScaleMaxCapacity
    }
    firewallPolicy: {
      id: '/subscriptions/61114f65-fccb-47d8-9dba-c77be4f114ea/resourceGroups/rg-application-gateway-dev-eu2-01/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/waf-fbitn-online-application-gateway-dev-eu2-01'
    }
  }
  dependsOn: [
    'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/${wafPolicyName}'
  ]
}

resource waf_fbitn_online_application_gateway_dev_eu2_01 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2023-02-01' = {
  name: 'waf-fbitn-online-application-gateway-dev-eu2-01'
  location: location
  tags: {}
  properties: {
    policySettings: {
      mode: 'Detection'
      state: 'Enabled'
      fileUploadLimitInMb: 100
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
    }
    managedRules: {
      exclusions: []
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
          ruleGroupOverrides: null
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
          ruleGroupOverrides: null
        }
      ]
    }
    customRules: []
  }
}

resource publicIpAddressName_0 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: publicIpAddressName[0]
  location: location
  sku: {
    name: sku[0]
  }
  zones: publicIpZones
  properties: {
    publicIPAddressVersion: ipAddressVersion[0]
    publicIPAllocationMethod: allocationMethod[0]
  }
}
