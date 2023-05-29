class ApplicationSerializer
  delegate_missing_to :object

  # TODO: Remove `scope: nil` and just use keyword arguments in sub-classes
  def initialize(object, scope: nil)
    @object = object
    @scope = scope
  end

  private

  attr_reader :object, :scope
end