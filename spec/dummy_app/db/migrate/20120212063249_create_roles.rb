class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|

      t.string :name,  default: ""
      t.string :title, default: ""
      t.text :description

      # t.text :the_role
      # Use Postgresql's native json
      # Remove this test if you using PostgreSQL prior to 9.2

      # if ::ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      #   t.json :the_role, :null => false
      # else
      #   t.text :the_role, :null => false
      # end

      t.text :the_role, null: false

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end