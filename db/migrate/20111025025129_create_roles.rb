class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|

      t.string :name,        :null => false
      t.string :title,       :null => false
      t.text   :description, :null => false
      t.text   :the_role,    :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end