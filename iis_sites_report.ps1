#### Collect IIS Information #### BY RagingPuppies 2018

$iis_servers = 'servername1','servername2'

$export_path = 'c:\temp\EXAMPLE.csv'

$returns  = Invoke-Command -ComputerName $iis_servers -ScriptBlock {
    
    Import-Module WebAdministration

    $sitesarray = @()

    $sites = Get-childItem IIS:\Sites\

    foreach($site in $sites){
        foreach($bind in $site.bindings.Collection.bindingInformation){
            $bind = $bind.Split(':')
            $site_obj = New-Object -TypeName PSObject
                $site_obj | Add-Member -MemberType NoteProperty -Name Servername -Value $ENV:COMPUTERNAME
                $site_obj | Add-Member -MemberType NoteProperty -Name Name -Value $site.name
                $site_obj | Add-Member -MemberType NoteProperty -Name IP -Value $bind[0]
                $site_obj | Add-Member -MemberType NoteProperty -Name Port -Value $bind[1]
                $site_obj | Add-Member -MemberType NoteProperty -Name Bind -Value $bind[2]
            $sitesarray += $site_obj
            }
            }
    $sitesarray
}

$returns | select Servername,Name,IP,Bind | Export-Csv -Path $export_path
