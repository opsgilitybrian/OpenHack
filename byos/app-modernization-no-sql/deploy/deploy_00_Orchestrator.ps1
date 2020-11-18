$teamCount = Read-Host "How many teams are hacking?";
#get-azlocation | Select Location, DisplayName | Format-Table
$location1 = Read-Host "What is the first location to deploy to (i.e. eastus)?";
$location2 = Read-Host "What is the second location to deploy to (i.e. westus)?"

# Enter the SQL Server username 
$sqlAdministratorLogin = "openhackadmin"
# Enter the SQL Server password 
$sqlAdministratorLoginPassword = "Password123"

try {

    # create each team's resources:
    for ($i = 1; $i -le $teamCount; $i++)
    {
        $teamName = $i.ToString().PadLeft(2, '0');
        Write-Output ("Beginning Deployment - " + $teamName);

        #create variables for resource group names, database and server names, 
        #and the suffixes to make resources unique
        $resourceGroup1Name = "nosql-" + $teamName + "-openhack1";
        $resourceGroup2Name = "nosql-" + $teamName + "-openhack2";
        #unique strings for creating resources in the provisioned regions
        $suffix = -join ((48..57) + (97..122) | Get-Random -Count 13 | % {[char]$_})
        $suffix2 = -join ((48..57) + (97..122) | Get-Random -Count 13 | % {[char]$_})
        
        $databaseName = "Movies"
        $sqlserverName = "openhacksql-" + $teamName + "-" + $suffix

        ## Create the Resource Groups ##  
        $DeployRGsScriptPath = Split-Path $MyInvocation.InvocationName
          & "$DeployRGsScriptPath\deploy_01_DeployResourceGroups.ps1";

        #get the groups:
        $rg1 = Get-AzResourceGroup -Name $resourceGroup1Name
        $rg2 = Get-AzResourceGroup -Name $resourceGroup2Name

        if ($rg1 -ne $null -and $rg2 -ne $null -and $rg1.Name -ne '' -and $rg2.Name -ne '')
        {
            Write-Output "Orchestrating Resource Deployments";

            #run the deployment:  
            $DeployResourcesScriptPath = Split-Path $MyInvocation.InvocationName
            & "$DeployResourcesScriptPath\deploy_02_DeployResources.ps1"
        }
        else
        {
            Write-Output("Deployment failed for team: " + $teamName)
            throw "Resource groups and associated resources or sql import has failed for $teamName";
        }

        Write-Output ("Deployment Completed - " + $teamName);
    }
}
catch {
    Write-Output "An error was encountered, script could not complete:  $($PSItem.ToString())";
    Write-Output "Deployment Completed";
}
