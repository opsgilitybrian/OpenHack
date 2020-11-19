# $templateUri = "https://raw.githubusercontent.com/microsoft/OpenHack/main/byos/app-modernization-no-sql/deploy/azuresqldatabase.json"

$templateUri = "https://raw.githubusercontent.com/opsgilitybrian/OpenHack/nosql-deployment-fixes/byos/app-modernization-no-sql/deploy/azuresqldatabase.json";

$outputs = New-AzResourceGroupDeployment `
            -ResourceGroupName $resourceGroup1Name `
            -location $location1 `
            -TemplateUri $templateUri `
            -sqlserverName $sqlserverName `
            -sqlAdministratorLogin $sqlAdministratorLogin `
            -sqlAdministratorLoginPassword $(ConvertTo-SecureString -String $sqlAdministratorLoginPassword -AsPlainText -Force) `
            -suffix $suffix  