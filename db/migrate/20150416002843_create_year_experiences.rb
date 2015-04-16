class CreateYearExperiences < ActiveRecord::Migration
  def change
    create_table :year_experiences do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
