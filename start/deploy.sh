#!/bin/sh

name=t-jheuberger

az group create -n ${name}-rg -l eastus2

key=$( cat ~/.ssh/id_rsa.pub )

vmCount=3

az deployment group create --resource-group ${name}-rg --template-file ./start/main.bicep --parameters name=${name} adminPasswordOrKey="${key}" adminUsername=azureuser vmCount=${vmCount}

sleep 10

az deployment group create -g ${name}-rg -n ssh --template-file ./start/ssh.bicep --parameters vmCount=${vmCount} name=${name}

echo "VM SSH Login Commands:"
az deployment group show -g t-jheuberger-rg -n main --query properties.outputs.commands.value