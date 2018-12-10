module Indestructable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
  end

  class_methods do
    def activate_all
      update_all(active: true)
      true
    end

    alias_method :activate_all!, :activate_all

    def deactivate_all
      update_all(active: false)
      all.map(&:deactivate)
      true
    end

    alias_method :deactivate_all!, :deactivate_all
    alias_method :destroy_all, :deactivate_all

    def destroy(*id_or_array)
      where(id: id_or_array).deactivate_all
    end

    def indestructable(*attributes)
      attributes = [attributes] unless attributes.is_a?(Array)
      class_eval "def indestructable_attributes; #{attributes}; end"
    end
  end

  def activate
    update_attributes(active: true) unless active
    true
  end

  alias activate! activate

  def deactivate
    update_attributes(active: false) if active
    if respond_to?(:indestructable_attributes)
      indestructable_attributes.each do |attribute|
        object = send(attribute)
        if object.is_a?(ActiveRecord::Associations::CollectionProxy) && object.proxy_association.klass.respond_to?(:deactivate_all)
          object.deactivate_all
        elsif object.respond_to?(:deactivate) && object.respond_to?(:active)
          object.deactivate if object.active
        end
      end
    end
    true
  end

  alias deactivate! deactivate
  alias destroy deactivate
end
