using 'template.bicep'

param location = 'eastus2'

param applicationGatewayName = 'fbitn-online-application-gateway-dev-eu2-01'

param tier = 'WAF_v2'

param skuSize = 'WAF_v2'

param capacity = 1

param subnetName = 'snet-online-development-01-waf-eastus2-01'

param zones = [
  '1'
  '2'
  '3'
]

param wafPolicyName = 'waf-fbitn-online-application-gateway-dev-eu2-01'

param publicIpZones = [
  '1'
  '2'
  '3'
]

param publicIpAddressName = [
  'pip-fbitn-online-application-gateway-dev-eu2-01'
]

param sku = [
  'Standard'
]

param allocationMethod = [
  'Static'
]

param ipAddressVersion = [
  'IPv4'
]

param privateIpAddress = []

param autoScaleMaxCapacity = 2
