class CardMailer < ActionMailer::Base
  default from: "from@example.com"

  def created(validator)
  	@validator = validator
  	mail to: validator.email, subject: "New card submitted !"
  end

  def validated(checkers)
  	@checkers = checkers
  	mail to: checkers.pluck(:email), subject: "New card validated"
  end

  def verified(card_admins)
  	@card_admins = card_admins
  	mail to: card_admins.pluck(:email), subject: "Card verified"
  end
end