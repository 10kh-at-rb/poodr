# Notes and Code from POODR

This a repo to collect the notes and code from reading Practice Object-Oriented
Design in Ruby by Sandi Metz.

## What's all this about?
I'm reading [Pratical Object-Oriented Design in Ruby by Sandi Metz](http://www.poodr.com/)(POODR) because I want
to be a better software engineer. I've watched several of Metz's talks
from various Ruby conferences and she presents principles and techniques to help
engineers write software that is designed to be easy to maintain and easy to
change. These are the goals behind Object-Oriented Design(OOD).

This is a series of posts that goes through chapters 2 through 9 of POODR trying
to explain the principles learned through the refactoring of a two player snake
game I wrote in JavaScript. [Play the game here](http://emmanuelgenard.com/two_snake/) and
[check out the repo](https://github.com/edgenard/two_snake). I'm also keeping
notes on each chapter [here](https://github.com/edgenard/poodr/tree/master/notes) these mostly to make sure I actually understand what I read.

I don't think it should matter I'm refactoring JavaScript code because these
principles of Object-Oriented Design should apply to any language where Object-Oriented Programming is possible. I'm  aiming to do three things:

* Apply each chapter's principle to all three classes in the game, `Snake`,
`Board` and `Snake-View`.
*  Go through one chapter a week, including all the refactoring and the posts explaining the process.(Ambitious)
* Add new features. (Super Ambitious)


## How to Design a Class with a Single Responsibility: Snake-Class

This is the first in a series of post based on [POODR](http://www.poodr.com/)
where I try to apply the principles and techniques to refactoring [a two player snake game I wrote](https://github.com/edgenard/two_snake).

_I know JavaScript doesn't have classes and what we are using is a constructor
function that is just like any other function. I'm going to call it a class,
because that's how I'm thinking about it._

Lets look at the snake class and what it does

```javascript
    (function () {
      "use strict";
      if ( typeof Snake === "undefined") {
          window.Snake = {};
      }

      var snake = Snake.snake = function (options) {
        this.dir = "E";
        this.segments = options.startingPos;
        this.color = options.color;
        this.score = 0;
        this.shortcuts = options.shortcuts.join(", ");
        key(this.shortcuts, this.turn.bind(this));

      };

      snake.prototype.move = function () {
        this.segments.shift();
        this.addSegment();

      };

      snake.prototype._dup = function (arr) {
        var newArr = [];
        arr.forEach(function(el, i){
          newArr[i] = el;
        });
        return newArr;
      };
      snake.prototype.turn = function (event, handler) {
        var direction = handler.shortcut;
        if (direction === "up" || direction === "w") {

          if(this.dir !== "S") this.dir = "N";

        } else if(direction === "down" || direction === "s") {

          if (this.dir !== "N") this.dir = "S";

        } else if (direction === "right" || direction === "d"){
          if(this.dir !== "W") this.dir = "E";
        }else {
          if(this.dir !== "E") this.dir = "W";
        }
      };

      snake.prototype.addSegment = function () {
        var head = this.head();
        if (this.dir === "S") {
          head[0] = head[0] + 1;

        } else if (this.dir === "N") {
          head[0] = head[0] - 1;

        } else if (this.dir === "E") {
          head[1] = head[1] + 1;

        } else {
          head[1] = head[1] - 1;

        }
        this.segments.push(head);
      };

      snake.prototype.head = function () {
        return this._dup(this.segments[this.segments.length - 1]);
      };
    })();
```

To break this down bit by bit we start with:

```javascript
var snake = Snake.snake = function (options) {
  this.dir = "E";
  this.segments = options.startingPos;
  this.color = options.color;
  this.score = 0;
  this.shortcuts = options.shortcuts.join(", ");
  key(this.shortcuts, this.turn.bind(this));
```
This snake is initialized with an options object. The object contains:

* `this.dir = "E"` - This sets the initial direction the snake is moving. It is
"E" for east.

* `this.segments = options.StartingPos` - This is where on the board the snake
starts the game. It is a two dimensional array. For a 1 player game the snake
will start at [[0,0],[0,1]] if its a two player game the second snake will be
added at [[19,0], [19, 1]]. Those two positions represent the top-left and
bottom-left of the board. It is set to `this.segments` which to the snake
actually represents its body.

 ![snake_starting_position](images/snake_start.png)

* `this.color = options.color` = This sets the snake's color. As you can see in
the picture above it will either be black or green.

* `this.score = 0` - This sets the initial score of the snake.

* `this.shortcuts = options.shortcuts.join(", ")` - These are the keyboard
shortcuts that will allow the user to set the snakes direction. It comes in as
an array of either `["up", "left", "down" "right"]` or `["w", "a", "s", "d"]`.
The array is turned into a string with spaces between each word like "up, left,
down, right".

* `key(this.shortcuts, this.turn.bind(this))` - This is an event handler using
the keymaster.js library. When any of the shortcut keys are pressed, it will
call the `turn` function passing in the shortcut that was pressed.


The next section is :

```javascript
snake.prototype.move = function () {
  this.segments.shift();
  this.addSegment();

};
```

This function does two two things:
 * It removes the first segment in the snake which represents the snakes tail.
 * It calls a method that adds a segment to the head of the snake.


 ```javascript
 snake.prototype._dup = function (arr) {
   var newArr = [];
   arr.forEach(function(el, i){
     newArr[i] = el;
   });
   return newArr;
 };
 ```

 This function duplicates an array.

 ```javascript
 snake.prototype.turn = function (event, handler) {
   var direction = handler.shortcut;
   if (direction === "up" || direction === "w") {

     if(this.dir !== "S") this.dir = "N";

   } else if(direction === "down" || direction === "s") {

     if (this.dir !== "N") this.dir = "S";

   } else if (direction === "right" || direction === "d"){
     if(this.dir !== "W") this.dir = "E";
   }else {
     if(this.dir !== "E") this.dir = "W";
   }
 };
 ```

 This long conditional chain handles changing the direction of the snake.


 The last two functions
 ```javascript
 snake.prototype.addSegment = function () {
   var head = this.head();
   if (this.dir === "S") {
     head[0] = head[0] + 1;

   } else if (this.dir === "N") {
     head[0] = head[0] - 1;

   } else if (this.dir === "E") {
     head[1] = head[1] + 1;

   } else {
     head[1] = head[1] - 1;

   }
   this.segments.push(head);
 };

 snake.prototype.head = function () {
   return this._dup(this.segments[this.segments.length - 1]);
 };
})
 ```

* `addSegment` changes the value of the `head` based on the direction the snake is going. This is first done by calling `this.head()` to get a duplicate of the head. Then the values are changed based on direction and then the new head is pushed to end of the snakes `segments` which represents the front of the snake.

### What Now?
The first part of chapter essentially says that when you first write your class
not to design anything, just get something that works. It is only after having
something that you can begin to ask questions of it. It is in asking questions
of your code that a design emerges. You ask questions that lead you to discover
what kind of thing you've written which will reveal the things you need to do
to make sure that your class follows the Single Responsibility Principle which
will make it easy to change. But first..

### What does "code that is easy to change" mean?
In the book Sandi provides the definition that code that is easy to change is __TRUE__:

* __Transparent__: it should be clear what will happen to this piece of code and to any other code that depends on it if you make a change.
* __Reasonable__: a little change should not take a lot of work.
* __Usable__: you should be able to reuse this code in ways you can't predict.
* __Exemplary__: The code should set standard for how any more code should be written.

So that is the goal, to write code that is __TRUE__.

### What does Single Responsibility mean and how does it make our code __TRUE__?
The SRP is not about having a class that does some very teenie tiny thing. It is
really more about having a class in which every method defined within it is related to its purpose. Object Oriented Programming is about sending messages to objects. So an object that follows the SRP is one in which each message it responds to makes sense for that object. To find out if a class is following the SRP we have then to ask it questions as if it were a person.

Before we ask our `Snake` class questions we have to see if it follows the SRP we first have to ask what about the SRP that makes our code easy to change, that makes it __TRUE__?

If your class does more than one thing you can never really reuse it in a different context. What happens is that the two things that your class does are usually entangled with each other. So that you have two bad choices.

1. Copy the code and paste the code you want to use. This is bad because you then have to maintain that code in two or more places. If anything changes you have to go everywhere that code is written to change it.

2. Reuse the class anyway. If you wrote the class in such a way that you can just use the things you want out of it, you can just reuse it. But this is bad because your class has more than one reason to change. If one of the other things it does requires a change it is may change the thing you are using.


The ultimate aim is code that is easy to change and easy to maintain.

> Applications that are easy to change consist of classes that are easy to reuse. Reusable classes are pluggable units of well-defined behavior that have few entanglements.

### How do we find out if a class is following the SRP?

The short answer is that we ask it questions. We will pretend the snake class is actually a little snake and every method call we can make on is a question we can ask it.

Let's call the snake Charlie, we would ask Charlie,

* What direction are you moving in? `this.dir`
* What color are you? `this.color`
* What are your segments? `this.segments`
* Will duplicate this array? `this._dup`
* How many points have you earned? `this.score`
* Will you please turn in this direction? `this.turn`
* Will you please move? `this.move`
* Will you please add a segment to yourself? `this.segment`
* Will you please give me a duplicate of your head? `this.head`

Most of these are reasonable questions to ask Charlie, there is one that sounds
a ridiculous but if anyone should be able to give a duplicate of it's head its Charlie. It makes no sense that Charlie should know how to duplicate an array.
That is not something Charlie needs to know. 
