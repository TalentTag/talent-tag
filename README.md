TalentTag
=========

* Ruby 2.2.2
* Rails 4.2.3
* Sphinx 2.*

#### Getting Started

* **MACOSX** - Install `brew` and system dependencies:

  ```shell
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  brew install redis postgres mysql git
  ```

* Install ruby

* Install gems:

  ```shell
  bundle install
  ```

* **MACOSX** - Install `sphinx`
  To avoid errors you should instal sphinx with mysql and postgres support:

  ```shell
  brew install sphinx --mysql --pgsql
  ```

* Prepare local config files:

  ```shell
  cd config
  cp database.yml.example database.yml
  cp danthes.yml.example danthes.yml
  ```
  use your own credential for the db

* Prepare local DB:

  ```shell
  rake db:create
  rake db:migrate
  rake db:seed
  ```

* Prepare Sphinx index & start:

  ```shell
  rake ts:index
  rake ts:start
  ```

* Run faye server:

  ```shell
  rackup danthes.ru -s thin -E production
  ```

* Run rails server:

  ```shell
  rails s
  ```
