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


Our `Gear` class knows way too many things. This makes it _unreasonable_. Remember that code that is reasonable is code where any change made is worth the effort it takes to implement. Right now, a small change in `Wheel` could cause several changes in `Gear`. 
 
### Coupling Between Objects
Right now we would say that `Gear` and `Wheel` are tightly coupled. If you would like to use`Gear` in a another context, `Wheel` has to come with it. That means you can't reuse `Gear` in any place that doesn't also have `Wheel` defined. It does not have to be this way. 
 
### Other Dependencies
There are two other kinds of dependencies that are not going to be dealt  with in this chapter. First there is a dependency that happens when one object sends a a chained message across several objects. This is a dangerous kind of dependency because any change on anything along the chain can break your code in several places. This is a violation of the "Law of Demeter" and will be dealt with in in Chapter 4, Creating Flexible Interfaces.

The second kind of dependency are tests. The test you write depend on code. So when the code changes, the tests often have to change with them. This becomes frustrating when the new code still does the same thing but the tests fail because they depended on some specific thing from the old code. This will be dealt with in Chapter 9, Designing Cost-Effective Tests. 

The rest of this chapter will be about to avoid any unnecessary dependencies from the the four dependencies mentioned in the _Recognizing Dependencies_ section. 

## How to write loosely coupled code

### Inject Dependencies

### Isolate Dependencies

### Remove Argument-Order Dependencies


## Managing Dependency Direction


### Reversing Dependencies

### Choosing Dependency Direction

