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

* Transparent: it should be clear what will happen to this piece of code and to any other code that depends on it if you make a change.
* Reasonable: any change should be worth the effort it takes to implement. It should not be hard to make a change that doesn't change much. 
* Usable: You should be able to reuse this code in ways you can't predict.
* Exemplary: The code should set standard for how any future changes should be made. 

So the goal is to write code that is TRUE. 

## How to Create a Class that has a Single Responsibility

### Why does Single Responsibility Matter?

### How to Determine if a Class has a Single Responsibility

### How to know When to Make Design Decisions

## How to Write Code that Embraces Change

### How to Depend on Behavior and not Data

#### Hide Instance Variables

#### Hide Data Structures

### How to Enforce Single Responsibility Everywhere

#### Extract Extra Responsibilities from Methods

#### Isolate Extra Responsibilities in Classes

