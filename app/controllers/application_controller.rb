class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout
  before_action :set_locale
  before_action :set_user, if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    respond_to do |format|
      format.turbo_stream {
        flash.now[:error] =  "Access denied on #{exception.action} #{exception.subject.inspect}"
        render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
      }
      format.html { redirect_to page_path('notallowed') }
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    Rails.logger.debug "ActionController::InvalidAuthenticityToken on #{exception.action} #{exception.subject.inspect}"
    sign_out_user # Example method that will destroy the user cookies
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.debug "ActiveRecord::RecordNotFound on #{exception.action} #{exception.subject.inspect}"
    record_not_found!
  end

  rescue_from RackCAS::ActiveRecordStore::Session do |exception|
    Rails.logger.debug "RackCAS::ActiveRecordStore::Session on #{exception.action} #{exception.subject.inspect}"
    access_denied!
  end

  private

  # Select the current_user
  # @return [class] User
  def set_user
    @user = current_user
  end

  # Set locale from `params[:locale]`.
  # If params[:locale] is unset or is not available,
  # the method set the default locale
  # @return [Symbol,String] new locale definition
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Render 404 page and stop the work
  # @return [nil]
  def record_not_found!
    render partial: 'errors/404', status: 404 && return
  end

  # Select the layout name based on request type: xhr request or other
  # @return [String] the layout name
  def set_layout
    request.xhr? ? 'empty' : 'application'
  end

  # Render 401 page and stop the work
  # @return [nil]
  def access_denied!
    render partial: 'pages/notallowed', status: :unauthorized and return
  end

  # {access_denied!} unless the request.xhr == true
  # @return [nil]
  def xhr_required!
    access_denied! unless request.xhr?
  end

  # Localize a fieldName if #obj is present
  # @param [Text] field_label
  # @param [Text] obj
  # @return [String] localized
  def t_field(field_label = nil, obj = '')
    return '' if field_label.blank?

    case obj
    when Class
      I18n.t(field_label, scope: "activerecord.attributes.#{obj.class}", default: field_label).try(:capitalize)
    when String
      I18n.t(field_label, scope: "activerecord.attributes.#{obj}", default: field_label).try(:capitalize)
    else
      I18n.t(field_label, default: field_label).try(:capitalize)
    end
  end

  # Create callback with class error messages
  # @param [Class] obj
  # @param [Text] scope
  # @return [String] errors localized messages
  def write_errors(obj, scope: false)
    obj.errors.map { |e| "#{t_field(e.attribute, scope || obj.class.table_name.singularize)} #{e.message}" }.join(', ')
  end

end
