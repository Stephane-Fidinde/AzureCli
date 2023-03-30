# Définir les variables de nom et de région pour la Web App
webAppName=myWordPressSite
location=westeurope

# Créer une ressource de groupe
az group create --name myResourceGroup --location $location

# Créer une Web App
az webapp create --name $webAppName --resource-group myResourceGroup --plan myAppServicePlan --runtime "PHP|7.4" --deployment-local-git

# Configurer la chaîne de connexion de la base de données MySQL
mysqlName=mySqlDB
mysqlUser=dbuser
mysqlPassword=$(az mysql server generate-password --length 20 -n $mysqlName -g myResourceGroup)
mysqlHost=$(az mysql server show -n $mysqlName -g myResourceGroup --query "fullyQualifiedDomainName" -o tsv)

# Créer une base de données MySQL
az mysql db create --name myWordPressDB --resource-group myResourceGroup --server-name $mysqlName

# Créer une application WordPress
az webapp deployment source config --name $webAppName --resource-group myResourceGroup --branch master --manual-integration --repo-url https://github.com/WordPress/WordPress.git

# Configurer les paramètres de configuration WordPress
az webapp config appsettings set --name $webAppName --resource-group myResourceGroup --settings "WORDPRESS_DB_NAME=myWordPressDB" "WORDPRESS_DB_HOST=$mysqlHost" "WORDPRESS_DB_USER=$mysqlUser" "WORDPRESS_DB_PASSWORD=$mysqlPassword"

# Activer le cache OPcache
az webapp config set --name $webAppName --resource-group myResourceGroup --php-version 7.4 --enable-opcache true
