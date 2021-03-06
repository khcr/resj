class Admin::CardsController < Admin::BaseController
	before_action :current_resource, only: [:show, :edit, :update, :destroy]
	after_action -> { track_activity(@card) }, only: [:create, :update, :destroy]

	def index
		@table = CardTable.new(self, nil, search: true)
		@table.respond
	end

	def new
		@card = Card.new
	end

	def show
		js true, lat: @card.latitude, lng: @card.longitude
	end

	def create
		@card = Card.new(card_params)
		owner = @card.responsables.select{ |r| r.is_contact == "true"}.first
		if @card.save
			@card.owner = owner
			redirect_to admin_cards_path, success: t('card.admin.create.success')
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @card.update_attributes(card_params)
			redirect_to admin_cards_path, success: t('card.admin.edit.success')
		else
			render 'edit'
		end
	end

	def destroy
		@card.destroy
		redirect_to admin_cards_path
	end

	private

  def card_params
  	params.require(:card).permit(:name, :description, :street, :location_id, :status_id, :email, :place, :latitude, :longitude, :website, :password_digest, :card_type_id, :current_step, :tag_names, :avatar, :banner, :remove_banner, :remove_avatar, { parent_ids: [] }, responsables_attributes: [:id, :firstname, :lastname, :email, :_destroy, :is_contact], affiliations_attributes: [:id, :name, :_destroy])
  end

  def current_resource
  	@card = Card.find_by_id(params[:id])
  end
end
