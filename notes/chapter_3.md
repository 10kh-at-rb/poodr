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

* __Know the name of a message being sent to another object__: 'Gear' knows that it must send the `diameter` message to wheel.

* __Know the arguments that must be passed to a message__: 'Gear' knows that a new `Wheel` needs to be initialized with a `rim` and a `tire`.

* __Know the order of arguments that must be passed to a message__: `Gear` knows that to initialize a new `Wheel` it needs to pass `rim` then `tire`.


Our `Gear` class knows way too many things. This makes it _unreasonable_. Remember that code that is reasonable is code where any change made worth the effort it takes to implement. Right now, a small change in `Wheel` could cause several changes in `Gear`. 
 
### Coupling Between Objects

### Other Dependencies


## How to write loosely coupled code

### Inject Dependencies

### Isolate Dependencies

### Remove Argument-Order Dependencies


## Managing Dependency Direction


### Reversing Dependencies

### Choosing Dependency Direction

