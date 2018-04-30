---
layout: slide
title: JavaScript
---
![](/assets/images/javascript/javascript_logo.png)

---

## JavaScript is…
A scripting language that enables you to create dynamically updating content, control multimedia, animate images, and pretty much everything else.

--

At present, JavaScript can execute not only in the browser, but also on the server, or actually on any device where there exists a special program called the [JavaScript engine](https://en.wikipedia.org/wiki/JavaScript_engine).

- [V8][1] – for Chrome and Opera.
- [SpiderMonkey](https://en.wikipedia.org/wiki/SpiderMonkey) – for Firefox.
- “Trident”, “Chakra” for different versions of IE
- “ChakraCore” for Microsoft Edge
- “Nitro” and “SquirrelFish” for Safari etc.

[1]: https://en.wikipedia.org/wiki/V8_(JavaScript_engine)

--

## How engines work?
Engines are complicated. But the basics are easy.
1. The engine (embedded if it’s a browser) reads (“parses”) the script.
2. Then it converts (“compiles”) the script to the machine language.
3. And then the machine code runs, pretty fast.

---

# Data types

--

### According to the latest ECMAScript release, these are the data types:
- Boolean.
- Null.
- Undefined.
- Number.
- String.
- Symbol.
- Object.

--

## A boolean (logical type)
The boolean type has only two values: `true` and `false`

```javascript
// Examples of truthy values
if (true)
if ({})
if ([])
if (42)
if ("foo")
if (new Date())
if (-42)
if (3.14)
if (-3.14)
if (Infinity)
if (-Infinity)
```

```javascript
// Examples of falsy values
if (false)
if (null)
if (undefined)
if (0)
if (NaN)
if ('')
if ("")
if (document.all) [1]
```

--

## The “null” value
The special `null` value does not belong to any type of those described above.    
It forms a separate type of its own, which contains only the `null` value:
```javascript
let age = null;

alert(age); // shows "null"
```
In JavaScript null is not a “reference to a non-existing object” or a “null pointer” like in some other languages.  
It’s just a special value which has the sense of `nothing`, `empty` or `value unknown`.

--

## The “undefined” value
The special value `undefined` stands apart.  
It makes a type of its own, just like `null`.  
The meaning of undefined is “value is not assigned”.  
If a variable is declared, but not assigned, then its value is exactly `undefined`:
```javascript
let x;

alert(x); // shows "undefined"
```
--

## Difference between `null` and `undefined`

When checking for null or undefined, beware of the differences between equality `==` and identity `===` operators, as the former performs type-conversion.

```javascript
typeof null          // "object" (not "null" for legacy reasons)
typeof undefined     // "undefined"
null === undefined   // false
null  == undefined   // true
null === null        // true
null == null         // true
!null                // true
isNaN(1 + null)      // false
isNaN(1 + undefined) // true
```

--

## A number
```javascript
let n = 123;

n = 12.345;
```
There are many operations for numbers, e.g.  
multiplication \*, division /, addition +, subtraction - and so on.  
Besides regular numbers, there are “special numeric values” which also belong to that type:  
Infinity and NaN.

```javascript
alert( 1 / 0 ); // Infinity

alert( Infinity ); // Infinity

alert( "not a number" / 2 ); // NaN

```

--

## A string
String in JavaScript must be quoted.  
There are `3 types` of quotes:
1. Double quotes: "Hello".
2. Single quotes: 'Hello'.
3. Backticks: \`Hello\`.

Backticks are “extended functionality” quotes. They allow us to embed variables and expressions into a string by wrapping them in `${…}`.

```javascript
let str = "Ruby";

let str2 = 'Single quotes are ok too';

let phrase = `Same as ${str} interpolation`; // Same as Ruby interpolation
```

--

```Javascript
// embed an expression

alert( `the result is ${1 + 2}` ); // the result is 3
```
There is no ~~character~~ type.  
There’s only one type: `string`.

--

## A symbol
The `symbol` type is used to create unique identifiers for objects.  
The `Symbol()` function returns a value of type symbol
```javascript
Symbol('foo') === Symbol('foo'); // false

let sym = new Symbol();          // TypeError
```

--
## An object
The object type is special.  
All other types are called “primitive”, because their values can contain only a single thing (be it a string or a number or whatever). In contrast, objects are used to store `collections of data` and `more complex entities`.
```javascript
let person = {
	firstName:"John",
	lastName:"Doe",
	age:50,
	eyeColor:"blue"
};
```

Accessing Object Properties
```javascript
person.firstName;     // John

person['age'];        // 50
```

--

## The typeof operator
The `typeof` operator returns the type of the argument.  
It’s useful when we want to process values of different types differently, or just want to make a quick check.  

It supports two forms of syntax:
- As an operator: `typeof x`.
- Function style: `typeof(x)`.  

The call to typeof x returns a string with the type name:
```javascript
typeof undefined    // "undefined"
typeof 0            // "number"
typeof true         // "boolean"
typeof "foo"        // "string"
typeof Symbol("id") // "symbol"
typeof Math         // "object"
typeof null         // "object"  (*1)
typeof alert        // "function"
```

> (\*1) The result of typeof null is "object". That’s wrong.  
> It is an officially recognized error in typeof, kept for compatibility. Of course, null is not an object. It is a special value with a separate type of its own.

--

## Summary
There are `7 basic types` in JavaScript.  
- `number` for numbers of any kind: integer or floating-point.
- `string` for strings. A string may have one or more characters, there’s no separate single-character type.
- `boolean` for true/false.
- `null` for unknown values – a standalone type that has a single value null.
- `undefined` for unassigned values – a standalone type that has a single value undefined.
- `symbol` for unique identifiers.
- `object` for more complex data structures.

---

# Function

--

The `function declaration` defines a function with the specified parameters.

```javascript
function calcRectArea(width, height) {
  return width * height;
}

console.log(calcRectArea(5, 6));

// expected output: 30

```

--

The function keyword can be used to define a function inside an `expression`.

```javascript
var getRectArea = function(width, height) {
    return width * height;
}

console.log(getRectArea(3,4));

// expected output: 12

```

--

`Arrow functions` are not just a “shorthand” for writing small stuff.  
Arrow functions:

- Do not have `this`.
- Do not have `arguments`.
- Can’t be called with `new`.
- Don’t have `super`

```javascript
let multiply = (x, y) => x * y

/*
 when body has multiple lines,
 use {...} and explicit return
*/
```

--

A property of an `object` can refer to a `function` or a `getter` or `setter` method.

```javascript
var o = {
  property: function ([parameters]) {},
  get property() {},
  set property(value) {}
};
```

--

The `function*` declaration (function keyword followed by an asterisk) defines a `generator function`, which returns a `Generator` object.

```javascript
function* generator(i) {
  yield i;
  yield i + 10;
}

var gen = generator(10);

console.log(gen.next().value);
// expected output: 10

console.log(gen.next().value);
// expected output: 20
```

---

# JS lifecycle

--

JavaScript - is a `single-threaded` programming language.  
This means that he has `one call stack`.  
This means that at some point in time he can perform `only one task`.

--

A `call stack` is a mechanism for an interpreter to keep track of its place in a script that calls multiple functions — what function is currently being run, what functions are called from within that function and should be called next, etc.

--

<!-- https://hsto.org/getpro/habr/post_images/4d8/4ac/86a/4d84ac86aaa8de45acf34a16ae928191.png -->
![](/assets/images/javascript/lifecycle.png)

- Memory Heap - the place where memory allocate.  
- Call Stack - the place where stack frames fall into the process of executing the code.

--

![](/assets/images/javascript/lifecycle_web_api.png)

It is a flows, to which we do not have direct access, we can only execute calls to them.  
They are built into the browser, where asynchronous actions are performed.

For Node.js, similar APIs are implemented using C ++
--

![](/assets/images/javascript/lifecycle_event_loop.png)

The event loop solves one basic problem:  
it watches the call stack and the callback queue.  
If the call stack is empty, the loop takes the first event from the queue and puts it on the stack, which triggers this event to execute.  

This iteration is called the `tick` of the event loop. Every event is just a callback.

--

- When a script calls a function, the interpreter adds it to the call stack and then starts carrying out the function.
- Any functions that are called by that function are added to the call stack further up, and run where their calls are reached.
- When the main function is finished, the interpreter takes it off the stack and resumes execution where it left off in the main code listing.
- If the stack takes up more space than it had assigned to it, it results in a "stack overflow" error.

--

<!-- https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf -->
<!-- https://hsto.org/getpro/habr/post_images/19c/a4b/bad/19ca4bbadd85f5c38bcfa0a87a79bc75.png -->
![](/assets/images/javascript/lifecycle_multiply.png)

```javascript
function multiply(x, y) {
    return x * y;
}
function printSquare(x) {
    var s = multiply(x, x);
    console.log(s);
}
printSquare(5);
```

--

### Consider the following example:
Let's go step by step "execution" of this code and see what happens in the system.

```javascript
console.log('Hi');
setTimeout(function cb1() {
    console.log('cb1');
}, 5000);
console.log('Bye');
```
--

![](/assets/images/javascript/lifecycle_1_16.png)

Nothing happens yet. The browser console is clean, the call stack is empty.

--

![](/assets/images/javascript/lifecycle_2_16.png)

The `console.log ('Hi')` command is added to the call stack.

--

![](/assets/images/javascript/lifecycle_3_16.png)

The `console.log ('Hi')` is executed.

--

![](/assets/images/javascript/lifecycle_4_16.png)

The `console.log ('Hi')` is removed from the call stack.

--

![](/assets/images/javascript/lifecycle_5_16.png)

The `setTimeout (function cb1 () {...})` is added to the call stack.

--

![](/assets/images/javascript/lifecycle_6_16.png)

The `setTimeout` is executed. The browser creates a timer that is part of the Web API.

--

![](/assets/images/javascript/lifecycle_7_16.png)

The `setTimeout (function cb1 () {...})` is terminated and removed from the call stack.

--

![](/assets/images/javascript/lifecycle_8_16.png)

The `console.log ('Bye')` command is added to the call stack.

--

![](/assets/images/javascript/lifecycle_9_16.png)

The `console.log ('Bye')` command is executed.

--

![](/assets/images/javascript/lifecycle_10_16.png)

The console.log command ('Bye') is removed from the call stack.

--

![](/assets/images/javascript/lifecycle_11_16.png)

After a pass, at least 5000 ms., The timer will shut down and puts `cb1` callback to `Callback Queue`.

--

![](/assets/images/javascript/lifecycle_12_16.png)

The event loop takes the `cb1` function from the callback queue and places it on the call stack.

--

![](/assets/images/javascript/lifecycle_13_16.png)

The cb1 function is executed and adds `console.log ('cb1')` to the call stack.

--

![](/assets/images/javascript/lifecycle_14_16.png)

The `console.log ('cb1')` is executed.

--

![](/assets/images/javascript/lifecycle_15_16.png)

The `console.log ('cb1')` is removed from the call stack.

--

![](/assets/images/javascript/lifecycle_16_16.png)

The function `cb1` is removed from the call stack.

--

![](/assets/images/javascript/lifecycle_1_to_16.gif)


```javascript
console.log('Hi');
setTimeout(function cb1() {
    console.log('cb1');
}, 5000);
console.log('Bye');
```

---

# Closure

--

JavaScript is a very function-oriented language. It gives us a lot of freedom. A function can be created at one moment, then copied to another variable or passed as an argument to another function and called from a totally different place later.

--

### Lexical Environment

In JavaScript, every running function, code block, and the script as a whole have an associated object known as the Lexical Environment.

- Environment Record – an object that has all local variables as its properties (and some other information like the value of this).
- A reference to the outer lexical environment, usually the one associated with the code lexically right outside of it (outside of the current curly brackets).

So, a “variable” is just a property of the special internal object, Environment Record. “To get or change a variable” means “to get or change a property of the Lexical Environment”.

For instance, in this simple code, there is only one Lexical Environment:
![](/assets/images/javascript/lexical-environment-global.png)

This is a so-called global Lexical Environment, associated with the whole script. For browsers, all `script` tags share the same global environment.

--

Rectangles on the right-hand side demonstrate how the global Lexical Environment changes during the execution:

![](/assets/images/javascript/lexical-environment-global-2.png)

- When the script starts, the Lexical Environment is empty.
- The let phrase definition appears. It has been assigned no value, so undefined is stored.
- phrase is assigned a value.
- phrase refers to a new value.

--

### To summarize:

- A variable is a property of a special internal object, associated with the currently executing block/function/script.
- Working with variables is actually working with the properties of that object.
--
