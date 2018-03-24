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

---

# JS lifecycle

--

<!-- https://hsto.org/getpro/habr/post_images/4d8/4ac/86a/4d84ac86aaa8de45acf34a16ae928191.png -->
![](/assets/images/javascript/lifecycle.png)

- Memory Heap - the place where memory allocate.  
- Call Stack - the place where stack frames fall into the process of executing the code.

--


---
