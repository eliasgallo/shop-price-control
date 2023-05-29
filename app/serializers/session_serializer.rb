class SessionSerializer < ApplicationSerializer
  def as_json
    {
      username: user.username,
      token: token
    }
  end
end