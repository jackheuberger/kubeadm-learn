param name string
param vmName string = '${name}-vm'
param location string = resourceGroup().location
param vmCount int

resource installPackages 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' = [for i in range(0,vmCount): {
  name: '${i}-${vmName}/bootstrap'
  location: location
  properties: {
    source: {
        script: '''
apt-get update && apt-get install -y 
ca-certificates \\
curl \\
gnupg \\
lsb-release \\
apt-transport-https \\
vim &&\\
mkdir -p /etc/apt/keyrings && \\
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \\
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \\
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin && \\
systemctl enable docker && systemctl start docker && \\
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \\
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \\
apt-get update && apt-get install -y kubelet kubeadm kubectl && apt-mark hold kubelet kubeadm  && \\
apt-get update && apt-get upgrade -y && \\
rm /etc/containerd/config.toml && \\
systemctl restart containerd && \\
'''
      }
  }
}]
