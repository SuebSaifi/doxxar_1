class IdentityDocumentsController < ApplicationController
	skip_before_action :cannot_access_without_confirmation, :cannot_access_without_identity_verification
  before_action(only: [:new, :create, :show, :update]) do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  before_action :check_document, only: [:new, :create]
  before_action :check_authenticity, only: [:show, :update]

	def show
		@identity_document = IdentityDocument.find(params[:id])
		@person = @identity_document.person
	end

	def new
		@person = current_person
		@identity_document = IdentityDocument.new
	end

	def create
		@person = current_person
		@identity_document = IdentityDocument.new(identity_document_params.merge(person_id: @person.id))
		if @identity_document.save!
			flash[:notice] = t("identification.new_document.flash.notice")
			@current_community.admins.each do |admin|
				@email = Email.find_by_person_id_and_community_id(admin.id, @current_community.id)
				PersonMailer.send_document_confirmation(@current_community, admin, @person, @email, @identity_document).deliver_now
			end
			redirect_to search_path
		end
	end

	def update
		@identity_document = IdentityDocument.find(params[:id])
		if @identity_document.update(update_identity_document_params)
			flash[:notice] = t('identification.update_document.flash.notice')
			@person = @identity_document.person
			@community_membership =  CommunityMembership.find_by_person_id_and_community_id(@person.id, @current_community.id)
			if @identity_document.accepted_status
				@community_membership.update(status: "accepted")
			elsif @identity_document.pending_status
				@community_membership.update(status: "pending_identity_document")
			end
			redirect_to identity_document_path(@identity_document)
		end
	end

	def after_upload_document; end

	def check_authenticity
		if @current_user.present?
	    unless @current_user.is_admin?
	      flash[:alert] = "Unauthorize access to user"
	      redirect_to search_path
	    end
	  end
  end
  private

  def check_document
		if @current_user.present?
			@person = @current_person
			if @person.identity_document.present?
				redirect_to after_upload_document_path and return
			end
		end
  end

	def identity_document_params
		params.require(:identity_document).permit(:document)
	end

	def update_identity_document_params
		params.require(:identity_document).permit(:status)
	end
end
