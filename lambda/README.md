## Lambda

Esse diretório contém os arquivos `handler` de todos os lambdas utilizados na autenticação.

### Desenvolvimento

Após alterar o respectivo `index.js`, crie uma nova versão do arquivo `.zip` que será mencionado na configuração
do Terraform.

Exemplo:

```shell
npm init -y
npm install axios # CASO existam dependencias
npm instal ...
```

E crie o arquivo `zip`:

```shell
# Na pasta onde está localizado o index.js
# Substituita 'pre_signup' pelo nome do lambda
zip -r lambda_pre_signup_payload.zip *
```

