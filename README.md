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

## Utilização
O processo de criação e autenticação de usuarios se da por meio dos endpoints de API Gateway expostos por essa configuração.
O API Gateway segue esse padrão:
```
https://api-id.execute-api.region.amazonaws.com/stage/
```
Substituindo o 'app-id' pelo ID do API Gateway, o 'region' pela região da AWS, e o 'stage' pelo ambiente, normalmente 'prod'.  
Exemplo: `https://yjj3g3ipw2.execute-api.us-east-1.amazonaws.com/prod`

### Coleção Postman
Você pode importar a coleção Postman/Bruno disponível no arquivo `fiap-lanchonete-auth.json` na raiz do projeto.  
Os exemplos abaixos utilizam `cURL`, mas recomendamos utilizar uma dessas ferramentas para uma experiência mais agradável de teste.  

Lembre-se de substituir o endpoint especificado em `--url`, e na coleção Postman, 
pela URL da sua instância do API gateway.

### Cadastro
Para realizar o cadastro de um usuario, basta chamar o endpoint com as informações de `username`, `password`, e `cpf`:

```shell
curl --request POST \
  --url https://yjj3g3ipw2.execute-api.us-east-1.amazonaws.com/prod/sign-up \
  --data '{
    "email": "meuemailmuitolegal@gmail.com",
    "password": "123456789",
    "cpf": "19607832035"
}'
```
A resposta será algo parecido com isso:  
```json
{
  "User": {
    "Username": "54c854d8-4011-70f7-c96b-e1ef1db2e8bd",
    "Attributes": [
      {
        "Name": "email",
        "Value": "meuemailmuitolegal@gmail.com"
      },
      {
        "Name": "custom:cpf",
        "Value": "19607832035"
      },
      {
        "Name": "sub",
        "Value": "54c854d8-4011-70f7-c96b-e1ef1db2e8bd"
      }
    ],
    "UserCreateDate": "2025-03-15T23:32:30.320Z",
    "UserLastModifiedDate": "2025-03-15T23:32:30.320Z",
    "Enabled": true,
    "UserStatus": "FORCE_CHANGE_PASSWORD"
  }
}
```

### Recuperação de senha
A recuperação de senha pode ser feita pelo endpoint `/password-recovery`:  
```shell
curl --request POST \
  --url https://yjj3g3ipw2.execute-api.us-east-1.amazonaws.com/prod/password-recovery \
  --data '{
    "email": "meuemailmuitolegal@gmail.com"
}'
```

O usuario receberá um email automatico com o passo a passo de recuperação de senha.  
Esse fluxo **não** funciona para o AWS Lab com `LabRole`.

### Autenticação (Login)
Tendo feito o cadastro, o usuario consegue se autenticar utilizando o endpoint `/sign-in`:  
```shell
curl --request POST \
  --url https://yjj3g3ipw2.execute-api.us-east-1.amazonaws.com/prod/sign-in \
  --data '{
    "email": "meuemailmuitolegal@gmail.com",
    "password": "123456789"
}'
```

A resposta será algo parecido com isso:
```json
{
  "ChallengeParameters": {},
  "AuthenticationResult": {
    "AccessToken": "eyJraWQiOiJhRVVvVkZ3UEFiUUJaUjFBcFY3MFwva242UmJtSFNGejVFXC96Mm95b3R5WTQ9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1NGM4NTRkOC00MDExLTcwZjctYzk2Yi1lMWVmMWRiMmU4YmQiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9MMHp3ZEo2dHgiLCJjbGllbnRfaWQiOiIzYzR2NzNxbGMxOWJwMG1ldm05NGY1YTRjbyIsIm9yaWdpbl9qdGkiOiI2YTkwMzdiNy05OTUxLTQ5YzUtODA3Ni0yMDE2YWVlNGFmOGYiLCJldmVudF9pZCI6ImM0NjBhMzAzLTE5OTMtNDcwMS05MWQyLWFmMWY1YTcyODRmNyIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3NDIwODE5NjQsImV4cCI6MTc0MjA4NTU2MywiaWF0IjoxNzQyMDgxOTY0LCJqdGkiOiJkZDBhOTQ4MS01YWYyLTQ4MDMtOTRjZC0xMWEyNDQ5NjZlZDciLCJ1c2VybmFtZSI6IjU0Yzg1NGQ4LTQwMTEtNzBmNy1jOTZiLWUxZWYxZGIyZThiZCJ9.LGZWMpfTSYTU93tuBXm5c8PyE1HFKXGU3xoz2nnJpmXwBU-WFIQAlessyuoV8hVR02EcT2qRkpVNljhmva4_cQp7Rs0BS7aS4vM5ri4qy2nqrS4nCoKUBhQ2q1Ov7_zkHCdA_Y7ETCsWjoMUrPWxSeyVzDN9_P6NyI74VRBrA6b95K5GqZcdUhebk2lkro2NfLb0wKMCmOEtRu6-weN8jTJHZohl-lfBwLiLx_xIONzNfSrw1vqX9jplk-1tHUP0LVEZY6XsiRhzV_bAULc3d_U3phjSKZnLamAyoPWTcJ0_D1ZvllVg9b5ICijZVHWUYNAmcw08XKULWQD5eQbiqQ",
    "ExpiresIn": 3600,
    "TokenType": "Bearer",
    "RefreshToken": "eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.hwZcqf7uS42fiSIV0dD1SVUAZsC1CmhkabXHgjuqVaMv-M63xUisNbJnlmjH4mnb-6Ut268njRLmNPl43-xhf9VK5RoBAILR8j4rKKQ8uHdiEL6qmihupHNQXbenKKBvEwZzaFd8Lp55jPE1xDmNAtUp6G2KFDyW4Oi89WcTX6M11x1A8PwhcYVcu_y-JUV8hx0WAEf3goOOTHkolR1cGNrWwFDhaoJMTL9-sChCtVL2fHLuPRYrWuuMA3QCwi-tF1zWBQ6jFAEv7oE5AmBkH2KtF-TBslkCOxEo5Q52Dan7QBN9SQfPDMYOtyv50_tJl3qeDe76FWvTXSraJ10hRQ.h2mn6Xoc3fHbHY1-.rVwD-BubQwzVIMkaoIpySb8ytQ_Zz_40YU8VSjpenmJqm-TrpzFOs48ySXyViZsHhgZOKo4oBrxPSiKZF-y2Jet2AFkIwuxaKCkgt_z0a83unTzjrSpyOm6hbqqVpsW97bwz22pFn6HIx5VbpaMk-rzZTYrfKvd3CfdhF1z0WmeL7zLb7QANj3P9S_hp6H5TEECZXBhPBfAo0c6fX6lIuMZL9GEkb8lqMTWUBmp7XOjKzlSnHOpKFeczqpzLbQH8SFDJOn57LbxGpsFLfgGFP1N8eCHsK33Dh-fcX9pH5n482XNCOYgF9zb69MGEam9B42mwXxMWEToz17SMEBxDbvKpPEoj3VjqTXfo_6Sou-TYBK8kdaSHd0GYa9ZVR7VzP3fsRy6PDt-fcFp98H_JNcWXkh7KZ22EGD9_JHwoxE3u3Ds6jTcM-Fhj7-SLqxHIA0iGE04VblbmcoI7gKz2uPDP-abVKuiQS1ITx8k0OfPjnHtSbeqXuZzzdJYNTcIIYRtgANovhI6ShsQyCV5ZifGZQAw0LAaKGrX-00WBBFZruy24qlwOSTD7VUoOPi02EFuaU-01VF5YO-PYFvlnXP8Zs1lwQQ0C2XE2A4N5SZV997aO6zcnP48a68MDTV83Ot4PfM8GuCKmm0K3DusFEpBXjB5WTYYQR4hZ4Rcl_pl2w91c9a7c6gSd1HvgwehVu_K66ExeFMc80hvKsu10wEu2reZw8y-_kRuoWKoSncIppSaOn9eURSuiiUg-HImtZX48SBfYcfLlTtmVPGFno-VOBByLGaxQ6cKufgJWqUYu_9hZwi0lA_YMDVLOG8Cfc0eC7fACP3E409zMhFJ0x7LK2EbQ6bI7rXFwPjodxenBJB_V6IzvdB-d75ngqN8GDTdBWnXA97sYY50nldbtUKDBilqk77w70HElTynJJskLO-7MYFH_RiMOoWX_FN2woLDJzzO-8ayLIHW9Q-8Saa8PzYivdPM3zLKrpJBn7jt4x3USve5hjwRr_EWA-UhqovDVYTrxg5VKASp5DNWZd405NUd0SLtoxQJmLIfr0SiYWrrjQCziL60wu7XHTSP_hL6d0GvIWUoCXYvX8dhlxvF2lkr1dHFW57uV4AO1Uurs_dOh1Nyt4etJ_s8yn92-5kK57k6B0SXDaNNNHo4U2klPpO8cXCS11kxHincfXQA84z1OCzvFOHyf6tuBRwJsZWHAI55wTYjQvjqYeEo9R6yYTEj0WPDUGYYMd96kK24KtlNe7r7P2XblFVA5DDEcsvAba9XXeru1nhbpUycNJFNIEKgj64U1RRF-aq460i82IgGqkitKIhxOUK4.erXRgKHp3X2IdqshNuLGYg",
    "IdToken": "eyJraWQiOiJqc1lXVnNYbExtQVJWREh2OVliSElcL1NcL1wvWkRwWW1NXC83bnV3MlBibSsrZz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1NGM4NTRkOC00MDExLTcwZjctYzk2Yi1lMWVmMWRiMmU4YmQiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9MMHp3ZEo2dHgiLCJjb2duaXRvOnVzZXJuYW1lIjoiNTRjODU0ZDgtNDAxMS03MGY3LWM5NmItZTFlZjFkYjJlOGJkIiwib3JpZ2luX2p0aSI6IjZhOTAzN2I3LTk5NTEtNDljNS04MDc2LTIwMTZhZWU0YWY4ZiIsImF1ZCI6IjNjNHY3M3FsYzE5YnAwbWV2bTk0ZjVhNGNvIiwiZXZlbnRfaWQiOiJjNDYwYTMwMy0xOTkzLTQ3MDEtOTFkMi1hZjFmNWE3Mjg0ZjciLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTc0MjA4MTk2NCwiZXhwIjoxNzQyMDg1NTYzLCJjdXN0b206Y3BmIjoiMTk2MDc4MzIwMzUiLCJpYXQiOjE3NDIwODE5NjQsImp0aSI6ImU5ZTIxNzNlLWNlZmEtNGVjMS1hMTg3LWRlZjRjNzk3ZjNlMSIsImVtYWlsIjoibWV1ZW1haWxtdWl0b2xlZ2FsQGdtYWlsLmNvbSJ9.XRhtQ4a6oSqv-SjegkIOoVtFyTxpWzwv8WfwimFaIn4k32KEmyVZXiO6Zq_Z72vSjavdiWL7ZxL9ySI4voMdfVwePnpJzfrJ2Tq7_8Bdx6al4w-inYx3_7c5I_eBuJvnniU0Uxch1a3D5uLH8OHZdlUxLWvwjk14h_6T-6ItLMT9tz11t1HUtF_MK_NSjPpnRFagDZdqyzQxdOVghHNJF3cDHw8-llWTnrx95OC7lk5L4UTuLQhfNXd864j0QuVVDM9aLi-KMVbuF7_BUUo-FY6lhI_A7PIzfd3M9QLYmekIUOLqbGtcBjeKaRrmQbJ0OYMnm0D_GdY7NyuX4WnWjw"
  }
}
```

#### Fluxo de vida do AccessToken
As informações recebidas no `IdToken` devem ser transitadas nas requisições para a API principal.  
O `IdToken` deve ser passado no header `Authorization`:  
`Authorization eyJraWQiOiJhRV......`

O cliente chamador deve fazer o gerenciamento manual desses tokens, e realizar a chamada de `refresh` do token sempre que o mesmo 
expirar.  
O endpoint `/refresh-token` é utilizado para isso:  
```shell
curl --request POST \
  --url https://yjj3g3ipw2.execute-api.us-east-1.amazonaws.com/prod/refresh-token \
  --header 'Authorization: Bearer eyJraWQiOiJhRVVvVkZ3UEFiUUJaUjFBcFY3MFwva242UmJtSFNGejVFXC96Mm95b3R5WTQ9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1NGM4NTRkOC00MDExLTcwZjctYzk2Yi1lMWVmMWRiMmU4YmQiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9MMHp3ZEo2dHgiLCJjbGllbnRfaWQiOiIzYzR2NzNxbGMxOWJwMG1ldm05NGY1YTRjbyIsIm9yaWdpbl9qdGkiOiI2YTkwMzdiNy05OTUxLTQ5YzUtODA3Ni0yMDE2YWVlNGFmOGYiLCJldmVudF9pZCI6ImM0NjBhMzAzLTE5OTMtNDcwMS05MWQyLWFmMWY1YTcyODRmNyIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3NDIwODE5NjQsImV4cCI6MTc0MjA4NTU2MywiaWF0IjoxNzQyMDgxOTY0LCJqdGkiOiJkZDBhOTQ4MS01YWYyLTQ4MDMtOTRjZC0xMWEyNDQ5NjZlZDciLCJ1c2VybmFtZSI6IjU0Yzg1NGQ4LTQwMTEtNzBmNy1jOTZiLWUxZWYxZGIyZThiZCJ9.LGZWMpfTSYTU93tuBXm5c8PyE1HFKXGU3xoz2nnJpmXwBU-WFIQAlessyuoV8hVR02EcT2qRkpVNljhmva4_cQp7Rs0BS7aS4vM5ri4qy2nqrS4nCoKUBhQ2q1Ov7_zkHCdA_Y7ETCsWjoMUrPWxSeyVzDN9_P6NyI74VRBrA6b95K5GqZcdUhebk2lkro2NfLb0wKMCmOEtRu6-weN8jTJHZohl-lfBwLiLx_xIONzNfSrw1vqX9jplk-1tHUP0LVEZY6XsiRhzV_bAULc3d_U3phjSKZnLamAyoPWTcJ0_D1ZvllVg9b5ICijZVHWUYNAmcw08XKULWQD5eQbiqQ' \
  --data '{
    "refreshToken": "eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.hwZcqf7uS42fiSIV0dD1SVUAZsC1CmhkabXHgjuqVaMv-M63xUisNbJnlmjH4mnb-6Ut268njRLmNPl43-xhf9VK5RoBAILR8j4rKKQ8uHdiEL6qmihupHNQXbenKKBvEwZzaFd8Lp55jPE1xDmNAtUp6G2KFDyW4Oi89WcTX6M11x1A8PwhcYVcu_y-JUV8hx0WAEf3goOOTHkolR1cGNrWwFDhaoJMTL9-sChCtVL2fHLuPRYrWuuMA3QCwi-tF1zWBQ6jFAEv7oE5AmBkH2KtF-TBslkCOxEo5Q52Dan7QBN9SQfPDMYOtyv50_tJl3qeDe76FWvTXSraJ10hRQ.h2mn6Xoc3fHbHY1-.rVwD-BubQwzVIMkaoIpySb8ytQ_Zz_40YU8VSjpenmJqm-TrpzFOs48ySXyViZsHhgZOKo4oBrxPSiKZF-y2Jet2AFkIwuxaKCkgt_z0a83unTzjrSpyOm6hbqqVpsW97bwz22pFn6HIx5VbpaMk-rzZTYrfKvd3CfdhF1z0WmeL7zLb7QANj3P9S_hp6H5TEECZXBhPBfAo0c6fX6lIuMZL9GEkb8lqMTWUBmp7XOjKzlSnHOpKFeczqpzLbQH8SFDJOn57LbxGpsFLfgGFP1N8eCHsK33Dh-fcX9pH5n482XNCOYgF9zb69MGEam9B42mwXxMWEToz17SMEBxDbvKpPEoj3VjqTXfo_6Sou-TYBK8kdaSHd0GYa9ZVR7VzP3fsRy6PDt-fcFp98H_JNcWXkh7KZ22EGD9_JHwoxE3u3Ds6jTcM-Fhj7-SLqxHIA0iGE04VblbmcoI7gKz2uPDP-abVKuiQS1ITx8k0OfPjnHtSbeqXuZzzdJYNTcIIYRtgANovhI6ShsQyCV5ZifGZQAw0LAaKGrX-00WBBFZruy24qlwOSTD7VUoOPi02EFuaU-01VF5YO-PYFvlnXP8Zs1lwQQ0C2XE2A4N5SZV997aO6zcnP48a68MDTV83Ot4PfM8GuCKmm0K3DusFEpBXjB5WTYYQR4hZ4Rcl_pl2w91c9a7c6gSd1HvgwehVu_K66ExeFMc80hvKsu10wEu2reZw8y-_kRuoWKoSncIppSaOn9eURSuiiUg-HImtZX48SBfYcfLlTtmVPGFno-VOBByLGaxQ6cKufgJWqUYu_9hZwi0lA_YMDVLOG8Cfc0eC7fACP3E409zMhFJ0x7LK2EbQ6bI7rXFwPjodxenBJB_V6IzvdB-d75ngqN8GDTdBWnXA97sYY50nldbtUKDBilqk77w70HElTynJJskLO-7MYFH_RiMOoWX_FN2woLDJzzO-8ayLIHW9Q-8Saa8PzYivdPM3zLKrpJBn7jt4x3USve5hjwRr_EWA-UhqovDVYTrxg5VKASp5DNWZd405NUd0SLtoxQJmLIfr0SiYWrrjQCziL60wu7XHTSP_hL6d0GvIWUoCXYvX8dhlxvF2lkr1dHFW57uV4AO1Uurs_dOh1Nyt4etJ_s8yn92-5kK57k6B0SXDaNNNHo4U2klPpO8cXCS11kxHincfXQA84z1OCzvFOHyf6tuBRwJsZWHAI55wTYjQvjqYeEo9R6yYTEj0WPDUGYYMd96kK24KtlNe7r7P2XblFVA5DDEcsvAba9XXeru1nhbpUycNJFNIEKgj64U1RRF-aq460i82IgGqkitKIhxOUK4.erXRgKHp3X2IdqshNuLGYg"
}'
```

A resposta será similar a essa:
```json
{
  "accessToken": "eyJraWQiOiJhRVVvVkZ3UEFiUUJaUjFBcFY3MFwva242UmJtSFNGejVFXC96Mm95b3R5WTQ9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1NGM4NTRkOC00MDExLTcwZjctYzk2Yi1lMWVmMWRiMmU4YmQiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9MMHp3ZEo2dHgiLCJjbGllbnRfaWQiOiIzYzR2NzNxbGMxOWJwMG1ldm05NGY1YTRjbyIsIm9yaWdpbl9qdGkiOiI2YTkwMzdiNy05OTUxLTQ5YzUtODA3Ni0yMDE2YWVlNGFmOGYiLCJldmVudF9pZCI6ImM0NjBhMzAzLTE5OTMtNDcwMS05MWQyLWFmMWY1YTcyODRmNyIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3NDIwODE5NjQsImV4cCI6MTc0MjA4Njg2MiwiaWF0IjoxNzQyMDgzMjYyLCJqdGkiOiJkMmE5ZTkzNC04MjQ1LTQ4OWEtOGY4Ni1kZmM4YjYxMGRiOTgiLCJ1c2VybmFtZSI6IjU0Yzg1NGQ4LTQwMTEtNzBmNy1jOTZiLWUxZWYxZGIyZThiZCJ9.bYHgVImWpXru67rHPQLAKvdjKXTHdslAspjQbm8brezlHL9_ofdQHvcsNe9V0NuoYCjzBoCiFutMr86UGXBcdmgDfugdtxeSqSv7-TmhTGnWUbbHaO7ZhOj2vqMv9zRWKkgufkvowGz8bIZaHCljwTMQ1pJNomXkRnv8F-legtZBK0X-GgY40Hm9PjeeIUbf2VmbSY4grXRSstnnFWqEP6QZmfuGGnQNNQlNJQG8Y_F6m4FFYTOmLiV1feKll6A6VVi_ao7dj4FawQOpS7NU6g9xB3Eclk00mJX5ZSyH8KsLU9GoZs1X5P99UOwFFyuoogvhnNksv2bKpHA88sqzfw",
  "idToken": "eyJraWQiOiJqc1lXVnNYbExtQVJWREh2OVliSElcL1NcL1wvWkRwWW1NXC83bnV3MlBibSsrZz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1NGM4NTRkOC00MDExLTcwZjctYzk2Yi1lMWVmMWRiMmU4YmQiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9MMHp3ZEo2dHgiLCJjb2duaXRvOnVzZXJuYW1lIjoiNTRjODU0ZDgtNDAxMS03MGY3LWM5NmItZTFlZjFkYjJlOGJkIiwib3JpZ2luX2p0aSI6IjZhOTAzN2I3LTk5NTEtNDljNS04MDc2LTIwMTZhZWU0YWY4ZiIsImF1ZCI6IjNjNHY3M3FsYzE5YnAwbWV2bTk0ZjVhNGNvIiwiZXZlbnRfaWQiOiJjNDYwYTMwMy0xOTkzLTQ3MDEtOTFkMi1hZjFmNWE3Mjg0ZjciLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTc0MjA4MTk2NCwiZXhwIjoxNzQyMDg2ODYyLCJjdXN0b206Y3BmIjoiMTk2MDc4MzIwMzUiLCJpYXQiOjE3NDIwODMyNjIsImp0aSI6ImU0MmZlNDRjLTgyYzUtNDQ2MS05Mzg2LTRjNTI1NjA3OTg0MyIsImVtYWlsIjoibWV1ZW1haWxtdWl0b2xlZ2FsQGdtYWlsLmNvbSJ9.EuB0fQpoYI_LpSrLniLvkcYI6HChiiw_3ebkeC8jmhSEeAflzqNUqv_Xb6JLTkx9EzvC0K7ERFS9F3LF5UVsN0okILGA7MPFh86vySSb26x6HX1gZgac0pEdWqTwRgXOoEpRlW5qlaO5Bw-rAgBwMaCLXwzgsVL5t4f1M98BqemAQj-BQ3CE6fE0DCGtm1n9LDOHGpAXZIEU6gus0m_XXDtJPdo0g3SJxRqfFRlZpRfWchvMEpmt7h8bARhuatSJlgBAqnr6hC_BHmBG5pLfNgVB52eVI7cuU9nyMM4G_C9OScsV2NwCoun_Gft0Qhf3ipDrh_-_blP-K3CglaFEtQ",
  "refreshToken": "eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.hwZcqf7uS42fiSIV0dD1SVUAZsC1CmhkabXHgjuqVaMv-M63xUisNbJnlmjH4mnb-6Ut268njRLmNPl43-xhf9VK5RoBAILR8j4rKKQ8uHdiEL6qmihupHNQXbenKKBvEwZzaFd8Lp55jPE1xDmNAtUp6G2KFDyW4Oi89WcTX6M11x1A8PwhcYVcu_y-JUV8hx0WAEf3goOOTHkolR1cGNrWwFDhaoJMTL9-sChCtVL2fHLuPRYrWuuMA3QCwi-tF1zWBQ6jFAEv7oE5AmBkH2KtF-TBslkCOxEo5Q52Dan7QBN9SQfPDMYOtyv50_tJl3qeDe76FWvTXSraJ10hRQ.h2mn6Xoc3fHbHY1-.rVwD-BubQwzVIMkaoIpySb8ytQ_Zz_40YU8VSjpenmJqm-TrpzFOs48ySXyViZsHhgZOKo4oBrxPSiKZF-y2Jet2AFkIwuxaKCkgt_z0a83unTzjrSpyOm6hbqqVpsW97bwz22pFn6HIx5VbpaMk-rzZTYrfKvd3CfdhF1z0WmeL7zLb7QANj3P9S_hp6H5TEECZXBhPBfAo0c6fX6lIuMZL9GEkb8lqMTWUBmp7XOjKzlSnHOpKFeczqpzLbQH8SFDJOn57LbxGpsFLfgGFP1N8eCHsK33Dh-fcX9pH5n482XNCOYgF9zb69MGEam9B42mwXxMWEToz17SMEBxDbvKpPEoj3VjqTXfo_6Sou-TYBK8kdaSHd0GYa9ZVR7VzP3fsRy6PDt-fcFp98H_JNcWXkh7KZ22EGD9_JHwoxE3u3Ds6jTcM-Fhj7-SLqxHIA0iGE04VblbmcoI7gKz2uPDP-abVKuiQS1ITx8k0OfPjnHtSbeqXuZzzdJYNTcIIYRtgANovhI6ShsQyCV5ZifGZQAw0LAaKGrX-00WBBFZruy24qlwOSTD7VUoOPi02EFuaU-01VF5YO-PYFvlnXP8Zs1lwQQ0C2XE2A4N5SZV997aO6zcnP48a68MDTV83Ot4PfM8GuCKmm0K3DusFEpBXjB5WTYYQR4hZ4Rcl_pl2w91c9a7c6gSd1HvgwehVu_K66ExeFMc80hvKsu10wEu2reZw8y-_kRuoWKoSncIppSaOn9eURSuiiUg-HImtZX48SBfYcfLlTtmVPGFno-VOBByLGaxQ6cKufgJWqUYu_9hZwi0lA_YMDVLOG8Cfc0eC7fACP3E409zMhFJ0x7LK2EbQ6bI7rXFwPjodxenBJB_V6IzvdB-d75ngqN8GDTdBWnXA97sYY50nldbtUKDBilqk77w70HElTynJJskLO-7MYFH_RiMOoWX_FN2woLDJzzO-8ayLIHW9Q-8Saa8PzYivdPM3zLKrpJBn7jt4x3USve5hjwRr_EWA-UhqovDVYTrxg5VKASp5DNWZd405NUd0SLtoxQJmLIfr0SiYWrrjQCziL60wu7XHTSP_hL6d0GvIWUoCXYvX8dhlxvF2lkr1dHFW57uV4AO1Uurs_dOh1Nyt4etJ_s8yn92-5kK57k6B0SXDaNNNHo4U2klPpO8cXCS11kxHincfXQA84z1OCzvFOHyf6tuBRwJsZWHAI55wTYjQvjqYeEo9R6yYTEj0WPDUGYYMd96kK24KtlNe7r7P2XblFVA5DDEcsvAba9XXeru1nhbpUycNJFNIEKgj64U1RRF-aq460i82IgGqkitKIhxOUK4.erXRgKHp3X2IdqshNuLGYg"
}
```

**Importante**: É obrigatório utilizar o header `Authorization` com o `AccessToken` correto para realizar a chamada a esse endpoint. 
