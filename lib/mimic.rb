
class MethodNotDefined < StandardError
end

class InstanceMethodNotDefined < MethodNotDefined
end

class ClassMethodNotDefined < MethodNotDefined
end

module Mimic

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def mimics(class_name)
      class_name.instance_methods(false).map { |method_name| define_method(method_name)           { |*args| } }
      class_name.methods(false).map          { |method_name| define_singleton_method(method_name) { |*args| } }
    end

    def stubs(method_name, &block)
      raise InstanceMethodNotDefined, "Method: #{method_name} Isn't Defined on Base Class" unless method_defined?(method_name)
      define_method(method_name) { |*args| yield }
    end

    def class_stubs(method_name, &block)
      raise ClassMethodNotDefined, "Method: #{method_name} Isn't Defined on Base Class" unless methods(false).include?(method_name)
      define_singleton_method(method_name) { |*args| yield }
    end
  end
end


