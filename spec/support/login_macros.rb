module LoginMacros
  def user_session(user)
    session[:user_id] = user.id
  end
end
