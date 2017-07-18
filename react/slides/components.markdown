---
layout: slide
title: Components and Props
---

# Components and Props

> Components let you split the UI into independent, reusable pieces, and think about each piece in isolation. Conceptually, components are like JavaScript functions.

---

# Functional and Class Components

--

The simplest way to define a component is to write a JavaScript function:

```js
import React from 'react'

function Welcome(props) {
  return <h1>Hello, {props.name}</h1>
}
```

--

Using ES6 class to define a component:

```js
import React, { Component } from 'react'

class Welcome extends Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>
  }
}
```

---

# Rendering a Component

--

When React sees an element representing a user-defined component, it passes JSX attributes to this component as a single object.
We call this object "props".

Always start component names with a capital letter.

```js
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>
}

const element = <Welcome name="Sara" />

ReactDOM.render(
  element,
  document.getElementById('root')
)
```

---

# Composing Components

--

Components can refer to other components in their output and must return a single root element.

```js
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>
}

function App() {
  return (
    <div>
      <Welcome name="Sara" />
      <Welcome name="Cahal" />
      <Welcome name="Edite" />
    </div>
  )
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
)
```

---

# Extracting Components

--

You can split components into smaller parts.

```js
function Comment(props) {
  return (
    <div className="Comment">
      <div className="UserInfo">
        <img className="Avatar"
          src={props.author.avatarUrl}
          alt={props.author.name}
        />

        <div className="UserInfo-name">
          {props.author.name}
        </div>
      </div>

      <div className="Comment-text">
        {props.text}
      </div>

      <div className="Comment-date">
        {formatDate(props.date)}
      </div>
    </div>
  )
}
```

--

Extract `Avatar` component

```js
function Avatar(props) {
  return (
    <img className="Avatar"
      src={props.user.avatarUrl}
      alt={props.user.name}
    />
  )
}
```

--

Extract a `UserInfo` component that renders an `Avatar` next to user's name

```js
function UserInfo(props) {
  return (
    <div className="UserInfo">
      <Avatar user={props.user} />

      <div className="UserInfo-name">
        {props.user.name}
      </div>
    </div>
  )
}
```

--

Simplified `Comment` component

```js
function Comment(props) {
  return (
    <div className="Comment">
      <UserInfo user={props.author} />

      <div className="Comment-text">
        {props.text}
      </div>

      <div className="Comment-date">
        {formatDate(props.date)}
      </div>
    </div>
  )
}
```

---

# Typechecking With PropTypes

--

As your app grows, you can catch a lot of bugs with typechecking.
React has some built-in typechecking abilities.
When an invalid value is provided for a prop, a warning will be shown in the JavaScript console. For performance reasons, propTypes is only checked in development mode.

```js
import React from 'react'
import PropTypes from 'prop-types'

function Greeting({ name }) {
  return (
    <h1>Hello, {this.props.name}</h1>
  )
}

Greeting.propTypes = {
  name: PropTypes.string
}
```
<!-- .element: class="left width-50" -->

```js
import React, { Component } from 'react'
import PropTypes from 'prop-types'

class Greeting extends Component {
  static propTypes = {
    name: PropTypes.string
  }

  render() {
    return (
      <h1>Hello, {this.props.name}</h1>
    )
  }
}
```
<!-- .element: class="right width-50" -->

--

You can declare that a prop is a specific JS primitive.

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalArray: PropTypes.array,
  optionalBool: PropTypes.bool,
  optionalFunc: PropTypes.func,
  optionalNumber: PropTypes.number,
  optionalObject: PropTypes.object,
  optionalString: PropTypes.string,
  optionalSymbol: PropTypes.symbol
}
```

--

Anything that can be rendered: numbers, strings, elements or an array (or fragment) containing these types.

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalNode: PropTypes.node
}
```

A React element.

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalElement: PropTypes.element
}
```

Prop is an instance of a class

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalMessage: PropTypes.instanceOf(Message)
}
```

Prop is limited to specific values

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalEnum: PropTypes.oneOf(['News', 'Photos'])
}
```

--

An object that could be one of many types

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalUnion: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number,
    PropTypes.instanceOf(Message)
  ])
}
```

An array of a certain type

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalArrayOf: PropTypes.arrayOf(PropTypes.number)
}
```

An object with property values of a certain type

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalObjectOf: PropTypes.objectOf(PropTypes.number)
}
```

--

An object taking on a particular shape

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  optionalObjectWithShape: PropTypes.shape({
    color: PropTypes.string,
    fontSize: PropTypes.number
  })
}
```

You can chain any of the above with `isRequired` to make sure a warning is shown if the prop isn't provided

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  requiredFunc: PropTypes.func.isRequired
}
```

A value of any data type

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  requiredAny: PropTypes.any.isRequired
}
```

--

You can also specify a custom validator. It should return an Error object if the validation fails. Don't `console.warn` or throw, as this won't work inside `oneOfType`.

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  customProp: function(props, propName, componentName) {
    if (!/matchme/.test(props[propName])) {
      return new Error(
        'Invalid prop `' + propName + '` supplied to' +
        ' `' + componentName + '`. Validation failed.'
      )
    }
  }
}
```

--

You can also supply a custom validator to `arrayOf` and `objectOf`. It should return an Error object if the validation fails. The validator will be called for each key in the array or object. The first two arguments of the validator are the array or object itself, and the current item's key.

```js
import PropTypes from 'prop-types'

MyComponent.propTypes = {
  customArrayProp: PropTypes.arrayOf(function(propValue, key, componentName, location, propFullName) {
    if (!/matchme/.test(propValue[key])) {
      return new Error(
        'Invalid prop `' + propFullName + '` supplied to' +
        ' `' + componentName + '`. Validation failed.'
      )
    }
  })
}
```

--

## Requiring Single Child

With `PropTypes.element` you can specify that only a single child can be passed to a component as children.

```js
import React, { Component } from 'react'
import PropTypes from 'prop-types'

class MyComponent extends Component {
  render() {
    // This must be exactly one element or it will warn.
    const children = this.props.children

    return (
      <div>
        {children}
      </div>
    )
  }
}

MyComponent.propTypes = {
  children: PropTypes.element.isRequired
}
```

--

## Default Prop Values

You can define default values for your props by assigning to the special `defaultProps` property. The `propTypes` typechecking happens after `defaultProps` are resolved, so typechecking will also apply to the `defaultProps`.

```js
import React, { Component } from 'react'
import PropTypes from 'prop-types'

class Greeting extends Component {
  // Specifies the default values for props:
  static defaultProps = {
    name: 'Stranger'
  }

  render() {
    return (
      <h1>Hello, {this.props.name}</h1>
    )
  }
}

// Renders "Hello, Stranger":
ReactDOM.render(
  <Greeting />,
  document.getElementById('example')
)
```

---

# The End
