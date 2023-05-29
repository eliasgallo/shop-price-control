class ApiControllerResponseStatus < StandardError
  attr_reader :status, :code, :message

  STATUSES = {
    ok:                       { code: 200, msg: 'OK' },
    item_already_deleted:     { code: 204, msg: 'Item already deleted' },
    wrong_username_password:  { code: 401, msg: 'Wrong username or password.' },
    session_expired:          { code: 440, msg: 'Session expired' },
    bad_request:              { code: 400, msg: 'Bad request' },
    auth_failed:              { code: 401, msg: 'Authentication failed' }
  }

  def initialize(status, message = nil)
    unless STATUSES.key?(status)
      raise StandardError, "Unknown status code: #{code}.
                          Possible codes are: #{STATUSES.keys.join(', ')}"
    end
    @status = status
    @code = STATUSES[status][:code]
    @message = message || STATUSES[status][:msg]
  end
end
