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
      class_name.instance_methods(false).map do |method_name|
        params = class_name.instance_method(method_name).parameters.map(&:last)
        define_method(method_name) do |*args|
          raise ArgumentError unless args.count.eql? params.count
        end
      end
      class_name.methods(false).map do |method_name|
        params = class_name.method(method_name).parameters.map(&:last)
        define_singleton_method(method_name) do |*args|
          raise ArgumentError unless args.count.eql? params.count
        end
      end
    end

    def stubs(method_name, &block)
      raise InstanceMethodNotDefined, error_msg(method_name)  unless method_defined?(method_name)
      define_method(method_name) { |*args| yield }
    end

    def class_stubs(method_name, &block)
      raise ClassMethodNotDefined, error_msg(method_name) unless methods(false).include?(method_name)
      define_singleton_method(method_name) { |*args| yield }
    end

    def arg_error_msg(args, params)
      "Wrong Number of Arguements for Method. (#{args.count}) of (#{params.count})"
    end

    def error_msg(method_name)
      "Method: #{method_name} Isn't Defined on Base Class"
    end
  end
end
