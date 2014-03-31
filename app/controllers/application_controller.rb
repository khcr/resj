class ApplicationController < ActionController::Base
  include SessionsHelper
  include HeaderHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # add different types of flash messages
  add_flash_types :error, :success, :notice

  before_action :set_locale, :restrict_access

  def default_url_options(options={})
    locale = I18n.locale
    { locale: (locale == :fr ? nil : locale), access: params[:access] }
  end
 
  def current_permission
		@current_permission ||= Permission.new(current_user)
	end

	helper_method :current_permission, :store_location

  def track_activity(trackable, action = params[:action], controller = params[:controller])
    if !trackable.nil? && !trackable.changed?
  	 Activity.create! action: action, controller: controller, trackable: trackable, user: current_user unless trackable.changed?
    end
	end

  def connected?
    if !current_user
      store_location
      redirect_to connexion_path, error: "Please log in"
    end
  end

  def authorize_create
    if !current_permission.allow_create?(params[:controller])
      redirect_to root_path, error: "Not authorize"
    end
  end

  def authorize_modify
    if !current_permission.allow_modify?(params[:controller], params[:action], current_resource)
      redirect_to root_path, error: "Not authorize"
    end
  end

  def authorize_action
    if !current_permission.allow_action?(params[:controller], params[:action], current_resource)
      redirect_to root_path, error: "Not authorize"
    end
  end

  # Store the current url in session's variable
  # 
  # * *Args*    :
  # 
  # * *Returns* :
  #
  def store_location
    session[:return_to] = request.fullpath
  end

  # Redirect the user to the stored url or the default one provided
  # 
  # * *Args*    :
  #   - default path to redirect to
  # * *Returns* :
  #
  def redirect_back_or(default, message = nil)
    redirect_to(session[:return_to] || default, message)
    session.delete(:return_to)
  end

  def replace_responsable(user, card)
    responsable = Responsable.find_by_email(user.email)
    CardResponsable.find_by_card_id_and_responsable_id(card.id, responsable.try(:id)).try(:destroy)
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def restrict_access
    if !request.path.in?(%w[/resources/orators/new /resources/orators /coming_soon]) && params[:access] != "rubyforever"
      redirect_to coming_soon_path
    end
  end

end
