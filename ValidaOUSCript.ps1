Import-Module activedirectory 
$date = Get-Date -format "dd-MM-yy"
$Server = "SERVER"
$dir = "DIRETORY"
cd $dir
Clear
Start-Transcript -Path "$dir\logs\log$date.txt"

Write-Host "SCRIPT DE VALIDAÇÂO DE OU x Template - 2.1.0" -ForegroundColor Yellow
Write-Host "Desenvolvido por Gustavo Fernandes" -ForegroundColor Green
$count = (Get-ADUser -Filter "enabled -eq'true'" -Server $Server).count 
Write-Host "Atualmente o AD contem $count Usuarios Ativos no Dominio $Server" -ForegroundColor Green
Date
###########################################################  
if (test-path -path .\templates.txt) {
###########################################################  
foreach( $SID in Get-Content .\templates.txt) { 
    $userCN = Get-ADUser $SID -Properties CanonicalName -Server $Server
    $userOU = ($userCN.DistinguishedName -split ",",2)[1]
    $users = Get-ADUser -Filter * -SearchBase $UserOU -Server $Server
    Foreach ($DID in $users.SamAccountName) {
##################################################################
$SIDUPN = Get-ADUser -Filter {Samaccountname -eq $SID} -Server $Server 
$SIDDC0 = $SIDUPN.UserPrincipalName 
$SIDDC = $SIDDC0.split("@")[1] 
###########################################################  
$DIDUPN = Get-ADUser -Filter {Samaccountname -eq $DID} -Server $Server
$DIDDC0 = $DIDUPN.UserPrincipalName 
$DIDDC = $DIDDC0.split("@")[1] 
###########################################################  
$SGrps = Get-ADPrincipalGroupMembership $SID  -Server $Server| select -ExpandProperty name 
$DGrps = Get-ADPrincipalGroupMembership $DID  -Server $Server| select -ExpandProperty name 
$diff = Compare-Object -ReferenceObject $SGrps -DifferenceObject  $DGrps | Where-Object {$_.SideIndicator -eq "<="}  | select -ExpandProperty InputObject  
If($diff -ne $null){
Write-Host "";
Write-Host "-----------------------------------------------------------" 
Write-Host "Grupo pertence a ($SID) mas não pertence a ($DID). " -ForegroundColor YELLOW
$diff 
Write-Host"";
}
$diff2 = Compare-Object -ReferenceObject $SGrps -DifferenceObject  $DGrps | Where-Object {$_.SideIndicator -eq "=>"}  | select -ExpandProperty InputObject  
If($diff -ne $null){
Write-Host "";
Write-Host "-----------------------------------------------------------" 
Write-Host "Grupo pertence a  ($DID) mas não pertence a ($SID). " -ForegroundColor RED 
$diff2 
Write-Host "";
}
}
}
} else {
Write-Host "Erro - Lista não encontrada - Adicione o arquivo template.txt com a lista de templates a ser validada"
}
###########################################################  
Write-Host "FIM DO SCRIPT - um arquivo de log foi gerado"

$Close = read-host "Pressione Enter para Encerrar"
