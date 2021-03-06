module Inch
  module CodeObject
    module Provider
      module YARD
        # CodeObject::Provider::YARD::Object object represent code objects.
        #
        module Object
          class << self
            # Returns a Proxy object for the given +yard_object+
            #
            # @param yard_object [YARD::CodeObject]
            # @return [Provider::YARD::Object]
            def for(yard_object)
              @cache ||= {}
              if proxy_object = @cache[cache_key(yard_object)]
                proxy_object
              else
                @cache[cache_key(yard_object)] = class_for(yard_object).new(yard_object)
              end
            end

            private

            # Returns a Proxy class for the given +yard_object+
            #
            # @param yard_object [YARD::CodeObject]
            # @return [Class]
            def class_for(yard_object)
              class_name = yard_object.class.to_s.split('::').last
              eval("::Inch::CodeObject::Provider::YARD::Object::#{class_name}")
            rescue
              Base
            end

            # Returns a cache key for the given +yard_object+
            #
            # @param yard_object [YARD::CodeObject]
            # @return [String]
            def cache_key(yard_object)
              yard_object.path
            end
          end
        end
      end
    end
  end
end

require_relative 'object/base'
require_relative 'object/namespace_object'
require_relative 'object/class_object'
require_relative 'object/constant_object'
require_relative 'object/method_object'
require_relative 'object/method_parameter_object'
require_relative 'object/module_object'
