Start-Transcript -Path .\log.txt

Write-Host "SCRIPT DE VALIDAÇÂO DE OU x Template - 1.0.0" -ForegroundColor Yellow
Write-Host "Desenvolvido por Gustavo Fernandes" -ForegroundColor Green
Date

## Validar se o Arquivo Lista de Templates Existe 

if (test-path -path .\templates.txt) {

## Especificar Servidores

$Server = "XXXX"
$Server2 = "YYYYY"

## Obter Lista de Tempaltes 

foreach( $Template in Get-Content .\templates.txt) {
    $userCN = Get-ADUser $Template -Properties CanonicalName -Server $Server
    $userOU = ($userCN.DistinguishedName -split ",",2)[1]
    $users = Get-ADUser -Filter * -SearchBase $UserOU -Server $Server	
	$user = get-aduser $Template -Properties memberof -Server $Server 
	$groups = Foreach ($group in $user.memberof) {
		Try {
		(Get-ADGroup "$group" -Server $Server).Name
        $members = Get-ADGroupMember -Identity $group -Recursive -Server $Server | Select -ExpandProperty Name -ErrorAction Stop
		}Catch {
## Use Para Grupos em mais de um Dominio 		
        (Get-ADGroup "$group" -Server $Server2).Name
        $members = Get-ADGroupMember -Identity $group -Recursive -Server $Server2 | Select -ExpandProperty Name
		}
        $users | ForEach-Object {
        $user = $_.Name
        If ($members -notcontains  $user) {
        Write-Host  "O Usuário " -ForegroundColor White -NoNewline; 
		Write-Host  "$user " -ForegroundColor Green -NoNewline;
		Write-Host  "não pertence ao grupo " -ForegroundColor White -NoNewline;
		Write-Host  "$group " -ForegroundColor Magenta -NoNewline;		
		Write-Host  "pertence aos Grupos" -ForegroundColor White -NoNewline;
		$groupsOK = Get-ADUser -Filter {name -like $user} -Properties MemberOf -Server $Server| Select -ExpandProperty MemberOf	
		Write-Host  "$groupsOK " -ForegroundColor Magenta -NoNewline;
		Write-Host  "na Unidade Organizacional " -ForegroundColor White -NoNewline;
        Write-Host  "$UserOU " -ForegroundColor Yellow;
		Write-Host   " ----"
		
## Exporta resultado Excel 	
		
		$Result = @{
		"O Usuaario" = $user
		"Nao Pertence aos Grupos" = $group
		"Pertence aos Grupos" = [string]$groupsOK
		"na Unidade Organizacional" = $UserOU	
		}		
		$ExportCSV = New-Object -TypeName psobject -Property $Result                
		$ExportCSV | Select-Object 'O Usuario','Nao Pertence aos Grupos','Pertence aos Grupos','na Unidade Organizacional' | Export-Csv .\Resultado.csv -NoTypeInformation -Append
}
}
}
}
} else {
Write-Host "Erro - Lista não encontrada - Adicone o arquivo template.txt com a lista de templates a ser validada"
}

Write-Host "FIM DO SCRIPT - um arquivo de log foi gerado"
Stop-Transcript
$Close = read-host "Pressione Enter para Encerrar"
