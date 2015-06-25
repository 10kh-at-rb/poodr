# Managing Dependencies
A dependency is anytime one object knows about another object. Dependencies are inevitable in any program for it to work but to make our programs easy to change we have to keep the dependencies to a minimum and make them explicit.


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
Right now we would say that `Gear` and `Wheel` are tightly coupled. If you would like to use`Gear` in a another context, `Wheel` has to come with it. That means you can't reuse `Gear` in any place that doesn't also have `Wheel` defined. It does not have to be this way. 
 
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

When we inject an instance of `Wheel` into `Gear` it means that `Gear` is no longer responsible for knowing about `Wheel`, but then who's responsibility is it? Right now, we are going to ignore this question right now and deal with it later in the chapter. What is important to focus on now is the recognition that it should not be the job of `Gear` to know about `Wheel`.  

### Isolate Dependencies
If you can, it's best to always inject dependencies. Sometimes you will not be able to inject a dependency, in that case the next best thing to do is to isolate them. You isolate them to make it clear that this is a dependency so that if and when you can remove it later you know exactly where to find it. 

>Dependencies are foreign invaders that represent vulnerabilities, and they should be concise, explicit, and isolated. 

What follows are two techniques for isolating dependencies.

#### Isolate Instance Creation
If you have to create in instance of `Wheel` inside of `Gear` it  is best to make it explicit. Creating the instance inside the `gear_inches` hides it. You can make it clear that ` gear_inches` is tied to an instance of `Wheel` by explictly creating it somewhere in the class. 

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


## Managing Dependency Direction


### Reversing Dependencies

### Choosing Dependency Direction

