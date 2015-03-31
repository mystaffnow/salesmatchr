class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
