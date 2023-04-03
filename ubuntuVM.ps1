# Définition des variables
$nom_ressource = "mon-ressource"
$emplacement = "francecentral"
$groupe_ressources = "mon-groupe-ressources"

# Connexion à Azure
Connect-AzAccount

# Création d'un groupe de ressources
New-AzResourceGroup -Name $groupe_ressources -Location $emplacement

# Création d'une ressource de machine virtuelle
New-AzVM -ResourceGroupName $groupe_ressources -Name $nom_ressource -Image UbuntuLTS -AdminUsername azureuser -Location $emplacement -Size Standard_B1s

# Ouverture des ports sur la machine virtuelle
$ruleHTTP = New-Object Microsoft.Azure.Commands.Network.Models.PSNetworkSecurityRuleConfig
$ruleHTTP.Name = 'AllowHTTP'
$ruleHTTP.Description = 'Allow HTTP'
$ruleHTTP.Access = 'Allow'
$ruleHTTP.Protocol = 'Tcp'
$ruleHTTP.Direction = 'Inbound'
$ruleHTTP.Priority = 1001
$ruleHTTP.SourceAddressPrefix = '*'
$ruleHTTP.SourcePortRange = '*'
$ruleHTTP.DestinationAddressPrefix = '*'
$ruleHTTP.DestinationPortRange = '80'
New-AzNetworkSecurityGroup -ResourceGroupName $groupe_ressources -Name 'MyNetworkSecurityGroup' -Location $emplacement -SecurityRules $ruleHTTP

$ruleSSH = New-Object Microsoft.Azure.Commands.Network.Models.PSNetworkSecurityRuleConfig
$ruleSSH.Name = 'AllowSSH'
$ruleSSH.Description = 'Allow SSH'
$ruleSSH.Access = 'Allow'
$ruleSSH.Protocol = 'Tcp'
$ruleSSH.Direction = 'Inbound'
$ruleSSH.Priority = 1002
$ruleSSH.SourceAddressPrefix = '*'
$ruleSSH.SourcePortRange = '*'
$ruleSSH.DestinationAddressPrefix = '*'
$ruleSSH.DestinationPortRange = '22'
$networkSecurityGroup = Get-AzNetworkSecurityGroup -Name 'MyNetworkSecurityGroup' -ResourceGroupName $groupe_ressources
$networkSecurityGroup | Add-AzNetworkSecurityRuleConfig -Name $ruleSSH.Name -Description $ruleSSH.Description -Access $ruleSSH.Access -Protocol $ruleSSH.Protocol -Direction $ruleSSH.Direction -Priority $ruleSSH.Priority -SourceAddressPrefix $ruleSSH.SourceAddressPrefix -SourcePortRange $ruleSSH.SourcePortRange -DestinationAddressPrefix $ruleSSH.DestinationAddressPrefix -DestinationPortRange $ruleSSH.DestinationPortRange
$networkSecurityGroup | Set-AzNetworkSecurityGroup
Remove-AzNetworkSecurityGroup -Name 'MyNetworkSecurityGroup' -ResourceGroupName $groupe_ressources

# Déconnexion d'Azure
Disconnect-AzAccount

