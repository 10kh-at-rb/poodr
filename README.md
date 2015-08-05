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
notes on each chapter [here](https://github.com/edgenard/poodr/tree/master/notes) these are mostly to make sure I actually understand what I read.

I don't think it should matter I'm refactoring JavaScript code because these
principles of Object-Oriented Design should apply to any language where Object-Oriented Programming is possible. I'm  aiming to do three things:

* Apply each chapter's principle to all three classes in the game, `Snake`,
`Board` and `Snake-View`.
*  Go through one chapter a week, including all the refactoring and the posts explaining the process.(Ambitious)
* Add new features. (Super Ambitious)


## How to Design a Class with a Single Responsibility: Snake Class

This is the first in a series of post based on [POODR](http://www.poodr.com/)
where I try to apply the principles and techniques of Object-Oriented Design(OOD) to refactoring [a two player snake game I wrote](https://github.com/edgenard/two_snake).

_I know JavaScript doesn't have classes and what we are using is a constructor
function that is just like any other function. I'm going to call it a class,
because that's how I'm thinking about it._

Lets look at the `Snake` class and what it does

```javascript
    (function () {
      "use strict";
      if ( typeof Snake === "undefined") {
          window.Snake = {};
      }

      var snake = Snake.Snake = function (options) {
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
var snake = Snake.Snake = function (options) {
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
will start at `[[0,0],[0,1]]` if its a two player game the second snake will be
added at `[[19,0], [19, 1]]`. Those two positions represent the top-left and
bottom-left of the board. It is set to `this.segments` which does double duty of representing the position of the snake on the board and the snakes "body". For instance we grow the snake by adding a segment to `this.segments`.

 ![snake_starting_position](images/snake_start.png)

* `this.color = options.color` - This sets the snake's color. As you can see in
the picture above it will be black or green.

* `this.score = 0` - This sets the initial score of the snake.

* `this.shortcuts = options.shortcuts.join(", ")` - These are the keyboard
shortcuts that will allow the user to set the snakes direction. It comes in as
an array of either `["up", "left", "down" "right"]` or `["w", "a", "s", "d"]`.
The array is turned into a string with spaces between each word like `"up, left,
down, right"`.

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
 * It calls a method that adds a segment to the end of snake.
 * For example: `[[0,0], [0,1]]` becomes `[[0,1], [0,2]]` if the snake is moving east, `[[0,1], [1,1]]` if the snake is going south.


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

 This long conditional chain handles changing the direction of the snake and stopping the snake from turning on itself. For instance if the snake is going east it can't just all of a sudden go west, it first has to go south or north then turn west.


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

* `addSegment` changes the value of the `head` based on the direction the snake is going. This is first done by calling `this.head()` to get a duplicate of the head. Then the values are changed based on direction and then the new head is pushed to end of `this.segments` which represents the front of the snake.

* `head` - returns a duplicate of the snakes head.

### What Now?


The first part of the Chapter 2 in POODR says to avoid design until you have something to work with. You can't possibly get it right the first time so don't even try. Write something that works and then refactor it using the principles of OOD as your guidelines.

 We use the principles of OOD by asking questions that reveal things about our code. As we reveal more and more about our code, the design emerges.

Remember:

> Design is more the art of preserving changeability than it is the act of achieving perfection.

But before that...

### What does it mean to have code that is easy to change?

In the book Metz provides the definition that code that is easy to change is __TRUE__:

* __Transparent__: it should be clear what will happen to this piece of code and to any other code that depends on it if you make a change.
* __Reasonable__: a little change should not take a lot of work.
* __Usable__: you should be able to reuse this code in ways you can't predict.
* __Exemplary__: The code should set standard for how any more code should be written.

So that is the goal, to write code that is __TRUE__.

### What does Single Responsibility mean and how does it make our code __TRUE__?
The SRP is not about having a class that does some very teeny tiny thing. It is
really about having a class in which every method defined within it is related to its purpose. Object Oriented Programming is about sending messages to objects. So an object that follows the SRP is one in which each message it responds to makes sense for that object.

Before we ask our `Snake` class questions we have to see if it follows the SRP we first have to ask what about the SRP that makes our code easy to change?

If your class does more than one thing you can never really reuse it in a different context. When/if(most likely when) the day comes that you want to reuse the class you will have to either:

1. Copy and paste the code you want to use. This is bad because you then have to maintain that code in two or more places. If anything changes you have to go everywhere that code is written to change it.

2. Reuse the class anyway. If you wrote the class in such a way that you can just use the things you want out of it, you can just reuse it. This is even worse because your class has many reasons to change and any change can break things without any clear way to figure out why. Your code stops being transparent.

These are the reasons to work toward the SRP.

> Applications that are easy to change consist of classes that are easy to reuse. Reusable classes are pluggable units of well-defined behavior that have few entanglements

### How do we find out if a class is following the SRP?

To do answer that question we need to know what the point of our class.

#### What is the purpose of the `Snake` class?

This is what I want the snake to do

* Be able to say how big it is.
* Be able to say and update its score.
* Be able to say its direction.
* Be able to grow itself.
* Respond to inputs that change its direction.
* Be able to move itself.

Is this too many things? Can I describe the responsibility of the `Snake` class in one sentence without using _and_? Without using _or_?  It seems to me that I want to snake to do two types of things, keep track of it's current state and change it's current state.

I thought about this for a little bit and this is what I came up with:

> The `Snake` class is responsible for the current state of the snake in the game.

I think this captures all the responsibilities of the class into one coherent responsibility. We would be able to reuse it as moving and growing object type of thing in another context.


#### Is everything in the `Snake` class related to it's purpose?

Now that we know what we want the `Snake` class to do we can see if everything in it is related to it's purpose.  We will pretend the snake class is actually someone we can talk to and every method defined within it is a question we can ask. Then we analyze these questions in relation to it's purpose.

Let's call the snake Charlie and ask Charlie,

* What direction are you moving in? `this.dir`
* What color are you? `this.color`
* What are your segments? `this.segments`
* Will you please duplicate this array? `this._dup`
* How many points have you earned? `this.score`
* What keypresses do you respond to? `this.shortcuts`
* Will you please turn in this direction? `this.turn`
* Will you please move? `this.move`
* Will you please add a segment to yourself? `this.addSegment`
* Will you please give me a copy of your head? `this.head`

Most of these are reasonable questions to ask Charlie. There three that I think are suspect:

* Will you please give me a copy of your head? `this.head`
* What keypresses do you respond to? `this.shortcuts`?
* Will you please duplicate this array? `this._dup`

I think the `this.head` and `this.shortcuts` are defensible even though they are not directly related to the responsibility of the class, the way the class is structured, it would not be able to fulfill it's responsibility without them.

It needs to know the shortcuts to be able know what direction the user wants it to move. The `head` method is a little weirder but it's needed because it's how the snake is able to `addSegment` which it also needs to `move`. I also think it makes sense for the Charlie to be one who is responsible for giving a copy of his head.

Duplicating an array is harder to defend. Duplicating an array is not something Charlie needs to know how to do. This is something that we should think about removing from the `Snake` class and moving to it's own class.

But before we do that ...


### How de we know when to make design decisions?
Before we go around creating classes all over the place we need to consider that it might be better to do nothing. It is clear what the class does(__T__), it's small enough that any change would not be much work(__R__), it could be reused as a moving-growing-thing somewhere else(__U__) and though not a perfect model for future classes it's pretty close(__E__).

So I'm going to keep the `dup` method in the `Snake` class but make it obvious that it doesn't really belong there for future maintainers(especially me).

So the `Snake` now looks like:

```javascript
    (function () {
      "use strict";
      if ( typeof Snake === "undefined") {
          window.Snake = {};
      }

      var snake = Snake.Snake = function (options) {
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
        //Changed this
        return util.dup(this.segments[this.segments.length - 1]);
      };


      //Utility function, may need to be moved
      var util = Snake.Util = {};

      util.dup = function (arr) {
        var newArr = [];
        arr.forEach(function(el, i){
          newArr[i] = el;
        });
        return newArr;
      };

    })();
```

But wait there's more...

### Single Responsibility at the class level is not enough
Just making sure that every method in the class is related to its purpose is not enough to make a __TRUE__ class. The ultimate goal is not the SRP, it is a class that is easy to change and maintain. There are some techniques of dealing with the data in your class that will make it easier to change and we should also examine every method so make sure that they also follow the SRP.

#### Depend on behavior not data
If your class takes in some data and pretty much every class you write will because programming is mostly doing stuff to data. Anytime you use the data inside one of the methods you leave yourself exposed to pain in the future. Eventually your code will change, which means your data will change. Every place you used that data will also have to be changed. Instead it's often better to wrap the data in a method. If something changes you just have change what that method returns.

##### Hide Instance Variables


##### Hide Data Structures



#### Single Responsibility for every method


### Conclusion
