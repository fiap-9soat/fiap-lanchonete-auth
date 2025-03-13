# fiap-lanchonete-auth

Repositório contendo os arquivos de configuração (Terraform) do AWS Cognito (Solução gerenciada de Auth) e AWS Lambda (
Serverless) para autenticação e autorização de acesso.

## Instalação e Execução

### Pre-requisitos

Certifique-se de ter instalado uma versão recente da CLI do `terraform`.

### Autenticação com o Terraform HCP

Essa organização utiliza o Terraform HCP para compartilhamento de estado entre os repositórios.  
Isso significa que é **obrigatório** realizar o login na plataforma para prosseguir com a instalação:
https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login

### Criando uma organização e workspace

No Painel do Terraform HCP, é importante copiar o nome da organização e o workspace alvo da configuração.  
Esse passo é essencial, e os valores devem ser especificados nas variaveis de ambiente a seguir:

```hcl
hcp_org = "fiap-lanchonete" # Nome da organização no Terraform HCP
hcp_workspace = "lanchonete-infra-2" # Nome da workspace pertencente a organização no Terraform HCP
```

Esse passo é obrigatório para **todos** os projetos de Terraform dessa organização.

### Variaveis de ambiente

É necessário criar algumas variaveis de ambiente para viabilizar a aplicação das configurações pelo CLI do Terraform.  
Para ambiente local, basta utilizar o arquivo `dev.auto.tfvars.example` como exemplo, criando um `dev.auto.tfvars`
correspondente:

```hcl
aws_access_key = "ASIAVEZQ3WJY2KR216362"
aws_secret_key = "TU+qlmgcNsX5MQz1238214821748211"
aws_token_key  = "12387218372185712887482173821849211299ddwq+Wp+JXsIYgo8GwFKk7Ms6y7wmGc9J1CqCJ1dAiALfo+D+BERHahJ1CpswGvC0BZah/cF7XIfZNgrxpIbLiq9AghgEAEaDDM1MzkwMDQwOTQ1NyIM5y1D/eAy2LhTThABKpoCER68KmMdcDD57aDTEC8KjfdDsLcco3EN8HfrspVnBAWXhQxMT3bF4aVVusYwMTbjKA4wBb1AK34SohcvbMQvKX+iIZGsIm7CkuMkIZsUeto9bDkwHq7P6e2ctJvUUf4khVv9armJYpqdb7sytoqfjRbYxU8WIgXXRaodcpxxusX1KkzP2DWBb5wKBQy/Cv8c0uiUKL1WtfTobjEZj5eEV9Kjf4GtXvjrfS0QU/eLs6kvsrEiQU6+ZCMeDdvAfWIEritAMFSUEaVDDsPn8uq7CJ0LWbcTB6qHMkP9l4PFMIZiNNQPycS79+4X/2T85jc+QIX4hZDMDrTm5lMmY4Ya5q0y8jxZQMsMbNkEL2JfP9pklquyMT0oQdUOMMLS/L0GOp4Bd6Y8K1rgPaKQkveh74WrGZHa+VNO5V24vSLiTnHr4F/fJFD/ZMz6nBRlwQbX3wUQxAujUPLKDAzF4oEvPzu69L09Q9msZTzFJMVNS/1mwFSqkxRtDjl+SejFFAm55be2YPwpb7qFOy+KFmPj3zlTe8+8Grnk7HjabAukdmAjlXpG3Q/ClJyQ2nc1skl5RHCXkBDG3wQdlj7DorTtHcw="
cognito_domain = "fiap-lanchonete-auth-1" # opcional, fiap-lanchonete-auth-1 quando omitido
```

_Atenção: essas credenciais são inválidas, e servem apenas como exemplo. Você deve obter as credenciais corretas do
próprio ambiente da AWS. Todas as variáveis são obrigatórias._

Caso você utilize o `AWS CLI`, os parametros no arquivo `~/.aws/credentials` podem ser utilizados para autenticação.
A tabela abaixo relaciona as credenciais especificadas nas variaveis do Terraform com as presentes no arquivo
`~/.aws/credentials`.

| tfvars         | ~/.aws/credentials    |
|----------------|-----------------------|
| aws_access_key | aws_access_key_id     |
| aws_secret_key | aws_secret_access_key |
| aws_token_key  | aws_session_token     |

### Estrutura

Esse repositório faz uso da funcionalidade de `modules` do Terraform, onde um arquivo principal (`main.tf`) orquestra o
deploy
de sub-modulos (pasta `modules`), passando as variaveis necessárias.
Para realizar os comandos (`terraform apply`, etc). Apenas as variaveis presentes no arquivo `variables.tf` devem ser
preenchidas.  
Estas estão especificadas logo acima.

## Aplicar configurações

Inicialize os módulos do Terraform do repositório:

```shell
terraform init
```

Com a configuração realizada, basta executar o seguinte comando para validar a configuração e conferir as alterações
que serão realizadas:

```shell
terraform plan
```

Caso o comando execute corretamente, você está devidamente autenticado em alguma instância válida do `AWS`.  
Para aplicar as alterações, basta rodar o seguinte comando e inserir 'yes' quando solicitado:

```shell
terraform apply
```

Em caso de erro ao aplicar alguma configuração, verifique se a `role` provisionada no `role_arn` é válida e tem
as permissões necessárias para criar todos os recursos (Cognito, Lambda, API Gateway).
