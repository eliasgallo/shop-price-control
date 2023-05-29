# frozen_string_literal: true

module JSONHelpers
  def json_response
    @json_response ||= JSON.parse(response.body)
  end
end
