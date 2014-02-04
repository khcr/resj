class CardsController < ApplicationController

	def index
		@search = Card.search do
			fulltext params[:search]
			facet(:tags)
			with(:tags, params[:tag] ) if params[:tag].present?
		end
  	@cards = @search.results
  	@options = {tag: params[:tag], search: params[:search]}
	end

	def new
		session[:card_params] ||= {}
		@card = Card.new(session[:card_params])
	end

	# Change wizard steps
	def change
		# fusion between session and form (POST) params
		session[:card_params].deep_merge!(card_params)
		@card = Card.new(session[:card_params])
		if @card.valid? && @card.steps.include?(step = params[:step].keys.first)
			# update the step
			@card.current_step = step
			session[:card_params]["current_step"] = @card.current_step
		end
	end

	def create
		@card = Card.new(session[:card_params])
		if @card.save
			session[:card_params] = nil
			CardMailer.created(validator).deliver
			redirect_to admin_cards_path, success: t('card.create.success')
		else
			render 'new'
		end
	end

	private

  def card_params
  	params.require(:card).permit(:name, :description, :street, :npa, :city, :email, :place, :latitude, :longitude, :website, :password_digest, :card_type_id, :current_step, responsables_attributes: [:firstname, :lastname, :email, :_destroy, :is_contact])
  end

  def validator
  	@validator ||= User.joins(:ownerships, ownerships: [:actions]).where(actions: {name: "validated"}).first
  end
end