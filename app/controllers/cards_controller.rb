class CardsController < ApplicationController

	def index
	end

	def new
		session[:card_params] ||= {}
		@card = Card.new(session[:card_params])
	end

	# Change wizard steps
	def change
		# fusion between session and form(POST) params
		session[:card_params].deep_merge!(card_params)
		@card = Card.new(session[:card_params])
		if @card.valid? && @card.steps.include?(step = params[:step].keys.first)
			@card.current_step = step
			session[:card_params][:current_step] = @card.current_step
		end
	end


	def create
		@card = Card.new(session[:card_params])
		if @card.save
			session[:card_params] = nil
			redirect_to admin_cards_path, success: t('card.create.success')
		else
			render 'new'
		end
	end

	private

  def card_params
  	params.require(:card).permit(:name, :description, :street, :npa, :city, :email, :place, :website, :password_digest, :responsable_id, :card_type_id, :current_step) if params[:card]
  end
end