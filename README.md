**🧩 Validação de OU x Template – Script PowerShell**

Versão: 2.1.0
Autor: Gustavo Fernandes

Este script realiza a validação entre templates de usuários do Active Directory e os usuários presentes na mesma OU, comparando grupos atribuídos e identificando discrepâncias.
Um arquivo de log é gerado automaticamente ao final da execução.

📌 Funcionalidades

Carrega o módulo ActiveDirectory.

Obtém o total de usuários ativos no domínio.

Lê a lista de templates no arquivo templates.txt.

Para cada template:

Identifica sua OU.

Lista todos os usuários da mesma OU.

Compara grupos de AD entre o template e cada usuário.

Exibe diferenças:

Grupos presentes no template, mas ausentes no usuário.

Grupos presentes no usuário, mas ausentes no template.

Gera um log completo em logs\logDD-MM-YY.txt.

📂 Estrutura Necessária

Certifique-se de que o diretório onde o script está contém:

script.ps1
templates.txt
\logs\


O arquivo templates.txt deve conter um SamAccountName de template por linha, por exemplo:

template.rh
template.financeiro
template.comercial

⚙️ Pré-requisitos

PowerShell 5+

Módulo ActiveDirectory instalado

Permissão de leitura de:

OUs

Grupos

Propriedades dos usuários

Acesso ao servidor AD configurado no script

🏗️ Configurações no Código

No topo do script, personalize:

$Server = "SERVER"     # Nome do seu controlador de domínio
$dir    = "DIRETORY"   # Diretório onde estão o script, templates.txt e a pasta logs

▶️ Como Executar

Abra o PowerShell como Administrador.

Navegue até o diretório do script:

cd "C:\caminho\do\script"


Execute:

.\script.ps1


Acompanhe a validação diretamente no console.

Ao final, um log será salvo em:

\logs\logDD-MM-YY.txt

📝 O que o Script Verifica

Para cada usuário encontrado na mesma OU do template:

✔️ Grupos faltando

Mostra grupos que o template tem e o usuário não tem.

✔️ Grupos extras

Mostra grupos que o usuário tem e o template não tem.

Exemplo de saída:

-----------------------------------------------------------
Grupo pertence a (template.rh) mas não pertence a (usuario123):

GrupoA
GrupoB

🚨 Possíveis Erros
❗ "Erro - Lista não encontrada"

O arquivo templates.txt não está no mesmo diretório do script.

❗ Usuários sem UPN

Se algum usuário não tiver UserPrincipalName, a comparação de domínio pode falhar.

🏁 Finalização

Após execução completa, o script exibe:

FIM DO SCRIPT - um arquivo de log foi gerado
Pressione Enter para Encerrar
