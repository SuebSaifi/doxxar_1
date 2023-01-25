class CreateIdentityDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :identity_documents do |t|
      t.attachment :document
      t.string :status, :default => "denied"
      t.string :person_id
      t.timestamps
    end
  end
end
