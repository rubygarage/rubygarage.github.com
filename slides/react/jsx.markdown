---
layout: slide
title:  JSX
---

# What's JSX?

JSX is a preprocessor step that adds XML syntax to JavaScript. You can definitely use React without JSX but JSX makes React a lot more elegant.

```js
// This funny tag syntax is neither a string nor HTML
const element = <h1>Hello, world!</h1>
```

--

## Why `className`?

Since JSX is closer to JavaScript than HTML, React DOM uses camelCase property naming convention instead of HTML attribute names.
For example, class becomes className in JSX, and tabindex becomes tabIndex.

---

# Embedding Expressions

--

## You can embed any JavaScript expression in JSX by wrapping it in curly braces.

```js
function formatName(user) {
  return `${user.firstName} ${user.lastName}`
}

const user = {
  firstName: 'Harper',
  lastName: 'Perez'
}

const element = (
  <h1>
    Hello, {formatName(user)}!
  </h1>
)

ReactDOM.render(
  element,
  document.getElementById('root')
)
```

---

# JSX is an Expression

> After compilation, JSX expressions become regular JavaScript objects.

--

## Conditional Rendering using JSX

```js
function getGreeting(user) {
  if (user) {
    return <h1>Hello, {formatName(user)}!</h1>
  }

  return <h1>Hello, Stranger.</h1>
}
```

--

## Inline If with Logical && Operator

```js
function getGreeting(user) {
  return (
    <div>
      {user && <h1>Hello, {formatName(user)}!</h1>}
    </div>
  )
}
```

--

## Inline Unless with Logical || Operator

```js
function getGreeting(user) {
  return (
    <div>
      {user || <h1>Hello, Stranger.</h1>}
    </div>
  )
}
```

--

## Inline If-Else with Ternary Operator

```js
function getGreeting(user) {
  return (
    <div>
      {user ? (
        <h1>Hello, {formatName(user)}!</h1>
      ) : (
        <h1>Hello, Stranger.</h1>
      )}
    </div>
  )
}
```

---

# Specifying Attributes

--

## Examples

```js
// You may use quotes to specify string literals as attributes:
const element = <div tabIndex="0"></div>

// You may also use curly braces to embed a JavaScript expression in an attribute:
const element = <img src={user.avatarUrl}></img>
```

---

# JSX Prevents Injection Attacks

--

## It is safe to embed user input in JSX

```js
const title = response.potentiallyMaliciousInput
// This is safe:
const element = <h1>{title}</h1>
```

---

# JSX Represents Objects

--

## Babel compiles JSX down to React.createElement() calls

```js
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
)
```

```js
const element = React.createElement(
  'h1',
  {className: 'greeting'},
  'Hello, world!'
)
```

---

# React Element Type

Capitalized types indicate that the JSX tag is referring to a React component. These tags get compiled into a direct reference to the named variable, so if you use the JSX `<Foo />` expression, `Foo` must be in scope.

--

## React Must Be in Scope

> Since JSX compiles into calls to `React.createElement`, the `React` library must also always be in scope from your JSX code.

```js
import React from 'react'
import CustomButton from './CustomButton'

function WarningButton() {
  // return React.createElement(CustomButton, {color: 'red'}, null)
  return <CustomButton color="red" />
}
```

--

## Using Dot Notation for JSX Type

> You can refer to a React component using dot-notation from within JSX:

```js
import React from 'react'

const MyComponents = {
  DatePicker: function DatePicker(props) {
    return <div>Imagine a {props.color} datepicker here.</div>
  }
}

function BlueDatePicker() {
  return <MyComponents.DatePicker color="blue" />
}
```

--

## User-Defined Components Must Be Capitalized

```js
import React from 'react'

// Wrong! This is a component and should have been capitalized:
function hello(props) {
  // Correct! This use of <div> is legitimate because div is a valid HTML tag:
  return <div>Hello {props.toWhat}</div>
}

function HelloWorld() {
  // Wrong! React thinks <hello /> is an HTML tag because it's not capitalized:
  return <hello toWhat="World" />
}
```

```js
import React from 'react'

// Correct! This is a component and should be capitalized:
function Hello(props) {
  // Correct! This use of <div> is legitimate because div is a valid HTML tag:
  return <div>Hello {props.toWhat}</div>
}

function HelloWorld() {
  // Correct! React knows <Hello /> is a component because it's capitalized.
  return <Hello toWhat="World" />
}
```

--

## If a tag is empty, you may close it immediately with `/>`, like XML

```js
const element = <img src={user.avatarUrl} />
```

--

## Choosing the Type at Runtime

```js
import React from 'react'
import { PhotoStory, VideoStory } from './stories'

const components = {
  photo: PhotoStory,
  video: VideoStory
}

function Story(props) {
  // Wrong! JSX type can't be an expression.
  return <components[props.storyType] story={props.story} />
}
```

```js
import React from 'react'
import { PhotoStory, VideoStory } from './stories'

const components = {
  photo: PhotoStory,
  video: VideoStory
}

function Story(props) {
  // Correct! JSX type can be a capitalized variable.
  const SpecificStory = components[props.storyType]

  return <SpecificStory story={props.story} />
}
```

---

# Props in JSX

--

## JavaScript Expressions as Props

> You can pass any JavaScript expression as a prop, by surrounding it with `{}`. For example, in this JSX:

```js
<MyComponent foo={1 + 2 + 3 + 4} />
```

> `if` statements and `for` loops are not expressions in JavaScript, so they can't be used in JSX directly. Instead, you can put these in the surrounding code

```js
function NumberDescriber(props) {
  let description
  if (props.number % 2 == 0) {
    description = <strong>even</strong>
  } else {
    description = <i>odd</i>
  }

  return <div>{props.number} is an {description} number</div>
}
```

--

## String Literals

> You can pass a string literal as a prop. These two JSX expressions are equivalent

```js
<MyComponent message="hello world" />

<MyComponent message={'hello world'} />
```

> When you pass a string literal, its value is HTML-unescaped. So these two JSX expressions are equivalent

```js
<MyComponent message="&lt;3" />

<MyComponent message={'<3'} />
```

--

## Spread Attributes

> If you already have `props` as an object, and you want to pass it in JSX, you can use `...` as a "spread" operator to pass the whole props object. These two components are equivalent

```js
function App1() {
  return <Greeting firstName="Ben" lastName="Hector" />
}

function App2() {
  const props = {firstName: 'Ben', lastName: 'Hector'}

  return <Greeting {...props} />
}
```

---

# Children in JSX

--

## JSX tags may contain children

```js
const element = (
  <div>
    <h1>Hello!</h1>
    <h2>Good to see you here.</h2>
  </div>
)
```

```js
<MyComponent>Hello world!</MyComponent>
```

```js
<div>This is valid HTML &amp; JSX at the same time.</div>
```

--

## JSX Children

> You can provide more JSX elements as the children. This is useful for displaying nested components

```js
<MyContainer>
  <MyFirstComponent />
  <MySecondComponent />
</MyContainer>
```

> You can mix together different types of children, so you can use string literals together with JSX children. This is another way in which JSX is like HTML, so that this is both valid JSX and valid HTML

```js
<MyContainer>
  Here is a list:
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
  </ul>
</MyContainer>
```

--

## JavaScript Expressions as Children

```js
function Item(props) {
  return <li>{props.message}</li>
}

function TodoList() {
  const todos = [
    { id: 1, message: 'finish doc' },
    { id: 2, message: 'submit pr' },
    { id: 3, message: 'nag dan to review' }
  ]

  return (
    <ul>
      // Index as a key is an anti-pattern
      {todos.map((todo) => <Item key={todo.id} message={todo.message} />)}
    </ul>
  )
}
```

--

## Functions as Children

```js
// Calls the children callback numTimes to produce a repeated component
function Repeat(props) {
  let items = []
  for (let i = 0; i < props.numTimes; i++) {
    items.push(props.children(i))
  }

  return <div>{items}</div>
}

function ListOfTenThings() {
  return (
    <Repeat numTimes={10}>
      {(index) => <div key={index}>This is item {index} in the list</div>}
    </Repeat>
  )
}
```

--

## Booleans, Null, and Undefined Are Ignored

> `false`, `null`, `undefined`, and `true` are valid children. They simply don't render. These JSX expressions will all render to the same thing:

```js
<div />

<div></div>

<div>{false}</div>

<div>{null}</div>

<div>{undefined}</div>

<div>{true}</div>
```

---

# The End
