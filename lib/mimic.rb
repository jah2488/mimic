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
    #To have a file strictly adhere to the implementation of another file, call <tt>mimics</tt> in
    #any class followed by the class name as an attribute.
    #
    #     class NullUser
    #       include Mimic
    #       mimics User
    #     end
    #
    #This will add all the class and instance level methods to your class that are defined in the class
    #being mimicked. All methods will default to returning nil when called. Please keep this in mind.
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

    #If you want to override the default behavior of returning nil for methods on the original class
    #simply call <tt>stubs</tt> followed by the method name and a block with the return value desired.
    #
    #    class NullUser
    #      include mimic
    #      mimics User
    #
    #      stubs(:name) { "No Name" }
    #    end
    #
    def stubs(method_name, &block)
      raise InstanceMethodNotDefined, error_msg(method_name)  unless method_defined?(method_name)
      define_method(method_name) { |*args| yield }
    end

    #If you want to override the default behavior of returning nil for class methods on the original class
    #simply call <tt>class_stubs</tt> followed by the method name and a block with the return value desired.
    #
    #   class NullUser
    #     include mimic
    #     mimics User
    #
    #     class_stubs(:age_for) { 10 }
    #   end
    #
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
