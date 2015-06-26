# Managing Dependencies
A  dependency is anytime one object knows about another object. Dependencies
are inevitable in any program for it to work but to make our programs easy to
change we have to keep the dependencies to a minimum and make them explicit.

## What is a dependency?
We say object A depends on object B if when object B changes, we might be forced to make a change in Object A. Lets rewrite the `Gear` and `Wheel` classes from the last chapter to examine dependencies.

```ruby
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end
  
  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end
  
  def ratio
    chainring/cog.to_f
  end
end

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim       = rim
    @tire      = tire 
  end
  
  def diameter
    rim + (tire * 2)
  end
end
```


Lets try and list all the ways `Gear` would be forced to change because of a change to `Wheel`. There are at least four and three of them are unnecessary.


### Recognize dependencies

These are four things to look for when checking for dependencies of a class:

* __Know the name of another class__: `Gear` needs to have a class named `Wheel` existing in the environment in order for it calculate `gear_inches`

* __Know the name of a message being sent to another object__: 'Gear' knows that it must send the `diameter` message to a `wheel` object.

* __Know the arguments that must be passed to a message__: 'Gear' knows that a new `Wheel` needs to be initialized with a `rim` and a `tire`.

* __Know the order of arguments that must be passed to a message__: `Gear` knows that to initialize a new `Wheel` it needs to pass `rim` then `tire`.


Our `Gear` class knows way too many things. This makes it _unreasonable_. Remember that code that is reasonable is code where any change made is worth the effort it takes to implement. Right now, a small change in `Wheel` could cause several changes in `Gear`. 
 
### Coupling Between Objects
Right now we would say that `Gear` and `Wheel` are tightly coupled. If you would like to use`Gear` in another context, `Wheel` has to come with it. That means you can't reuse `Gear` in any place that doesn't also have `Wheel` defined. It does not have to be this way. 
 
### Other Dependencies
There are two other kinds of dependencies that are not going to be dealt  with in this chapter. First there is a dependency that happens when one object sends  a chained message across several objects. This is a dangerous kind of dependency because any change on anything along the chain can break your code in several places. This is a violation of the "Law of Demeter" and will be dealt with in Chapter 4, Creating Flexible Interfaces.

The second kind of dependency are tests. The test you write depend on code. So when the code changes, the tests often have to change with them. This becomes frustrating when the new code still does the same thing but the tests fail because they depended on some specific thing from the old code. This will be dealt with in Chapter 9, Designing Cost-Effective Tests. 

The rest of this chapter will be about how to avoid and manage dependencies from the four dependencies mentioned in the _Recognizing Dependencies_ section. 

## How to write loosely coupled code
The following are a set of techniques for either removing, isolating or managing dependencies between objects.

### Inject Dependencies
Anytime you can you should inject dependencies. If you look at `gear_inches` :

```ruby

def gear_inches
  ratio * Wheel.new(rim, tire).diameter
end

```

It is saying that it is only willing to calculate the gear inches of Wheels, so if you want to reuse it for anything else that might use gears, like a cylinder or a disk you can't. What the `Gear` class actually needs is just something that responds to the `diameter` message. If you instead initialize `Gear` with an object that responds to `diameter` you can get the gear inches for other things that have a diameter. It does not matter that inside of `Gear` it's called `@wheel`, it's just an object that responds to `diameter`. This is called "Duck Typing". It will be dealt with more in depth in Chapter 5, Reducing Costs with Duck Typing. 

When we inject an instance of `Wheel` into `Gear` it means that `Gear` is no longer responsible for knowing about `Wheel`, but then who's responsibility is it? We are going to ignore this question and deal with it later in the chapter. What is important to focus on now is the recognition that it should not be the job of `Gear` to know about `Wheel`.  

### Isolate Dependencies
If you can, it's best to always inject dependencies. Sometimes you will not be able to inject a dependency, in that case the next best thing to do is to isolate them. You isolate them to make it clear that this is a dependency so that if and when you can remove it later you know exactly where to find it. 

>Dependencies are foreign invaders that represent vulnerabilities, and they should be concise, explicit, and isolated. 

What follows are two techniques for isolating dependencies.

#### Isolate Instance Creation
If you have to create an instance of `Wheel` inside of `Gear` it  is best to make it explicit. Creating the instance inside the `gear_inches` hides it. You can make it clear that ` gear_inches` is tied to an instance of `Wheel` by explicitly creating it somewhere in the class. 

You can do this in the initialization of `Gear`

```ruby
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @wheel     = Wheel.new(rim, tire)
  end
  
  def gear_inches
    ratio * wheel.diameter
  end
```


You can explicitly define a `wheel` method inside of `Gear` that creates an instance of `Wheel`.

```ruby
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end
  
  def wheel
    @wheel ||= Wheel.new(rim, tire)
  end


  def gear_inches
    ratio * wheel.diameter
  end
end
```


Both of these remove the dependency of `gear_inches` on `Wheel` while making it clear the `Gear` is tied to the `Wheel` class. 


#### Isolate Vulnerable External Messages 
Anytime something inside of a class has to send a message to an object outside of itself, it creates a dependency. A dependency that can break the functionality of the class if something about that outside object changes. 

In our case `gear_inches` still depends on knowing that there is some outside object that responds to the message `diameter`. 

To remove that dependency we write a `diameter` method in `Gear` that deals with the outside object. 

```ruby
def gear_inches
  ratio * diameter
end

def diameter
  wheel.diameter
end
```
This technique becomes necessary when you might need to call a method on the outside object several places inside the your class. 

### Remove Argument-Order Dependencies
Anytime you send a message that requires arguments you can't help but create a dependency based on the arguments being sent. However, you can avoid having to know about the order that those arguments must be sent in. This dependency is usually hidden until you change the implementation of an object and now everything that calls it must be changed. What follows are three techniques that help manage argument dependencies. 

#### Use Hashes for Initialization Arguments
If you have control over a class that you are initializing, it is almost always better to have the `new` method take a hash. This is because:

* It removes the dependency on argument order
* It is easier to set defaults
* The key names in the hash provide documentation about what arguments the class takes.  This is a new dependency but it is a good one because it makes the code more Transparent. 

Whether or not you use this depends on your situation. Maybe you only take one or two arguments and it doesn't make sense to use a hash. Maybe you take 5 complicated arguments, in that case definitely use a hash. What tends to be most common is that you take a few arguments all the time, like `chainring` and `cog`in our example and sometimes take `wheel`. You have a few stable arguments and then some less stable ones that are likely to change. In that case it makes more sense to take the few stable arguments and then an options hash for the others. 


#### Explicitly Define Defaults
Defaults makes the class much more usable. You don't need to pass in all the
arguments to be able to use it. When the object is initialized with a hash there are several ways set the defaults. 

You can the `||` method, which acts an `or` condition

```ruby
def initialize(args)
  @chainring  = args[:chainring] || 40 
  @cog        = args[:cog] || 18 
  @wheel      = args[:wheel]
end
```

This way can sometimes be dangerous if one of the keys in the arguments hash is a boolean.  If one of the arguments is suppose to be true or false, and the default is true you will never be able to set it to false. 

You can use the `fetch` method on the hash.

```ruby
def initialize(args)
  @chainring = args.fetch(:chainring, 40)
  @cog       = args.fetch(:cog, 18)
  @wheel     = args[:wheel]
end

```

The `fetch` method will look for the `:chainring`  key in the hash, if it finds it will return whatever value associated with that key, if not it will return the second argument. 

You can take the responsibility for defaults out of the initialization method entirely

```ruby
def initialize(args)
  args = defaults.merge(args)
  @chainring = args[:chainring]
  @cog       = args[:cog]
  @wheel     = args[:wheel]
end


def defaults
  {:chainring => 40, :cog => 18}
end
```

In this case the defaults will only apply if the `args` hash doesn't already have the `:chainring` or `:cog` as keys. 

#### Isolate Multiparameter Initialization
If you don't control the method that needs to change. If it's some legacy thing that can't change or it's part of some framework, you could isolate sending the message by wrapping the receiver of the method in an abstraction, like another method or another class or module. 

If we couldn't change the `Gear` because it came with a framework we could wrap it in module that we pass a hash to, which would then initialize gear in the right order. 

```ruby
module SomeFramework
  class Gear
    attr_reader :chainring, :cog, :wheel 
    def initialize(chainring, cog, wheel)
            @chainring = chainring
            @cog       = cog
            @wheel     = wheel
    end
  end 
end

module GearWrapper 
  def self.gear(args)
    SomeFramework::Gear.new(args[:chainring], 
                            args[:cog],
                            args[:wheel])
  end
end 
```

`GearWrapper` is module instead of class because you don't expect to every actually use `GearWrapper` for anything other than making instances of `Gear`. You would never call a method on `GearWrapper`. An object whose sole job is to create other objects is called a factory. 

## Managing Dependency Direction


### Reversing Dependencies

### Choosing Dependency Direction

