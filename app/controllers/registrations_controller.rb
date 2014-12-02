class RegistrationsController < ApplicationController
  def new
    @registration_requests = u2f.registration_requests

    session[:registration_challenges] = @registration_requests.map(&:challenge)
  end
end
