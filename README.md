# Guardiões da Saúde API

Esse repositório é referente à API usada no aplicativo [Guardiões Da Saúde](https://github.com/proepidesenvolvimento/guardioes-app). Logo ela é responsável por todas as requests que são feitas no aplicativo assim como o armazenamento dos dados no banco de dados.

Veja mais em nossa página [clicando aqui](https://proepidesenvolvimento.github.io/guardioes-api/)
## Technologies

Usamos nessa API:
- [Ruby on Rails](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Docker](https://www.docker.com/)


Esse repositório é referente à API usada no aplicativo [Guardiões Da Saúde](https://github.com/proepidesenvolvimento/guardioes-app). Logo ela é responsável por todas as requests que são feitas no aplicativo assim como o armazenamento dos dados no banco de dados.

Veja mais em nossa página [clicando aqui](https://proepidesenvolvimento.github.io/guardioes-api/)

## Tecnologias

Usamos nessa API:
- [Ruby on Rails](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Docker](https://www.docker.com/)

## Como levantar o ambiente

### O que fazer antes

Crie um arquivo chamado 'master.key' na pasta '/config', esse arquivo deve conter uma chave para tudo funcionar corretamente. Você pode conseguir essa chave com algum desenvolvedor do projeto.

### Levantando

#### Sem logs do rails
```
$docker-compose build 
$docker-compose up -d
```
#### Com logs do rails
```
$docker-compose up
```

### O que fazer depois

Se o ambiente inicializou corretamente, agora basta migrar a base de dados com o comando a seguir:

```
docker-compose run web rake db:migrate
```

Teste se tudo está funcionando entrando em [http://localhost:3001](http://localhost:3001]). Você deverá ver um JSON se tudo funciona normalmente.

### Erros

### Key

#### "/config/initializers/devise.rb: undefined method '[]' for nil:NilClass"

Significa que você está tentando levantar o ambiente sem a key citada acima.

#### Postgres

O postgres é uma grande fonte de erros.

##### "Database '...' does not exist"

Basta criar a base de dados

```
docker-compose exec db bash
...
psql -U postgres
...
create database [nome da base de dados];
```

#### Elastic

##### "Failed to open TCP connection to localhost:9200"

Isso significa que a API tentou mandar uma mensagem para a base de dados Elastic e não encontrou no endereço localhost:9200. O Elastic é outra base que opera em separado do postgres.

Para solucionar, basta levantar uma instância do [guadioes web](https://github.com/proepidesenvolvimento/guardioes-web/) rodando na porta 9200 ou alterar o endereço do elastic no arquivo elasticsearch.rb.

### Testes

Basta escrever

```
rspec
```

E caso queria testar um modulo em específico

```
rspec spec/[pasta]/[arquivo]
```

## License & copyright

ProEpi, Associação Brasileira de Profissionais de Epidemiologia de Campo

Licensed under the [Apache License 2.0](LICENSE.md).
