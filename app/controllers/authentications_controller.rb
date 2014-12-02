class AuthenticationsController < ApplicationController
  def new
    handles = User.find(session[:user_id]).registrations.map(&:key_handle)

    @sign_requests = u2f.authentication_requests(handles)

    session[:auth_challenges] = @sign_requests.map(&:challenge)
  end

  def create
    resp = U2F::SignResponse.load_from_json params[:response]

    reg = User.find(session[:user_id]).
      registrations.find_by(key_handle: resp.key_handle)

    begin
      u2f.authenticate!(
                        session[:auth_challenges],
                        resp,
                        reg.public_key,
                        reg.counter
                        )
    rescue U2F::Error => e
      return render text: e.message
    ensure
      session.delete :auth_challenges
    end

    reg.update counter: resp.counter

    render json: params[:response]
  end
end
