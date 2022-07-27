param name string
param vmName string = '${name}-vm'
param location string = resourceGroup().location
param vmCount int = 3

resource runSetupCommands 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' = [for i in range(0,vmCount): {
  name: '${i}-${vmName}/ssh'
  location: location
  properties: {
    source: {
        script: 'sed -i \'s/#Port 22/Port 45/g\' /etc/ssh/sshd_config && systemctl restart sshd'
      }
  }
}]
