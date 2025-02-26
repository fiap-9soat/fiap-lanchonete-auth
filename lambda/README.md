## Lambda

Esse diretório contém arquivos relacionados ao código-fonte dos lambdas executados durante o fluxo de autenticação.

### Cognito e o Login Gerenciado

No momento, a opção de login gerenciado não é viavél pra gente pois não temos um cliente frontend dedicado.  
Por esse motivo, criamos lambdas para realizar a autenticação "manual" e permitir a interação diretamente com a API.  
Em outros casos, o Cognito já provê uma interface de login nativa, e um fluxo de OpenID de fácil execução.
