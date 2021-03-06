class Users::AffiliationsController < BaseController
	before_action :connected?
	layout 'admin'

	def my_cards
		@user = current_user
		@unconfirmed = @user.unconfirmed_cards
		@pending = @user.pending_cards.joins(:card_users)
		@confirmed = @user.confirmed_cards.includes(:status)
		@confirmed_paginate = @confirmed.paginate(page: params[:page], per_page: 10)
	end

	# User's request to a card
	def create
		card = Card.find_by_id(params[:card_id])
    success, card_user = Request.new(:user, user: current_user, card: card).process
    if card && success
    	CardMailer.card_affiliation_request(current_user, card)
			track_activity card_user
			redirect_to user_my_cards_path, success: t('user.card.request.success')
		else
			redirect_to user_my_cards_path, error: t('user.card.request.error')
		end
	end

	# Action on a card's request to an user
	def update
		card = Card.find_by_id(params[:id])
		success, card_user = Request.new(:user, user: current_user, card: card).answer(params[:validated])
		if card && success
			if params[:validated] == "true"
        CardMailer.confirmed_user(current_user, card).deliver_now
      else
        CardMailer.unconfirmed_user(current_user, card).deliver_now
      end
			track_activity card_user
			redirect_to user_my_cards_path, success: t('user.card.confirmation.success')
		else
			redirect_to user_my_cards_path, error: t('user.card.confirmation.error')
		end
	end

	# Cancel a request
	def destroy
		CardUser.where(user_id: current_user.id, card_id: params[:id]).destroy_all
		redirect_to user_my_cards_path, success: 'Groupe quitté'
	end
end
