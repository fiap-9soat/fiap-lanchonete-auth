## Lambda

Esse diretório contém arquivos relacionados ao código-fonte dos lambdas executados durante o fluxo de autenticação.

### Cognito e o Login Gerenciado

No momento, a opção de login gerenciado não é viavél pra gente pois não temos um cliente frontend dedicado.  
Por esse motivo, criamos lambdas para realizar a autenticação "manual" e permitir a interação diretamente com a API.  
Em outros casos, o Cognito já provê uma interface de login nativa, e um fluxo de OpenID de fácil execução.

### Desenvolvimento

Para criar ou desenvolver um novo código relacionado a um `lambda`, crie um repositório e inicialize as configurações
do NPM nele:

```shell
npm init -y
```

Com o arquivo `package.json` criado, basta executar a instalação das dependencias necessárias. Exemplo:

```shell
npm i aws-sdk
```

**Importante**: a versão do `NodeJS` utilizada é especificada no arquivo `modules/lambda/main.tf` e é comum entre todos
os `lambda`.

Ao término do desenvolvimento, navegue até a pasta raiz do lambda em questão (ex.: `cd lambda/sign_up`), e
execute o processo de zip do código para envio pelo Terraform:

```shell
zip -r lambda_function_payload.zip *
```

Feito isto, basta mencionar o arquivo com o módulo `lambda` no arquivo `main.tf` na raiz do projeto:

```hcl
module "sign_up_lambda" {
  # O source é sempre './modules/lambda'
  source   = "./modules/lambda"
  function_name = "signUpFunction"
  # Note o nome do arquivo e a pasta alvo
  filename = "lambda/sign_up/lambda_function_payload.zip"
  handler  = "index.handler"
  role     = var.role_arn
  environment = {
    USER_POOL_ID = module.cognito.user_pool_id
  }
}
```

Lembre-se de criar os respectivos endpoints no módulo de `api_gateway`, caso necessário.  
