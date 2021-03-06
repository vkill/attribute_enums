require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table "persons", :force => true do |t|
    t.string :gender
    t.boolean :enable
  end
  create_table "users", :force => true do |t|
    t.string :status
    t.string :gender
    t.boolean :removed
    t.boolean :enable
  end
end
class Person < ActiveRecord::Base
  self.table_name = "persons"
end
class User < ActiveRecord::Base
  self.table_name = "users"
end
