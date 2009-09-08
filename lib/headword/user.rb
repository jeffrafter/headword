module Headword
  module User

    # Hook for all Headword::User modules.
    #
    # If you need to override parts of Headword::User
    # extend and include à la carte.
    #
    # @example
    #   extend ClassMethods
    #   include InstanceMethods
    #   include AttrAccessor
    #   include Callbacks
    #
    # @see ClassMethods
    # @see InstanceMethods
    # @see Validations
    # @see Scopes
    # @see Callbacks
    def self.included(model)
      model.extend(ClassMethods)
      model.send(:include, InstanceMethods)
      model.send(:include, Validations)
      model.send(:include, Callbacks)
    end

    module Validations
      # Hook for validations.
      #
      # :username must be present and unique
      # :url must be unique
      def self.included(model)
        model.class_eval do
          validates_presence_of :username
          validates_uniqueness_of :username
          validates_uniqueness_of :url
        end
      end
    end

    module Callbacks
      # Hook for callbacks.
      #
      # :title should act like a url.
      def self.included(model)
        model.class_eval do
          acts_as_url :username, :sync_url => true
          attr_protected :url
          attr_accessible :username
        end
      end
    end

    module InstanceMethods
      # We want to use username urls instead of ids in our routes
      def to_param
        url
      end
    end  

    module ClassMethods
    end
  end
end
