# Designing Classes with a Single Responsibility
The point of this chapter is to go over the principles and techniques that will help us build a classes that do one thing and are easy to change later. We will go over that belongs in a class and several techniques to make it easy to change later. 

We can never predict what change will come later so the first thing we do is to make it as simple as possible. We need the code we write to do what is being asked of it now, without trying to predict everything it will be asked to do in the future. However if we follow the Single Responsibility Principle we will make it easy to change later. 

## How to Decide what Belongs in a Class
This section will focus on where to put your code. 


### How to Group Methods into Classes
You will put your methods in a class but at the beginning of your project you cannot possibly get this right, so don't worry about it too much just start. 

> Design is more the art of preserving changeability than it is the act of achieving perfection.


### How to Organize Code to Allow for Easy Changes

Before you know how to write code that is easy to change you need to know what 
"easy to change" means. One useful definition of easy to change is :

* __Transparent__: it should be clear what will happen to this piece of code and to any other code that depends on it if you make a change.
* __Reasonable__: any change should be worth the effort it takes to implement. It should not be hard to make a change that doesn't change much. 
* __Usable__: You should be able to reuse this code in ways you can't predict.
* __Exemplary__: The code should set standard for how any future changes should be made. 

So the goal is to write code that is __TRUE__. 

## How to Create a Class that has a Single Responsibility
When trying to break up you application into classes start by describing what your application is going to do and look for the nouns. In example program in the book we are going to write a Ruby program that calculates gear ratios for bicycles. So we have two nouns already _bycicle_ and _gear_. We start with gear because it is the thing that will calculate the gear ratio. 

We are then asked to calculate the gear inches of of a bicycle and we have the Gear class take two more arguments when being initialized. And now we ask the question: Is this the best way to organized the code?  

### Why does Single Responsibility Matter?
Single Responsibility matters because a class that has does one thing is easy to reuse in ways we can't predict.

> Reusable classes are pluggable units of well-defined behavior that have few entanglements.

If the class you want to reuse does more than one thing, you may one day want to do only one of the things that class does but don't be able to reuse it because the responsibilities are mixed up within the class. What happens there is:

1. You duplicate the code you need. This is bad because anytime you want to make a change you have to go find everywhere the code is duplicated to make a change.

2. You structured the code in such a way that you could just get the things you want out of the class but since the class your reusing has many responsibilities it has many reasons to change. Any change can break the thing you are reusing the class for. 

A we write classes that have a single responsibility because we can't tell the future.

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

However, there are also good reasons to refactor the `Gear` class. It is not _Usable_ nor _Exemplary_. We cannot reuse the `Gear` class somewhere else without worrying about rim size and tire size. It also is not a good example of how we want the rest of our code to be organized. The way you organize code now will set the standard for how the rest of the code in your application is organized. We say we want `Gear` to _Calculate the effect a gear has on a bicycle_ but it knows about tire size and rim size. What does that have to do about the effect a gear has on a bicycle.  


## How to Write Code that Embraces Change

### How to Depend on Behavior and not Data

#### Hide Instance Variables

#### Hide Data Structures

### How to Enforce Single Responsibility Everywhere

#### Extract Extra Responsibilities from Methods

#### Isolate Extra Responsibilities in Classes

