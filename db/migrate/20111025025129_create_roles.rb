class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|

      t.string :name,        null: false
      t.string :title,       null: false
      
      t.text :description, null: false
      t.text :the_role,    null: false

      # Use Postgresql's native json
      # Remove this test if you using PostgreSQL prior to 9.2
      # Untested (for future versions)
      # if ::ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      #   t.json :the_role, :null => false
      # else
      #   t.text :the_role, :null => false
      # end

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end