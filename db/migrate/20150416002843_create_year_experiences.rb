class CreateYearExperiences < ActiveRecord::Migration
  def change
    create_table :year_experiences do |t|
      t.string :name
      t.integer :low
      t.integer :high

      t.timestamps null: false
    end
  end
end
