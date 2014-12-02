class RegistrationsController < ApplicationController
  def new
    @registration_requests = u2f.registration_requests

    session[:registration_challenges] = @registration_requests.map(&:challenge)
  end

  def create
    @registration_response = U2F::RegisterResponse.
      load_from_json params[:response]

    registration = begin
                     u2f.register!(session[:registration_challenges],
                                   @registration_response)
                   rescue U2F::Error => e
                     return render text: e.message
                   ensure
                     session.delete :registration_challenges
                   end

    r = Registration.create(
                            user_id: session[:user_id],
                            certificate: registration.certificate,
                            key_handle: registration.key_handle,
                            public_key: registration.public_key,
                            counter: registration.counter)

    render json: r.as_json
  end
end
