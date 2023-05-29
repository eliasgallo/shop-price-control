class Authentication
  def initialize(user, ip_address = 'empty')
    @user = user
    @ip_address = ip_address
  end

  def perform
    if current_session.nil?
      return user.sessions.create!(
        token: Digest::SHA1.hexdigest([Time.now, rand].join),
        ip_address: ip_address
      )
    else
      current_session.update(ip_address: ip_address)
      current_session.touch(:updated_at)
    end
    current_session
  end

  private
  attr_reader :user, :ip_address

  def current_session
    @current_session ||= user.current_session
  end
end