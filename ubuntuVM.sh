#!/bin/bash

# Définition des variables
nom_ressource="mon-ressource"
emplacement="francecentral"
groupe_ressources="mon-groupe-ressources"

# Connexion à Azure
az login

# Création d'un groupe de ressources
az group create --name $groupe_ressources --location $emplacement

# Création d'une ressource de machine virtuelle
az vm create --resource-group $groupe_ressources --name $nom_ressource --image UbuntuLTS --admin-username azureuser --generate-ssh-keys --location $emplacement --size Standard_B1s

# Ouverture des ports sur la machine virtuelle
az vm open-port --port 80 --resource-group $groupe_ressources --name $nom_ressource --priority 1001
az vm open-port --port 22 --resource-group $groupe_ressources --name $nom_ressource --priority 1002

# Déconnexion d'Azure
az logout

