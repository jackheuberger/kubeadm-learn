param location string = resourceGroup().location

param name string

param vmName string = '${name}-vm'

param vmCount int = 3

module ssh 'bootstrap/ssh.bicep' = {
  name: 'change-ssh-port'
  params: {
    name: name
    vmName: vmName
    location: location
    vmCount: vmCount
  }
}

module bootstrapCluster 'bootstrap/configure.bicep' = {
  name: 'configure-VMs'
  params: {
    name: name
    location: location
    vmCount: vmCount
  }
  dependsOn: [
    ssh
  ]
}

// module createHost 'bootstrap/cluster-host.bicep' = {
//   name: 'create-host'
//   params: {
//     name: name
//     location: location
//   }
//   dependsOn: [
//     bootstrapCluster
//   ]
// }
