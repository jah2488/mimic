require 'mimic'

class MyNode
  def hello
    "hi"
  end
  def johnny
    "bill"
  end
  def add(first, second)
    first + second
  end
  def self.used
    "u called me"
  end
  def self.holla
    "back"
  end
end

class MyFakeNode
  include Mimic
  mimics MyNode
  stubs(:add)  { "five" }
  class_stubs(:used) {  1000  }
end


describe Mimic do

  it "mocks all methods on fake class" do
    MyFakeNode.instance_methods(false).should == MyNode.instance_methods(false)
  end
  it "mocks all class methods on fake class" do
    MyFakeNode.methods(false).should == MyNode.methods(false)
  end

  it "returns nil for instance method calls" do
    a = MyFakeNode.new
    a.hello.should  be_nil
    a.johnny.should be_nil
  end

  it "returns nil for class method calls" do
    MyFakeNode.holla.should be_nil
  end

  it "should let you stub a class method" do
    MyFakeNode.used.should == 1000
  end

  it "returns the stubbed response for a given methods" do
    a = MyFakeNode.new
    a.add.should ==  "five"
  end

  it "will return the stubbed response even when the method is given parameters" do
    a = MyFakeNode.new
    a.add(2,5).should == "five"
  end

  it "should raise exception if method is not defined on base class" do
    lambda {
      a = class MyNullObject
        include Mimic
        mimics MyNode
        stubs(:subtract) { "10"}
      end
    }.should raise_error InstanceMethodNotDefined
  end

  it "should raise exception if method is not defined on base class" do
    lambda {
      a = class MyNullObject
        include Mimic
        mimics MyNode
        class_stubs(:subtract) { "10" }
      end
    }.should raise_error ClassMethodNotDefined
  end

  it "should raise exceptions on methods being called with wrong amount of arguements" do
    lambda {
      class MyNullObject
        include Mimic
        mimics MyNode
      end
      a = MyNullObject.new
      a.hello(10)
    }.should raise_error ArgumentError
  end

end
