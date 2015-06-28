# Designing Classes with a Single Responsibility
The point of this chapter is to go over the principles and techniques that will help us build classes that do one thing and are easy to change later. We will go over what belongs in a class and several techniques to make it easy to change later.

We can never predict what change will come later so the first thing we do is to make it as simple as possible. We need the code we write to do what is being asked of it now, without trying to predict everything it will be asked to do in the future. However if we follow the Single Responsibility Principle we will make it easy to change later.

## How to Decide what Belongs in a Class
This section will focus on where to put your code.


### How to Group Methods into Classes
You will put your methods in a class but at the beginning of your project you cannot possibly get this right, so don't worry about it too much just start.

 


### How to Organize Code to Allow for Easy Changes

Before you know how to write code that is easy to change you need to know what
"easy to change" means. One useful definition of easy to change is :

* __Transparent__: it should be clear what will happen to this piece of code and to any other code that depends on it if you make a change.
* __Reasonable__: any change should be worth the effort it takes to implement. It should not be hard to make a change that doesn't do much.
* __Usable__: You should be able to reuse this code in ways you can't predict.
* __Exemplary__: The code should set standard for how any more code should be written.

So the goal is to write code that is __TRUE__.

## How to Create a Class that has a Single Responsibility
When trying to break up your application into classes start by describing what your application is going to do and look for the nouns. In the example program we are going to write a Ruby program that calculates gear ratios for bicycles. So we have two nouns already _bicycle_ and _gear_. We start with gear because it is the thing that will calculate the gear ratio.

We make a `Gear` class that takes in two parameters, _chainring_ and _cog_ and we write a method `gear_ratio`. This is a simple class with a simple method doing one thing, but then we are asked to calculate the gear inches, which is how are far the bike travels in one revolution of the wheel.

To write the `gear_inches` method we need to know about the wheel. More specifically the rim diameter and the tire diameter. So we just add two more parameters to the `initialize` method of the `Gear` class. Now if someone wants to get the gear inches of a bicycle they just initialize a new instance of the Gear class passing in `chainring`, `cog`, `rim` and `tire`.  But this breaks any previous code because the `Gear` class now needs four parameters to be initialized.  Now is the time to ask:

Is this the best way to organize the code?

### Why does Single Responsibility Matter?
Single Responsibility matters because a class that does one thing is easy to reuse in ways we can't predict.

> Applications that are easy to change consist of classes that are easy to reuse. Reusable classes are pluggable units of well-defined behavior that have few entanglements.

If the class you wrote does more than one thing, when the day comes that you want to reuse it you may not be able to because the responsibilities are all mixed up. What can happen:

1. You duplicate the code you need. This is bad because anytime you want to make a change you have to go find everywhere the code is duplicated to make a change.

2. You structured the code in such a way that you could just get the things you want out of the class but since the class your reusing has many responsibilities it has many reasons to change. Any change can break the thing you are reusing the class for.

We write classes that have a single responsibility because we can't tell the future.

> Design is more the art of preserving changeability than it is the act of achieving perfection.

### How to Determine if a Class has a Single Responsibility
So you are convinced that you should write classes that have a single responsibility, how do you tell if a class has a single responsibility?

You ask it questions. Any method that the class responds to is a question you can ask it. In our example you can ask the Gear class the following questions:

* What is the size of your chainring?
* What is the size of the cog?
* What is your gear ratio?
* What are you gear inches?
* What is your tire size?
* What is your rim size?


You write what the class does in one sentence. If your sentence includes the words _and_ or _or_ that is a sign that your class does more than one thing. We could say the purpose of the `Gear` class is to _Calculate the ratio between two toothed sprockets_ but then only the first three questions make sense. Why should the gear class know about gear inches, rim size and tire size?

Classes don't have to be super narrowly defined pieces of code. They just have to be what is called _cohesive_. Everything in the class has to be related to it's purpose. It is not unreasonable to have the Gear class answer the question about gear inches if its purpose is to _Calculate the effect that a gear has on a bicycle_. This still makes it weird that `Gear` would know about tire size and rim size.

### How to Know When to Make Design Decisions
Though `Gear` clearly does more than one thing, it might still be a good choice to leave it as is. We may never need to change it again and even if we do end up having to make a change we have no idea what that change will be. Right now we have a very small application that we completely understand. It is _Transparent_ and _Reasonable_. You know exactly what it does and any change would be trivial because the program is so small. It perfectly fine to leave the `Gear` class as is.

However, there are also good reasons to refactor the `Gear` class. It is not _Usable_ nor _Exemplary_. We cannot reuse the `Gear` class somewhere else without worrying about rim size and tire size. It also is not a good example of how we want the rest of our code to be organized. The way you organize code now will set the standard for how the rest of the code in your application is organized. We say we want `Gear` to _Calculate the effect a gear has on a bicycle_ but it knows about tire size and rim size.

## How to Write Code that Embraces Change
This section will present two techniques that help to write code that is easy to change later. It will then go into detail on each technique implementing them on the bicycle app we are writing.

### Depend on Behavior  not Data
It is better to hide the data behind a method. This makes it easier to change the data later by changing what the method returns.


#### Hide Instance Variables
Wrap a method around instance variables. Anytime you want that data just call the method.

Two things to be aware of:

1. Unless you make that method private, anyone can now send a message to the class and get the data. This could be good or bad, deciding which way to go will be discussed in chapter 4 _Creating Flexible Interfaces_.
2. You are blurring the distinction between data and objects. Most of the time thinking of everything as objects is fine.

#### Hide Data Structures
If you have methods that need to understand how data is structured in order to use it that means that anytime the data changes you have to rewrite the method. It is better wrap a complex data structure in a `Struct` or even its own `class` so that you can send messages to it to get the data you need.  

This technique is especially important when dealing with data that comes from somewhere else, like another object or user input. That data can change anytime.

### How to Enforce Single Responsibility Everywhere
Make sure every method also only does one thing. Ask it the same questions you would ask a class and describe what it does with one sentence being aware anytime "and" or "or" pop up.

#### Extract Extra Responsibilities from Methods
Any method, just like a class should have a single responsibility.

For example:

```ruby
def diameters
  wheels.collect {|wheel| wheel.rim + (wheel.tire * 2) }
end
```

What does this method do?

It actually does two things:

* Iterates over the wheels
* Calculates the diameter of each wheel

How can we make it only do one thing?

__Separate the iteration from the action that is being performed in each iteration.__

```ruby
def diameters
  wheels.collect {|wheel| diameter(wheel)}
end

def diameter(wheel)
  wheel.rim + (wheel.tire * 2)
end

```
This may hurt performance but right now the most important thing is not performance, but writing code that is easy to change. Also you already wrote code that calculated the diameter of a single wheel, now you have a method that makes it clear. This `diameter` method can now be used anytime just might need to find the diameter of just one wheel.


Now for something a little more complicated, remember `gear_inches` from `Gear` class.

```ruby
def gear_inches
  ratio * (rim + (tire*2))
end
```

* Is `gear_inches` the responsibility of the `Gear` class?
  That seems reasonable
* What is the code inside `gear_inches` doing?
  It is calculating the diameter of a wheel _and_ then calculating the gear_inches.

Recognizing this we break the calculation of the diameter into its own method.

```ruby
def gear_inches
  ratio * diameter
end

def diameter
  rim + (tire * 2)
end

```

Now you can ask:
* Is the diameter of a wheel the responsibility of the `Gear` class?
  Obviously not

* Should the wheel be in its own class?
  This is not clear cut, because so far the only time we need information about a wheel is in the context of a gear. The best thing to do now is to make your code easy to change, not to try and predict the future.


__Important Point__

>You do not have to know where you’re going to use good design practices to get there. Good practices reveal design.

The point of doing these refactorings is not because you know what the final design will be but because they help you discover the design. Refactoring by following these principles leads to methods that:

* __Expose previously hidden qualities__: By enforcing the principle that every method should only do one thing, we found out that our `gear_inches` method calculated the diameter of a wheel, which is definitely not the job of the Gear class.
* __Avoid the need for comments__: Well organized code is a lot more descriptive than any comment because comments often don't keep up with the changes in the code.
* __Encourage reuse__: Because each method does one thing that method is a lot easier to reuse because you know what it will do. It also sets a standard that other programmers will follow.
* __Are easy to move to another class__: If you do need to do a re-design of the code, it is a lot easier if each method does only one thing.



#### Isolate Extra Responsibilities
Just because we realized that `Gear` class is figuring out the diameter of a wheel doesn't mean that we need a `Wheel` class. So far, we only use information about the wheel in the context of a gear, maybe that is the only place we will ever need to know about a wheel's diameter. Remember the point of Object Oriented Design is to make your code easy to change later, committing to a `Wheel` class now is premature. Luckily, Ruby gives us a way to remove the responsibility of figuring out the diameter of the wheel from the `Gear` class without writing another class. We just use a `Struct`.

So now our `Gear` class looks like:

```ruby
class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @wheel     = Wheel.new(rim, tire)
  end

  def ratio
    chainring/cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end


  Wheel = Struct.new(:rim, :tire) do
    def diameter
      rim + (tire * 2)
    end
  end
end

```

It is reasonable to expect that since you a writing an app for cyclist you will eventually need a `Wheel` class but you haven't received the information about what exactly you will need that class to do other than give you the diameter of a wheel which you already have nicely isolated in a `Struct`. You may never touch this code again. Remember:

> Design is more the art of preserving changeability than it is the act of achieving perfection.


## Finally, the Real Wheel
You cyclist friend comes and ask you that she needs the program to calculate the the circumference of a wheel. A new feature request that you are completely prepared for because you enforced single responsibility everywhere. You create the `Wheel` class and add the `#circumference` method to it.

Now it's no big deal create a `Wheel` class, initialize the `Gear` with an optional wheel.

```ruby
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel=nil)
    @chainring = chainring
    @cog       = cog
    @wheel     = wheel
  end

  def ratio
    chainring/cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim  = rim
    @tire = tire
  end

  def circumference
    diameter * Math::PI
  end

  def diameter
    rim + (tire * 2)
  end

end

```

>The code is not perfect, but in some ways it achieves a higher standard: it is good enough.

## Summary
This chapter was more about process than result. We had an app to build and we knew we eventually wanted to write a class that had a single responsibility but we did not start off trying to do that. We started by just writing code that met the specs.  But after we got something working we started to ask some questions of our code:

* What does this class do? What messages does it respond to? Should it respond to those messages?
  We questioned every message that the class responds to and we asked if it made sense that the class responded to this message.

* If a class responds to a message that it shouldn't, does it matter?
  Just because the class responds to a message that we think it shouldn't, doesn't mean that we need to create a whole new class just for that method. Maybe the code is good enough right now.

* What does each method do? Can I make its job more obvious by breaking out any code into its own method?
  Just like classes methods should also have a single responsibility. By enforcing this everywhere we get a better understanding of what each bit of code is doing, revealing any hidden qualities.

* How can I hide data and complex data structures behind a method?
  This is especially important if you don't control the data. When the data changes you won't have to go hunting for every place you used the data.

* If I see something that doesn't belong in class, do I need a new class or can I just isolate it some other way?
  Just because you can do something, doesn't mean you should. The goal is code that is easy to change later. Sometimes the best thing to do is nothing. Other times you can just isolate the offending code somewhere so that when you do get more information you can decide what to do about it.

As we ask these questions we discover more and more about our code, things we could not have known at the beginning.
