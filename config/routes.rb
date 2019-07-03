Rails.application.routes.draw do

  root to: "pages#home"

  %w(resj).each do |page|
    get page, to: "pages##{page}"
  end

end
