class ApiService
  include Showoff::Helpers::CurrentAPIUserHelper
  include Showoff::Helpers::SerializationHelper
  include Api::ErrorHelper

  attr_reader :errors, :params

  def initialize(params = nil)
    @params = params
  end

  def register_error(type, message)
    @errors = [] if @errors.nil?
    @errors << { type: type, message: message }
    nil
  end

  private

  def attribute
    if @params[:attribute] && !@attribute
      @attribute = params[:attribute].to_s
      @attribute += '=' unless attribute.ends_with?('=')
    end
    @attribute
  end

  def object
    @object ||= @params[:klass].constantize.find_by(id: @params[:id])
  end
end
