# Projeto de software para o gerenciamento do Planejamento Participativo da UTFPR-PB 


### Resumo

O projeto visa gerenciar e exibir informações sobre o Planejamento Participativo da UTFPR, campus Pato Branco. O gerenciamento das informações é realizado utilizando os softwares OpenProject e Google Planilhas. Os dados são armazenados em um banco de dados relacional PostgreSQL, hospedado localmente na instituição. O projeto também inclui um website próprio para a geração e visualização de relatórios e dashboards.

### Arquitetura

A arquitetura do projeto consiste em adicionar as informações do OpenProject e/ou Google Planilhas no banco de dados e, posteriormente, exibi-las em formato de relatórios e dashboards.

O fluxo de funcionamento segue a seguinte sequência:

1. O administrador do sistema insere as informações em uma planilha do Google Planilhas;
2. O script em Python insere as informações da planilha no banco de dados PostgreSQL;
3. O OpenProject sincroniza as informações com o banco de dados;
4. A aplicação Ruby on Rails coleta e filtra a informações do banco de dados e exibe seus relatórios e dashboards;
5. O container Docker hospeda a aplicação Rails no endereço [http://172.29.150.197:3000](http://172.29.150.197:3000/) **OBS**: É necessário estar na rede da universidade para acessa-lo

	O administrador também pode gerenciar as informações diretamente pelo OpenProject através de [http://172.29.150.197/openproject/](http://172.29.150.197/openproject/)

	Diagrama da arquitetura do projeto:

![image](https://github.com/user-attachments/assets/0f6ffa44-ad28-499f-b261-fcc80301166a)



### Aplicação Ruby on Rails (RoR)

O Ruby on Rails segue uma arquitetura MVC (Model, View e Controller)


![image](https://github.com/user-attachments/assets/db3d9e65-3691-4916-a4b8-e5d6b326fe43)


Toda vez que a planilha entra em uma nova versão, é rodado o script em Python para inserção dos dados no BD, assim, a coluna _project_id_ da tabela _work_packages _é atualizada.

A aplicação Rails irá filtrar apenas os objetivos e ações do _project_id _desejado. Isso é feito pelo Model work_package.rb do Rails:

![image](https://github.com/user-attachments/assets/56fce10d-cd0a-47dd-9f44-a3261134c1ec)

Nas linhas 13 e 14 definir o “project_id: ” atual:

![image](https://github.com/user-attachments/assets/c6a5a4eb-49e9-4acb-8a0a-bdcd3d957cfd)


Todas as relações de usuários são extraídas dos perfis do OpenProject e já estão corretamente configuradas.


### Guia instalação 

Um guia de instalação e configuração de ambiente para trabalhar com o WebSite RoR


```
sudo apt-get update
sudo apt-get install git curl build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libreadline-dev

# Install rbenv locally for the dev user
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
# Optional: Compile bash extensions
cd ~/.rbenv && src/configure && make -C src
# Add rbenv to the shell's $PATH.
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# Run rbenv-init and follow the instructions to initialize rbenv on any shell
~/.rbenv/bin/rbenv init
# Issue the recommended command from the stdout of the last command
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
# Source bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install the required version as read from the Gemfile
rbenv install 3.3.3

rbenv global 3.3.3
rbenv rehash

sudo apt-get install postgresql postgresql-client
sudo su - postgres
[postgres@ubuntu]# createuser -d -P openproject

[postgres@ubuntu]# createdb -O openproject openproject_dev
[postgres@ubuntu]# createdb -O openproject openproject_test

# Exit the shell as postgres
[postgres@ubuntu]# exit
```



Verifique a instalação com:


```
ruby –version

bundler –version
```



### Conexão Rails e PostgreSQL

É necessário estar conectado na rede local da UTFPR para desenvolver o projeto Rails, já que o Model se comunica diretamente com o BD hospedado na VM. Para desenvolvimento remoto, utilizar VPN ou realizar uma cópia local do banco de dados.


### Docker

Para rodar a aplicação Rails na VM da UTFPR-PB, utiliza-se um container Docker

que está no Docker Hub. 

**OBS:** O Rails gera uma chave secreta de segurança para a aplicação, para visualizar a chave rode no terminal da aplicação o comando `rails secret`.

Para rodar o container na VM faz-se:


```
docker pull thassiamorim/planejamento
docker run -p 3000:3000 -d -e SECRET_KEY_BASE=<chave gerada> thassiamorim/planejamento`
```
### Protótipo
![image](https://github.com/user-attachments/assets/3296765c-6923-4227-8781-8175c7932225)
![image](https://github.com/user-attachments/assets/9682a64f-adfd-44eb-9687-eeef7181983c)
![image](https://github.com/user-attachments/assets/dbd8916d-b5de-4972-801f-90b6feec8fcf)

