class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def u2f
    @u2f ||= U2F::U2F.new(request.base_url)
  end
end
