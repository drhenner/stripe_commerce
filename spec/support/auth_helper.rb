module AuthHelper
  def http_login
    user = 'ror-e'
    pw = 'David-san'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end
