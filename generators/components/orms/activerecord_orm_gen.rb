module SinatraMore
  module ActiverecordOrmGen
    
    AR = <<-AR
module ActiveRecordInitializer
  def self.registered(app)
    app.configure do
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :dbfile =>  ENV['DATABASE_URL']
      )
    end
  end
end
AR


   MIGRATION = <<-MIGRATION
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
       t.column :name, :string
       t.column :username, :string
       t.column :email, :string
       t.column :crypted_password, :string
       t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
MIGRATION

  USER = <<-USER
class User < ActiveRecord::Base  
  def self.authenticate(username, password)
    user = User.first(:conditions => { :username => username })
    user && user.has_password?(password) ? user : nil
  end
  
  def encrypt_password
    self.crypted_password = BCrypt::Password.create(password)
  end
  
  def has_password?(password)
    BCrypt::Password.new(crypted_password) == password
  end
end
USER
    
    def setup_orm
      insert_require 'active_record', :path => "config/dependencies.rb", :indent => 2
      create_file("config/initializers/active_record.rb", AR)
      create_file("db/migrate/001_create_users.rb", MIGRATION)
      create_file("app/models/user.rb", USER)
    end
  end
end