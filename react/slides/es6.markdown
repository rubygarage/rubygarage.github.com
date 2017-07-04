---
layout: slide
title:  ES6
---

# Variables and Scoping

--

# let
let works similarly to var, but the variable it declares is block-scoped
\- only exists within the current block.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function order(x, y) {
    if (x > y) {
        let tmp = x;
        x = y;
        y = tmp;
    }

    console.log(tmp); // ReferenceError: tmp is not defined

    return [x, y];
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function order(x, y) {
    if (x > y) {
        var tmp = x;
        x = y;
        y = tmp;
    }

    console.log(tmp); // undefined
    
    return [x, y];
}
```
--

# const

Variables which cannot be re-assigned new content. 
<br />
Notice: this only makes the variable itself immutable, 
not its assigned content.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
const PI = 3.141593
PI = 2 // TypeError: Assignment to constant variable.
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  only in ES5 through the help of object properties
//  and only in global context and not in a block scope
Object.defineProperty(typeof global === "object" ? global : window, "PI", {
    value:        3.141593,
    enumerable:   true,
    writable:     false,
    configurable: false
})
global.PI = 2
console.log(global.PI) // 3.141593
```

--

## Block-Scoped Variables

Variables declared via let and const are not hoisting and block scoped.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
for (let i = 0; i < a.length; i++) {
    let x = a[i]
    …
}
for (let i = 0; i < b.length; i++) {
    let y = b[i]
    …
}

let callbacks = []
for (let i = 0; i <= 2; i++) {
    callbacks[i] = function () { return i * 2 }
}
callbacks[0]() === 0
callbacks[1]() === 2
callbacks[2]() === 4
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var i, x, y;
for (i = 0; i < a.length; i++) {
    x = a[i];
    …
}
for (i = 0; i < b.length; i++) {
    y = b[i];
    …
}

var callbacks = [];
for (var i = 0; i <= 2; i++) {
    (function (i) {
        callbacks[i] = function() { return i * 2; };
    })(i);
}
callbacks[0]() === 0;
callbacks[1]() === 2;
callbacks[2]() === 4;
```

--

## Block-Scoped Functions

Block-scoped function definitions.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
{
    function foo () { return 1 }
    foo() === 1
    {
        function foo () { return 2 }
        foo() === 2
    }
    foo() === 1
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  only in ES5 with the help of block-scope emulating
//  function scopes and function expressions
(function () {
    var foo = function () { return 1; }
    foo() === 1;
    (function () {
        var foo = function () { return 2; }
        foo() === 2;
    })();
    foo() === 1;
})();
```

---

# Arrow Functions

--

## Statement Bodies

More expressive closure syntax.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
nums.forEach(v => {
   if (v % 5 === 0)
       fives.push(v)
})
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
nums.forEach(function (v) {
   if (v % 5 === 0)
       fives.push(v);
});
```
--

## Expression Bodies

More expressive closure syntax.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
odds  = evens.map(v => v + 1)
pairs = evens.map(v => ({ even: v, odd: v + 1 }))
nums  = evens.map((v, i) => v + i)
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
odds  = evens.map(function (v) { return v + 1; });
pairs = evens.map(function (v) { return { even: v, odd: v + 1 }; });
nums  = evens.map(function (v, i) { return v + i; });
```

--

## Lexical this

More intuitive handling of current object context.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
this.nums.forEach((v) => {
    if (v % 5 === 0)
        this.fives.push(v)
})
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  variant 1
var self = this;
this.nums.forEach(function (v) {
    if (v % 5 === 0)
        self.fives.push(v);
});

//  variant 2
this.nums.forEach(function (v) {
    if (v % 5 === 0)
        this.fives.push(v);
}, this);

//  variant 3 (since ECMAScript 5.1 only)
this.nums.forEach(function (v) {
    if (v % 5 === 0)
        this.fives.push(v);
}.bind(this));
```

---

# Extended Parameter Handling

--

## Default Parameter Values

Simple and intuitive default values for function parameters.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function f (x, y = 7, z = 42) {
    return x + y + z
}
f(1) === 50
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function f (x, y, z) {
    if (y === undefined)
        y = 7;
    if (z === undefined)
        z = 42;
    return x + y + z;
};
f(1) === 50;
```

--

## Rest Parameter

Aggregation of remaining arguments into single parameter of variadic functions.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function f (x, y, ...a) {
    return (x + y) * a.length
}
f(1, 2, "hello", true, 7) === 9
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function f (x, y) {
    var a = Array.prototype.slice.call(arguments, 2);
    return (x + y) * a.length;
};
f(1, 2, "hello", true, 7) === 9;
```

--

## Spread Operator

Spreading of elements of an iterable collection (like an array or even a string) into both literal elements and individual function parameters.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var params = [ "hello", true, 7 ]
var other = [ 1, 2, ...params ] // [ 1, 2, "hello", true, 7 ]
f(1, 2, ...params) === 9

var str = "foo"
var chars = [ ...str ] // [ "f", "o", "o" ]
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var params = [ "hello", true, 7 ];
var other = [ 1, 2 ].concat(params); // [ 1, 2, "hello", true, 7 ]
f.apply(undefined, [ 1, 2 ].concat(params)) === 9;

var str = "foo";
var chars = str.split(""); // [ "f", "o", "o" ]
```

---

# Template Literals

--

## String Interpolation

Intuitive expression interpolation for single-line and multi-line strings. (Notice: don't be confused, Template Literals were originally named "Template Strings" in the drafts of the ECMAScript 6 language specification)

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var customer = { name: "Foo" }
var card = { amount: 7, product: "Bar", unitprice: 42 }
var message = `Hello ${customer.name},
want to buy ${card.amount} ${card.product} for
a total of ${card.amount * card.unitprice} bucks?`
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var customer = { name: "Foo" };
var card = { amount: 7, product: "Bar", unitprice: 42 };
var message = "Hello " + customer.name + ",\n" +
"want to buy " + card.amount + " " + card.product + " for\n" +
"a total of " + (card.amount * card.unitprice) + " bucks?";
```

--

## Custom Interpolation

Flexible expression interpolation for arbitrary methods.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function highlight(strings, ...interpolations) {
  const highlighted = interpolations.map((value) =>
    `<span class="highlighted">${value}</span>`
  );

  return strings.map((str, index) =>
    `${str}${highlighted[index] ? highlighted[index] : ''}`
  ).join('');
}

const user = {
  name: 'John Travolta',
  age: 63
};

highlight`Hi my name is ${user.name} and i'm ${user.age} years old`;
// Hi my name is <span class="highlighted">John Travolta</span> 
// and i'm <span class="highlighted">63</span> years old
```
--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function highlight(strings, interpolations) {
  const highlighted = interpolations.map(function(value) {
    return '<span class="highlighted">' + value + '</span>';
  });

  return strings.map(function(str, index) {
    return str + (highlighted[index] ? highlighted[index] : '')
  }).join('');
}

const user = {
  name: 'John Travolta',
  age: 63
};

highlight(
  ['Hi my name is ', ' and i\'m ', ' years old'],
  [user.name, user.age]
)
// Hi my name is <span class="highlighted">John Travolta</span> 
// and i'm <span class="highlighted">63</span> years old
```

--

## Raw String Access

Access the raw string content (backslashes are not interpreted).

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
`\n`
// "
// "

String.raw `\n`
// "\n"
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  no equivalent in ES5
```

---

# Extended Literals

--

## Binary & Octal Literal

Direct support for safe binary and octal literals.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
0b111110111 === 503
0o767 === 503
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
parseInt("111110111", 2) === 503;
parseInt("767", 8) === 503;
0767 === 503; // only in non-strict, backward compatibility mode
```

--

## Unicode String & RegExp Literal

Extended support using Unicode within strings and regular expressions.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
"𠮷".length === 2
"𠮷".match(/./u)[0].length === 2
"𠮷" === "\uD842\uDFB7"
"𠮷" === "\u{20BB7}"
"𠮷".codePointAt(0) == 0x20BB7
for (let codepoint of "𠮷") console.log(codepoint)
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
"𠮷".length === 2;
"𠮷".match(/(?:[\0-\t\x0B\f\x0E-\u2027\u202A-\uD7FF\uE000-\uFFFF][\uD800-\uDBFF][\uDC00-\uDFFF][\uD800-\uDBFF](?![\uDC00-\uDFFF])(?:[^\uD800-\uDBFF]^)[\uDC00-\uDFFF])/)[0].length === 2;
"𠮷" === "\uD842\uDFB7";
//  no equivalent in ES5
//  no equivalent in ES5
//  no equivalent in ES5
```

---

# Enhanced Regular Expression

--

## Regular Expression Sticky Matching

Add ability to change regular expression lastIndex attribute

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
const input = 'foo bar';

function matcher(regex, input) {
  return () => {
    const match = regex.exec(input);
    const lastIndex = regex.lastIndex;

    return { lastIndex, match };
  }
}

const nextGlobal = matcher(/[a-z`]{3}/g, input)

nextGlobal() // { lastIndex: 3, match: ['foo'] }
nextGlobal() // { lastIndex: 7, match: ['bar'] }

const nextSticky = matcher(/[a-z`]{3}/y, input)

nextSticky() // { lastIndex: 3, match: ['foo'] }
nextSticky() // { lastIndex: 0, match: [null] }

const regularSticky = /[a-z`]{3}/y
const anotherNextSticky = matcher(regularSticky, input)

anotherNextSticky() // { lastIndex: 3, match: ['foo'] }
regularSticky.lastIndex = 4;
anotherNextSticky() // { lastIndex: 7, match: ['bar'] }
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// No equivalent in ES5 from performance perspective, 
// but can be implemented via substr
```

---

# Enhanced Object Properties

--

## Property Shorthand

Shorter syntax for common object property definition idiom.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
obj = { x, y }
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
obj = { x: x, y: y };
```

--

## Computed Property Names

Support for computed names in object property definitions.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let obj = {
    foo: "bar",
    [ "baz" + quux() ]: 42
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var obj = {
    foo: "bar"
};
obj[ "baz" + quux() ] = 42;
```

--

## Method Properties

Support for method notation in object property definitions, for both regular functions and generator functions.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
obj = {
    foo (a, b) {
        …
    },
    bar (x, y) {
        …
    },
    *quux (x, y) {
        …
    }
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
obj = {
    foo: function (a, b) {
        …
    },
    bar: function (x, y) {
        …
    },
    //  quux: no equivalent in ES5
    …
};
```

---

# Destructuring Assignment

--

## Array Matching

Intuitive and flexible destructuring of Arrays into individual variables during assignment.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var list = [ 1, 2, 3 ]
var [ a, , b ] = list
[ b, a ] = [ a, b ]
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var list = [ 1, 2, 3 ];
var a = list[0], b = list[2];
var tmp = a; a = b; b = tmp;
```

--

## Object Matching, Shorthand Notation

Intuitive and flexible destructuring of Objects into individual variables during assignment.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var { op, lhs, rhs } = getASTNode()
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var tmp = getASTNode();
var op  = tmp.op;
var lhs = tmp.lhs;
var rhs = tmp.rhs;
```

--

## Object Matching, Deep Matching

Intuitive and flexible destructuring of Objects into individual variables during assignment.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var { op: a, lhs: { op: b }, rhs: c } = getASTNode()
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var tmp = getASTNode();
var a = tmp.op;
var b = tmp.lhs.op;
var c = tmp.rhs;
```

--

## Object And Array Matching, Default Values

Simple and intuitive default values for destructuring of Objects and Arrays.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var obj = { a: 1 }
var list = [ 1 ]
var { a, b = 2 } = obj
var [ x, y = 2 ] = list
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var obj = { a: 1 };
var list = [ 1 ];
var a = obj.a;
var b = obj.b === undefined ? 2 : obj.b;
var x = list[0];
var y = list[1] === undefined ? 2 : list[1];
```

--

## Parameter Context Matching

Intuitive and flexible destructuring of Arrays and Objects into individual parameters during function calls.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function f ([ name, val ]) {
    console.log(name, val)
}
function g ({ name: n, val: v }) {
    console.log(n, v)
}
function h ({ name, val }) {
    console.log(name, val)
}
f([ "bar", 42 ])
g({ name: "foo", val:  7 })
h({ name: "bar", val: 42 })
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function f (arg) {
    var name = arg[0];
    var val  = arg[1];
    console.log(name, val);
};
function g (arg) {
    var n = arg.name;
    var v = arg.val;
    console.log(n, v);
};
function h (arg) {
    var name = arg.name;
    var val  = arg.val;
    console.log(name, val);
};
f([ "bar", 42 ]);
g({ name: "foo", val:  7 });
h({ name: "bar", val: 42 });
```

--

## Fail-Soft Destructuring

Fail-soft destructuring, optionally with defaults.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var list = [ 7, 42 ]
var [ a = 1, b = 2, c = 3, d ] = list
a === 7
b === 42
c === 3
d === undefined
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var list = [ 7, 42 ];
var a = typeof list[0] !== "undefined" ? list[0] : 1;
var b = typeof list[1] !== "undefined" ? list[1] : 2;
var c = typeof list[2] !== "undefined" ? list[2] : 3;
var d = typeof list[3] !== "undefined" ? list[3] : undefined;
a === 7;
b === 42;
c === 3;
d === undefined;
```

---

# Modules

--

## Value Export/Import

Support for exporting/importing values from/to modules without global namespace pollution.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
//  lib/math.js
export function sum (x, y) { return x + y }
export var pi = 3.141593

//  someApp.js
import * as math from "lib/math"
console.log("2π = " + math.sum(math.pi, math.pi))

//  otherApp.js
import { sum, pi } from "lib/math"
console.log("2π = " + sum(pi, pi))
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  lib/math.js
LibMath = {};
LibMath.sum = function (x, y) { return x + y };
LibMath.pi = 3.141593;

//  someApp.js
var math = LibMath;
console.log("2π = " + math.sum(math.pi, math.pi));

//  otherApp.js
var sum = LibMath.sum, pi = LibMath.pi;
console.log("2π = " + sum(pi, pi));
```

--

## Default & Wildcard

Marking a value as the default exported value and mass-mixin of values.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
//  lib/mathplusplus.js
export * from "lib/math"
export var e = 2.71828182846
export default (x) => Math.exp(x)

//  someApp.js
import exp, { pi, e } from "lib/mathplusplus"
console.log("e^{π} = " + exp(pi))
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  lib/mathplusplus.js
LibMathPP = {};
for (symbol in LibMath)
    if (LibMath.hasOwnProperty(symbol))
        LibMathPP[symbol] = LibMath[symbol];
LibMathPP.e = 2.71828182846;
LibMathPP.exp = function (x) { return Math.exp(x) };

//  someApp.js
var exp = LibMathPP.exp, pi = LibMathPP.pi, e = LibMathPP.e;
console.log("e^{π} = " + exp(pi));
```

---

# Classes

--

## Class Definition

More intuitive, OOP-style and boilerplate-free classes.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
class Shape {
    constructor (id, x, y) {
        this.id = id
        this.move(x, y)
    }
    move (x, y) {
        this.x = x
        this.y = y
    }
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var Shape = function (id, x, y) {
    this.id = id;
    this.move(x, y);
};
Shape.prototype.move = function (x, y) {
    this.x = x;
    this.y = y;
};
```

--

## Class Inheritance

More intuitive, OOP-style and boilerplate-free inheritance.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
class Rectangle extends Shape {
    constructor (id, x, y, width, height) {
        super(id, x, y)
        this.width  = width
        this.height = height
    }
}
class Circle extends Shape {
    constructor (id, x, y, radius) {
        super(id, x, y)
        this.radius = radius
    }
}
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var Rectangle = function (id, x, y, width, height) {
    Shape.call(this, id, x, y);
    this.width  = width;
    this.height = height;
};
Rectangle.prototype = Object.create(Shape.prototype);
Rectangle.prototype.constructor = Rectangle;
var Circle = function (id, x, y, radius) {
    Shape.call(this, id, x, y);
    this.radius = radius;
};
Circle.prototype = Object.create(Shape.prototype);
Circle.prototype.constructor = Circle;
```

--

## Class Inheritance, From Expressions

Support for mixin-style inheritance by extending from expressions yielding function objects.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var aggregation = (baseClass, ...mixins) => {
    let base = class _Combined extends baseClass {
        constructor (...args) {
            super(...args)
            mixins.forEach((mixin) => {
                mixin.prototype.initializer.call(this)
            })
        }
    }
    let copyProps = (target, source) => {
        Object.getOwnPropertyNames(source)
            .concat(Object.getOwnPropertySymbols(source))
            .forEach((prop) => {
            if (prop.match(/^(?:constructor|prototype|arguments|caller|name|bind|call|apply|toString|length)$/))
                return
            Object.defineProperty(target, prop, Object.getOwnPropertyDescriptor(source, prop))
        })
    }
    mixins.forEach((mixin) => {
        copyProps(base.prototype, mixin.prototype)
        copyProps(base, mixin)
    })
    return base
}

class Colored {
    initializer ()     { this._color = "white" }
    get color ()       { return this._color }
    set color (v)      { this._color = v }
}

class ZCoord {
    initializer ()     { this._z = 0 }
    get z ()           { return this._z }
    set z (v)          { this._z = v }
}

class Shape {
    constructor (x, y) { this._x = x; this._y = y }
    get x ()           { return this._x }
    set x (v)          { this._x = v }
    get y ()           { return this._y }
    set y (v)          { this._y = v }
}

class Rectangle extends aggregation(Shape, Colored, ZCoord) {}

var rect = new Rectangle(7, 42)
rect.z     = 1000
rect.color = "red"
console.log(rect.x, rect.y, rect.z, rect.color)
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var aggregation = function (baseClass, mixins) {
    var base = function () {
        baseClass.apply(this, arguments);
        mixins.forEach(function (mixin) {
            mixin.prototype.initializer.call(this);
        }.bind(this));
    };
    base.prototype = Object.create(baseClass.prototype);
    base.prototype.constructor = base;
    var copyProps = function (target, source) {
        Object.getOwnPropertyNames(source).forEach(function (prop) {
            if (prop.match(/^(?:constructor|prototype|arguments|caller|name|bind|call|apply|toString|length)$/))
                return
            Object.defineProperty(target, prop, Object.getOwnPropertyDescriptor(source, prop))
        })
    }
    mixins.forEach(function (mixin) {
        copyProps(base.prototype, mixin.prototype);
        copyProps(base, mixin);
    });
    return base;
};

var Colored = function () {};
Colored.prototype = {
    initializer: function ()  { this._color = "white"; },
    getColor:    function ()  { return this._color; },
    setColor:    function (v) { this._color = v; }
};

var ZCoord = function () {};
ZCoord.prototype = {
    initializer: function ()  { this._z = 0; },
    getZ:        function ()  { return this._z; },
    setZ:        function (v) { this._z = v; }
};

var Shape = function (x, y) {
    this._x = x; this._y = y;
};
Shape.prototype = {
    getX: function ()  { return this._x; },
    setX: function (v) { this._x = v; },
    getY: function ()  { return this._y; },
    setY: function (v) { this._y = v; }
}

var _Combined = aggregation(Shape, [ Colored, ZCoord ]);
var Rectangle = function (x, y) {
    _Combined.call(this, x, y);
};
Rectangle.prototype = Object.create(_Combined.prototype);
Rectangle.prototype.constructor = Rectangle;

var rect = new Rectangle(7, 42);
rect.setZ(1000);
rect.setColor("red");
console.log(rect.getX(), rect.getY(), rect.getZ(), rect.getColor());
```

--

## Base Class Access

Intuitive access to base class constructor and methods.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
class Shape {
    …
    toString () {
        return `Shape(${this.id})`
    }
}
class Rectangle extends Shape {
    constructor (id, x, y, width, height) {
        super(id, x, y)
        …
    }
    toString () {
        return "Rectangle > " + super.toString()
    }
}
class Circle extends Shape {
    constructor (id, x, y, radius) {
        super(id, x, y)
        …
    }
    toString () {
        return "Circle > " + super.toString()
    }
}
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var Shape = function (id, x, y) {
    …
};
Shape.prototype.toString = function (x, y) {
    return "Shape(" + this.id + ")"
};
var Rectangle = function (id, x, y, width, height) {
    Shape.call(this, id, x, y);
    …
};
Rectangle.prototype.toString = function () {
    return "Rectangle > " + Shape.prototype.toString.call(this);
};
var Circle = function (id, x, y, radius) {
    Shape.call(this, id, x, y);
    …
};
Circle.prototype.toString = function () {
    return "Circle > " + Shape.prototype.toString.call(this);
};
```

--

## Static Members

Simple support for static class members.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
class Rectangle extends Shape {
    …
    static defaultRectangle () {
        return new Rectangle("default", 0, 0, 100, 100)
    }
}
class Circle extends Shape {
    …
    static defaultCircle () {
        return new Circle("default", 0, 0, 100)
    }
}
var defRectangle = Rectangle.defaultRectangle()
var defCircle    = Circle.defaultCircle()
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var Rectangle = function (id, x, y, width, height) {
    …
};
Rectangle.defaultRectangle = function () {
    return new Rectangle("default", 0, 0, 100, 100);
};
var Circle = function (id, x, y, width, height) {
    …
};
Circle.defaultCircle = function () {
    return new Circle("default", 0, 0, 100);
};
var defRectangle = Rectangle.defaultRectangle();
var defCircle    = Circle.defaultCircle();
```

--

## Getter/Setter

Getter/Setter also directly within classes (and not just within object initializers, as it is possible since ECMAScript 5.1).

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
class Rectangle {
    constructor (width, height) {
        this._width  = width
        this._height = height
    }
    set width  (width)  { this._width = width               }
    get width  ()       { return this._width                }
    set height (height) { this._height = height             }
    get height ()       { return this._height               }
    get area   ()       { return this._width * this._height }
}
var r = new Rectangle(50, 20)
r.area === 1000
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var Rectangle = function (width, height) {
    this._width  = width;
    this._height = height;
};
Rectangle.prototype = {
    set width  (width)  { this._width = width;               },
    get width  ()       { return this._width;                },
    set height (height) { this._height = height;             },
    get height ()       { return this._height;               },
    get area   ()       { return this._width * this._height; }
};
var r = new Rectangle(50, 20);
r.area === 1000;
```

---

# Symbol Type

--

## Symbol Type

Unique and immutable data type to be used as an identifier for object properties. Symbol can have an optional description, but for debugging purposes only.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
Symbol("foo") !== Symbol("foo")
const foo = Symbol()
const bar = Symbol()
typeof foo === "symbol"
typeof bar === "symbol"
let obj = {}
obj[foo] = "foo"
obj[bar] = "bar"
JSON.stringify(obj) // {}
Object.keys(obj) // []
Object.getOwnPropertyNames(obj) // []
Object.getOwnPropertySymbols(obj) // [ foo, bar ]
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

--

## Global Symbols

Global symbols, indexed through unique keys.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
Symbol.for("app.foo") === Symbol.for("app.foo")
const foo = Symbol.for("app.foo")
const bar = Symbol.for("app.bar")
Symbol.keyFor(foo) === "app.foo"
Symbol.keyFor(bar) === "app.bar"
typeof foo === "symbol"
typeof bar === "symbol"
let obj = {}
obj[foo] = "foo"
obj[bar] = "bar"
JSON.stringify(obj) // {}
Object.keys(obj) // []
Object.getOwnPropertyNames(obj) // []
Object.getOwnPropertySymbols(obj) // [ foo, bar ]
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

---

# Iterators

--

## Iterator & For-Of Operator

Support "iterable" protocol to allow objects to customize their iteration behaviour. Additionally, support "iterator" protocol to produce sequence of values (either finite or infinite). Finally, provide convenient of operator to iterate over all values of an iterable object.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let fibonacci = {
    [Symbol.iterator]() {
        let pre = 0, cur = 1
        return {
           next () {
               [ pre, cur ] = [ cur, pre + cur ]
               return { done: false, value: cur }
           }
        }
    }
}

for (let n of fibonacci) {
    if (n > 1000)
        break
    console.log(n)
}
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var fibonacci = {
    next: (function () {
        var pre = 0, cur = 1;
        return function () {
            tmp = pre;
            pre = cur;
            cur += tmp;
            return cur;
        };
    })()
};

var n;
for (;;) {
    n = fibonacci.next();
    if (n > 1000)
        break;
    console.log(n);
}
```

---

# Generators

--

## Generator Function, Iterator Protocol

Support for generators, a special case of Iterators containing a generator function, where the control flow can be paused and resumed, in order to produce sequence of values (either finite or infinite).

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let fibonacci = {
    *[Symbol.iterator]() {
        let pre = 0, cur = 1
        for (;;) {
            [ pre, cur ] = [ cur, pre + cur ]
            yield cur
        }
    }
}

for (let n of fibonacci) {
    if (n > 1000)
        break
    console.log(n)
}
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var fibonacci = {
    next: (function () {
        var pre = 0, cur = 1;
        return function () {
            tmp = pre;
            pre = cur;
            cur += tmp;
            return cur;
        };
    })()
};

var n;
for (;;) {
    n = fibonacci.next();
    if (n > 1000)
        break;
    console.log(n);
}
```

--

## Generator Function, Direct Use

Support for generator functions, a special variant of functions where the control flow can be paused and resumed, in order to produce sequence of values (either finite or infinite).

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function* range (start, end, step) {
    while (start < end) {
        yield start
        start += step
    }
}

for (let i of range(0, 10, 2)) {
    console.log(i) // 0, 2, 4, 6, 8
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function range (start, end, step) {
    var list = [];
    while (start < end) {
        list.push(start);
        start += step;
    }
    return list;
}

var r = range(0, 10, 2);
for (var i = 0; i < r.length; i++) {
    console.log(r[i]); // 0, 2, 4, 6, 8
}
```

--

## Generator Matching

Support for generator functions, i.e., functions where the control flow can be paused and resumed, in order to produce and spread sequence of values (either finite or infinite).

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let fibonacci = function* (numbers) {
    let pre = 0, cur = 1
    while (numbers-- > 0) {
        [ pre, cur ] = [ cur, pre + cur ]
        yield cur
    }
}

for (let n of fibonacci(1000))
    console.log(n)

let numbers = [ ...fibonacci(1000) ]

let [ n1, n2, n3, ...others ] = fibonacci(1000)
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  no equivalent in ES5
```

--

## Generator Control-Flow

Support for generators, a special case of Iterators where the control flow can be paused and resumed, in order to support asynchronous programming in the style of "co-routines" in combination with Promises (see below). [Notice: the generic async function usually is provided by a reusable library and given here just for better understanding. See co or Bluebird's coroutine in practice.]

--

ECMAScript 6 <!-- .element: class="filename small-table-font" -->
```javascript
//  generic asynchronous control-flow driver
function async (proc, ...params) {
    var iterator = proc(...params)
    return new Promise((resolve, reject) => {
        let loop = (value) => {
            let result
            try {
                result = iterator.next(value)
            }
            catch (err) {
                reject(err)
            }
            if (result.done)
                resolve(result.value)
            else if (   typeof result.value      === "object"
                     && typeof result.value.then === "function")
                result.value.then((value) => {
                    loop(value)
                }, (err) => {
                    reject(err)
                })
            else
                loop(result.value)
        }
        loop()
    })
}

//  application-specific asynchronous builder
function makeAsync (text, after) {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(text), after)
    })
}

//  application-specific asynchronous procedure
async(function* (greeting) {
    let foo = yield makeAsync("foo", 300)
    let bar = yield makeAsync("bar", 200)
    let baz = yield makeAsync("baz", 100)
    return `${greeting} ${foo} ${bar} ${baz}`
}, "Hello").then((msg) => {
    console.log("RESULT:", msg) // "Hello foo bar baz"
})
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  no equivalent in ES5
```

--

## Generator Methods

Support for generator methods, i.e., methods in classes and on objects, based on generator functions.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
class Clz {
    * bar () {
        …
    }
}
let Obj = {
    * foo () {
        …
    }
}
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  no equivalent in ES5
```

---

# Map/Set & WeakMap/WeakSet

--

## Set Data-Structure

Cleaner data-structure for common algorithms based on sets.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let s = new Set()
s.add("hello").add("goodbye").add("hello")
s.size === 2
s.has("hello") === true
for (let key of s.values()) // insertion order
    console.log(key)
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var s = {};
s["hello"] = true; s["goodbye"] = true; s["hello"] = true;
Object.keys(s).length === 2;
s["hello"] === true;
for (var key in s) // arbitrary order
    if (s.hasOwnProperty(key))
        console.log(s[key]);
```

--

## Map Data-Structure

Cleaner data-structure for common algorithms based on maps.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let m = new Map()
let s = Symbol()
m.set("hello", 42)
m.set(s, 34)
m.get(s) === 34
m.size === 2
for (let [ key, val ] of m.entries())
    console.log(key + " = " + val)
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var m = {};
// no equivalent in ES5
m["hello"] = 42;
// no equivalent in ES5
// no equivalent in ES5
Object.keys(m).length === 2;
for (key in m) {
    if (m.hasOwnProperty(key)) {
        var val = m[key];
        console.log(key + " = " + val);
    }
}
```

--

## Weak-Link Data-Structures

Memory-leak-free Object-key’d side-by-side data-structures.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let isMarked     = new WeakSet()
let attachedData = new WeakMap()

export class Node {
    constructor (id)   { this.id = id                  }
    mark        ()     { isMarked.add(this)            }
    unmark      ()     { isMarked.delete(this)         }
    marked      ()     { return isMarked.has(this)     }
    set data    (data) { attachedData.set(this, data)  }
    get data    ()     { return attachedData.get(this) }
}

let foo = new Node("foo")
JSON.stringify(foo) === '{"id":"foo"}'
foo.mark()
foo.data = "bar"
foo.data === "bar"
JSON.stringify(foo) === '{"id":"foo"}'

isMarked.has(foo)     === true
attachedData.has(foo) === true
foo = null  /* remove only reference to foo */
attachedData.has(foo) === false
isMarked.has(foo)     === false
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

---

# Typed Arrays

--

## Typed Arrays

Support for arbitrary byte-based data structures to implement network protocols, cryptography algorithms, file format manipulations, etc.

--

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
//  ES6 class equivalent to the following C structure:
//  struct Example { unsigned long id; char username[16]; float amountDue }
class Example {
    constructor (buffer = new ArrayBuffer(24)) {
        this._buffer = buffer
    }
    set buffer (buffer) {
        this._buffer    = buffer
        this._id        = new Uint32Array (this._buffer,  0,  1)
        this._username  = new Uint8Array  (this._buffer,  4, 16)
        this._amountDue = new Float32Array(this._buffer, 20,  1)
    }
    get buffer ()     { return this._buffer       }
    set id (v)        { this._id[0] = v           }
    get id ()         { return this._id[0]        }
    set username (v)  { this._username[0] = v     }
    get username ()   { return this._username[0]  }
    set amountDue (v) { this._amountDue[0] = v    }
    get amountDue ()  { return this._amountDue[0] }
}

let example = new Example()
example.id = 7
example.username = "John Doe"
example.amountDue = 42.0
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
//  no equivalent in ES5
//  (only an equivalent in HTML5)
```

---

# New Built-In Methods

--

## Object Property Assignment

New function for assigning enumerable properties of one or more source objects onto a destination object.


ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var dst  = { quux: 0 }
var src1 = { foo: 1, bar: 2 }
var src2 = { foo: 3, baz: 4 }
Object.assign(dst, src1, src2)
dst.quux === 0
dst.foo  === 3
dst.bar  === 2
dst.baz  === 4
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var dst  = { quux: 0 };
var src1 = { foo: 1, bar: 2 };
var src2 = { foo: 3, baz: 4 };
Object.keys(src1).forEach(function(k) {
    dst[k] = src1[k];
});
Object.keys(src2).forEach(function(k) {
    dst[k] = src2[k];
});
dst.quux === 0;
dst.foo  === 3;
dst.bar  === 2;
dst.baz  === 4;
```

--

## Array Element Finding

New function for finding an element in an array.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
[ 1, 3, 4, 2 ].find(x => x > 3) // 4
[ 1, 3, 4, 2 ].findIndex(x => x > 3) // 2
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
[ 1, 3, 4, 2 ].filter(function (x) { return x > 3; })[0]; // 4
// no equivalent in ES5
```

--

## String Repeating

New string repeating functionality.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
" ".repeat(4 * depth)
"foo".repeat(3)
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
Array((4 * depth) + 1).join(" ");
Array(3 + 1).join("foo");
```

--

## String Searching

New specific string functions to search for a sub-string.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
"hello".startsWith("ello", 1) // true
"hello".endsWith("hell", 4)   // true
"hello".includes("ell")       // true
"hello".includes("ell", 1)    // true
"hello".includes("ell", 2)    // false
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
"hello".indexOf("ello") === 1;    // true
"hello".indexOf("hell") === (4 - "hell".length); // true
"hello".indexOf("ell") !== -1;    // true
"hello".indexOf("ell", 1) !== -1; // true
"hello".indexOf("ell", 2) !== -1; // false
```

--

## Number Type Checking

New functions for checking for non-numbers and finite numbers.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
Number.isNaN(42) === false
Number.isNaN(NaN) === true

Number.isFinite(Infinity) === false
Number.isFinite(-Infinity) === false
Number.isFinite(NaN) === false
Number.isFinite(123) === true
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var isNaN = function (n) {
    return n !== n;
};
var isFinite = function (v) {
    return (typeof v === "number" && !isNaN(v) && v !== Infinity && v !== -Infinity);
};
isNaN(42) === false;
isNaN(NaN) === true;

isFinite(Infinity) === false;
isFinite(-Infinity) === false;
isFinite(NaN) === false;
isFinite(123) === true;
```

--

## Number Safety Checking

Checking whether an integer number is in the safe range, i.e., it is correctly represented by JavaScript (where all numbers, including integer numbers, are technically floating point number).

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
Number.isSafeInteger(42) === true
Number.isSafeInteger(9007199254740992) === false
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function isSafeInteger (n) {
    return (
           typeof n === 'number'
        && Math.round(n) === n
        && -(Math.pow(2, 53) - 1) <= n
        && n <= (Math.pow(2, 53) - 1)
    );
}
isSafeInteger(42) === true;
isSafeInteger(9007199254740992) === false;
```

--

## Number Comparison

Availability of a standard Epsilon value for more precise comparison of floating point numbers.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
console.log(0.1 + 0.2 === 0.3) // false
console.log(Math.abs((0.1 + 0.2) - 0.3) < Number.EPSILON) // true
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
console.log(0.1 + 0.2 === 0.3); // false
console.log(Math.abs((0.1 + 0.2) - 0.3) < 2.220446049250313e-16); // true
```

--

## Number Truncation

Truncate a floating point number to its integral part, completely dropping the fractional part.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
console.log(Math.trunc(42.7)) // 42
console.log(Math.trunc( 0.1)) // 0
console.log(Math.trunc(-0.1)) // -0
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function mathTrunc (x) {
    return (x < 0 ? Math.ceil(x) : Math.floor(x));
}
console.log(mathTrunc(42.7)) // 42
console.log(mathTrunc( 0.1)) // 0
console.log(mathTrunc(-0.1)) // -0
```

--

## Number Sign Determination

Determine the sign of a number, including special cases of signed zero and non-number.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
console.log(Math.sign(7))   // 1
console.log(Math.sign(0))   // 0
console.log(Math.sign(-0))  // -0
console.log(Math.sign(-7))  // -1
console.log(Math.sign(NaN)) // NaN
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function mathSign (x) {
    return ((x === 0 || isNaN(x)) ? x : (x > 0 ? 1 : -1));
}
console.log(mathSign(7))   // 1
console.log(mathSign(0))   // 0
console.log(mathSign(-0))  // -0
console.log(mathSign(-7))  // -1
console.log(mathSign(NaN)) // NaN
```

---

# Promises

--

## Promise Usage

First class representation of a value that may be made asynchronously and be available in the future.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function msgAfterTimeout (msg, who, timeout) {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(`${msg} Hello ${who}!`), timeout)
    })
}
msgAfterTimeout("", "Foo", 100).then((msg) =>
    msgAfterTimeout(msg, "Bar", 200)
).then((msg) => {
    console.log(`done after 300ms:${msg}`)
})
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function msgAfterTimeout (msg, who, timeout, onDone) {
    setTimeout(function () {
        onDone(msg + " Hello " + who + "!");
    }, timeout);
}
msgAfterTimeout("", "Foo", 100, function (msg) {
    msgAfterTimeout(msg, "Bar", 200, function (msg) {
        console.log("done after 300ms:" + msg);
    });
});
```

--

## Promise Combination

Combine one or more promises into new promises without having to take care of ordering of the underlying asynchronous operations yourself.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
function fetchAsync (url, timeout, onData, onError) {
    …
}
let fetchPromised = (url, timeout) => {
    return new Promise((resolve, reject) => {
        fetchAsync(url, timeout, resolve, reject)
    })
}
Promise.all([
    fetchPromised("http://backend/foo.txt", 500),
    fetchPromised("http://backend/bar.txt", 500),
    fetchPromised("http://backend/baz.txt", 500)
]).then((data) => {
    let [ foo, bar, baz ] = data
    console.log(`success: foo=${foo} bar=${bar} baz=${baz}`)
}, (err) => {
    console.log(`error: ${err}`)
})
```

--

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
function fetchAsync (url, timeout, onData, onError) {
    …
}
function fetchAll (request, onData, onError) {
    var result = [], results = 0;
    for (var i = 0; i < request.length; i++) {
        result[i] = null;
        (function (i) {
            fetchAsync(request[i].url, request[i].timeout, function (data) {
                result[i] = data;
                if (++results === request.length)
                    onData(result);
            }, onError);
        })(i);
    }
}
fetchAll([
    { url: "http://backend/foo.txt", timeout: 500 },
    { url: "http://backend/bar.txt", timeout: 500 },
    { url: "http://backend/baz.txt", timeout: 500 }
], function (data) {
    var foo = data[0], bar = data[1], baz = data[2];
    console.log("success: foo=" + foo + " bar=" + bar + " baz=" + baz);
}, function (err) {
    console.log("error: " + err);
});
```

---

# Meta-Programming

--

## Proxying

Hooking into runtime-level object meta-operations.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let target = {
    foo: "Welcome, foo"
}
let proxy = new Proxy(target, {
    get (receiver, name) {
        return name in receiver ? receiver[name] : `Hello, ${name}`
    }
})
proxy.foo   === "Welcome, foo"
proxy.world === "Hello, world"
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

--

## Reflection

Make calls corresponding to the object meta-operations.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
let obj = { a: 1 }
Object.defineProperty(obj, "b", { value: 2 })
obj[Symbol("c")] = 3
Reflect.ownKeys(obj) // [ "a", "b", Symbol(c) ]
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
var obj = { a: 1 };
Object.defineProperty(obj, "b", { value: 2 });
// no equivalent in ES5
Object.getOwnPropertyNames(obj); // [ "a", "b" ]
```

---

# Internationalization & Localization

--

## Collation

Sorting a set of strings and searching within a set of strings. Collation is parameterized by locale and aware of Unicode.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
// in German,  "ä" sorts with "a"
// in Swedish, "ä" sorts after "z"
var list = [ "ä", "a", "z" ]
var l10nDE = new Intl.Collator("de")
var l10nSV = new Intl.Collator("sv")
l10nDE.compare("ä", "z") === -1
l10nSV.compare("ä", "z") === +1
console.log(list.sort(l10nDE.compare)) // [ "a", "ä", "z" ]
console.log(list.sort(l10nSV.compare)) // [ "a", "z", "ä" ]
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

--

## Number Formatting

Format numbers with digit grouping and localized separators.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var l10nEN = new Intl.NumberFormat("en-US")
var l10nDE = new Intl.NumberFormat("de-DE")
l10nEN.format(1234567.89) === "1,234,567.89"
l10nDE.format(1234567.89) === "1.234.567,89"
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

--

## Currency Formatting

Format numbers with digit grouping, localized separators and attached currency symbol.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var l10nUSD = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })
var l10nGBP = new Intl.NumberFormat("en-GB", { style: "currency", currency: "GBP" })
var l10nEUR = new Intl.NumberFormat("de-DE", { style: "currency", currency: "EUR" })
l10nUSD.format(100200300.40) === "$100,200,300.40"
l10nGBP.format(100200300.40) === "£100,200,300.40"
l10nEUR.format(100200300.40) === "100.200.300,40 €"
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

--

## Date/Time Formatting

Format date/time with localized ordering and separators.

ECMAScript 6 <!-- .element: class="filename" -->
```javascript
var l10nEN = new Intl.DateTimeFormat("en-US")
var l10nDE = new Intl.DateTimeFormat("de-DE")
l10nEN.format(new Date("2015-01-02")) === "1/2/2015"
l10nDE.format(new Date("2015-01-02")) === "2.1.2015"
```

ECMAScript 5 <!-- .element: class="filename" -->
```javascript
// no equivalent in ES5
```

---

# The End
