class AddAttachmentAvatarToEmployers < ActiveRecord::Migration
  def self.up
    change_table :employers do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :employers, :avatar
  end
end
