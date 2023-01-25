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

require 'rails_helper'

RSpec.describe IdentityDocumentsController, type: :controller do

end
