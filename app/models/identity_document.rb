# == Schema Information
#
# Table name: identity_documents
#
#  id                    :bigint           not null, primary key
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer
#  document_updated_at   :datetime
#  status                :string(255)      default("denied")
#  person_id             :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class IdentityDocument < ApplicationRecord
	belongs_to :person
	has_attached_file :document, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :document, content_type: /\Aimage\/.*\z/

  IDENTITY_DOCUMENT_STATUSES=[
    ACCEPTED = "accepted".freeze,
    PENDING = "pending".freeze,
    DENIED = "denied".freeze
  ].freeze

  def accepted_status
    self.status == "accepted"
  end

  def pending_status
    self.status == "pending"
  end

  # after_create :send_document_confirmation_mail

  # def send_document_confirmation_mail
  #   debugger
    
  # end
end
