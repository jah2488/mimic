#Mimic [![Build Status](https://secure.travis-ci.org/jah248/mimic.png?branch=master)](https://secure.travis-ci.org/jah2488/mimic.png)

##Rspec style mocking and stubbing for NullObjects, Fakes, and more!##

Inspired by [r00k's](http://www.twitter.com/r00k) talk at [magicruby](http://magic-ruby.com/), I decided to work on a minimalistic library for mocking and stubbing full classes. The original purpose would be to have a NullObject consistently stay in sync with its real object equivelant with minimal effort.

## Installing ##

````sh
gem install mimic
````
or

````ruby
#Gemfile
gem 'mimic'
````

````sh
bundle install
````

## Usages ##

Given we have an awesome class
````ruby
class NameResponder

  def hello
    "hi"
  end

  def name
    "John"
  end

  def full_name(first, last)
    "#{first} #{last}"
  end

  def self.reverse(name)
    name.reverse
  end

end
````

Then in our NullObject / Fake / Mimic we simply need to include it and use it.
````ruby
class FakeResponder
  include Mimic
  mocks NameResponder

  stubs(:name) { "None" }

  class_stubs(:reverse) { "no name" }
end
````

Then anywhere we would use `NameResponder` we can use `FakeResponder` and it will respond to all calls. The default return value for all methods is simply `nil`, but with the `stubs(:method) { result }` method you can specify what you want to be returned.

````ruby

responder = NameResponder.new
fake      = FakeResponder.new

responder.hello #=> "hi"
fake.hello      #=> nil

responder.name  #=> "John"
fake.name       #=> "None"

responder.full_name "Jane", "Doe" #=> "Jane Doe"
fake.full_name "Avdi", "Burnhart" #=> nil

NameResponder.reverse "Ryan" #=> "nayR"
FakeResponder.reverse "Ryan" #=> "no name"

````

## Error Handling ##
To keep you from stubbing methods that don't exist and thus getting your fake out of sync with your base class, Mimic throws two custom exceptions based on what travesty you committed. 

If you try to stub an instance method that does not belong on the base class, you will get `InstanceMethodNotDefined` Error.

If you try to stub a class method that does not belong on the base class, you will get `ClassMethodNotDefined` Error.

Pretty self explanatory. These are simply here as a gentle reminder that will help keep your fake in sync with your base class before you get in production and start chasing nil and NoMethod errors.



## Developing for Mimic ##
If you have any feature requests or bug fixes, I actively encourage you to try out integrating those changes yourself and making a pull request.

First fork the repo
````sh
git clone [GITHUB GIT URL]
bundle
rspec
````
Check all the tests and then from there have fun!


## TODO ##

    * Test that setters and getters are also properly mocked/stubbed
    * See if it'd be a horrible idea to mix this into ruby's class so you don't have to `include Mimic` in your mimic classes
    * Module Stubbing/Mocking
    * Strict Parameter checking. **Currently all mocked methods allow n arguments.**
