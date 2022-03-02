configuration SSL
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -Module xDynamicsNav

    $navServiceAccount = [PSCredentials]::new("CONTOSO\Administrator", (ConvertTo-SecureString -AsPlainText -Force -String "Passw0rd"))

    node ("localhost")
    {
        File SetupSources {
            Ensure          = 'Present'
            SourcePath      = '\\Share\Sources\'
            DestinationPath = 'C:\Sources\'
            Recurse         = $true
            Type            = 'Directory'
        }

        xBCSetup BCStandardSetup {
            Ensure                 = 'Present'
            SetupPath              = 'C:\Sources\Microsoft_Dynamics365_SpringRelease'
            ServiceAccount         = $navServiceAccount
            DatabaseServer         = "localhost"
            DatabaseInstance       = "SQL2019"
            DatabaseName           = "BCDB"
            InstanceName           = "BCDB"
            ManagementServicesPort = 13045
            ClientServicesPort     = 13046
            DataServicesPort       = 13048
            SuperUser              = @($navServiceAccount.UserName)
            LicenseFile            = 'C:\Sources\Microsoft_Dynamics365_SpringRelease\20190703_BC_DEV_Lizenz_200NamedUser.flf'
            DependsOn              = '[File]SetupSources'
        }
    }
}