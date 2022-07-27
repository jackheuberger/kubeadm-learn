param name string
param vmName string = '${name}-vm'
param location string = resourceGroup().location

resource initcluster 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' =  {
  name: '0-${vmName}/init-cluster'
  location: location
  properties: {
    source: {
        script: '''
kubeadm init &&\\
cp /etc/kubernetes/admin.conf $HOME/ &&\\
chown $(id -u):$(id -g) $HOME/admin.conf &&\\
export KUBECONFIG=$HOME/admin.conf
'''
    }
  }
}
