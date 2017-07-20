---
layout: slide
title: State and Lifecycle
---

# React State

--

## What is State?

> The heart of every React component is its “state”, an object that determines how that component renders and behaves.
> `State` is what allows you to create components that are dynamic and interactive.

--

## Accessing States

> The state object is an attribute of a component and can be accessed with this reference, e.g., `this.state.name`

---

# Setting the Initial State

--

## Initialize state in constructor

> If you create a `constructor()` method, you almost always need to invoke `super()` inside of it, otherwise the parent’s constructor won’t be executed.

```js
class MyFancyComponent extends Component {
  constructor(props) {
    super(props)

    this.state = { currentTime: (new Date()).toLocaleString() }
  }

  render() {
    return <div>{this.state.currentTime}</div>
  }
}
```

--

## Initial state as a Class Attribute

> Available with Babel transpiler, which means no browser will run this feature natively

```js
class MyFancyComponent extends Component {
  state = {
    currentTime: (new Date()).toLocaleString()
  }

  render() {
    return <div>{this.state.currentTime}</div>
  }
}
```

---

# Updating States

--

## `this.setState(data, callback)`

> This method performs a shallow merge of `data` into `this.state` and re-renders the component.
> The optional `callback ` —  if provided  —  will be called after the component finishes re-rendering

--

## `setState()` is asynchronous

> Basically when you invoke `setState()` React schedules an update, computations are delayed until necessary.

--

## Counter example

```js
class Counter extends Component {
  state = {
    counter: 0
  }

  onClick = () => {
    this.setState({ counter: this.state.counter + 1 })
  }

  render() {
    const { counter } = this.state

    return (
      <div>
        Button was clicked:
        <div>{counter} times</div>

        <button onClick={this.onClick}>Click Me</button>
      </div>
    )
  }
}
```

---

# The Component Lifecycle

--

## Each component has several "lifecycle methods"

You can override them to run code at particular times in the process. Methods prefixed with will are called right before something happens, and methods prefixed with did are called right after something happens.

---

# Mounting

> These methods are called when an instance of a component is being created and inserted into the DOM

--

## `constructor(props)`

The `constructor` for a React component is called before it is mounted. When implementing the constructor for a React.Component subclass, you should call `super(props)` before any other statement. Otherwise, `this.props` will be undefined in the constructor, which can lead to bugs.

```js
class Clock extends Component {
  constructor(props) {
    super(props)

    this.state = { date: new Date() }
  }

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    )
  }
}
```

--

## `componentWillMount()`

`componentWillMount()` is invoked immediately before mounting occurs. It is called before `render()`, therefore setting state synchronously in this method will not trigger a re-rendering. Avoid introducing any side-effects or subscriptions in this method.


```js
class Scorecard extends Component {
  componentWillMount() {
    // Calling setState will usually trigger a re-render,
    // but calling it in componentWillMount won't
    // (since it hasn't rendered in the first place).

    this.setState({ score: 0 })
  }

  render() {
    const { playerName} = this.props
    // `this.state` defaults to null, but since it'll be set in
    // `componentWillMount`, it can safely be destructured.

    const { score } = this.state
    const message = `Current Score: ${score}`

    return (
      <div>
        <h1>{playerName}</h1>
        <div>{message}</div>
      </div>
    )
  }
}
```

--

## `componentDidMount()`

`componentDidMount()` is invoked immediately after a component is mounted. Initialization that requires DOM nodes should go here. If you need to load data from a remote endpoint, this is a good place to instantiate the network request. Setting state in this method will trigger a re-rendering.

```js
class Scorecard extends Component {
  componentDidMount() {
    // You'd probably want to send an AJAX call or something,
    // but let's say they get 1000 points after the first second.

    setTimeout(() => this.setState({ score: 1000 }), 1000)
  }
}
```

---

# Updating

--

## `componentWillReceiveProps(nextProps)`

`componentWillReceiveProps()` is invoked before a mounted component receives new props. If you need to update the state in response to prop changes (for example, to reset it), you may compare `this.props` and `nextProps` and perform state transitions using `this.setState()` in this method.

```js
class Scorecard extends Component {
  componentWillReceiveProps(nextProps) {

    // `nextProps` is the new props, while `this.props` are the old ones
    const { playerName } = this.props

    // It is entirely possible that the new `playerName` is the same as the old one.
    if (nextProps.playerName !== playerName) {

      // Changing your name resets the score to zero.
      this.setState({ score: 0 })
    }
  }
}
```

--

## `shouldComponentUpdate(nextProps, nextState)`

Use `shouldComponentUpdate()` to let React know if a component's output is not affected by the current change in state or props. The default behavior is to re-render on every state change, and in the vast majority of cases you should rely on the default behavior.

```js
class Scorecard extends Component {
  shouldComponentUpdate(nextProps, nextState) {

    // Same as `componentWillReceiveProps`, `nextProps` is the
    // new props and `this.props` is the old.
    const { playerName } = this.props

    // Same for `nextState` and `this.state`.
    const { score } = this.state

    // Only `playerName` and `score` affect the display.
    // If something else changes, re-rendering would be a waste.
    return !(nextProps.playerName === playerName && nextState.score === score)
  }
}
```

--

## `componentWillUpdate(nextProps, nextState)`

`componentWillUpdate()` is invoked immediately before rendering when new props or state are being received. Use this as an opportunity to perform preparation before an update occurs. This method is not called for the initial render.

```js
class Scorecard extends Component {
  componentWillUpdate(nextProps, nextState) {
    const { playerName } = this.props

    // If `playerName` changes, log a message.
    if (nextProps.playerName !== playerName) {

      // Note that even though `componentWillReceiveProps` called `setState`, `this.state` is still the original value.
      const { score } = this.state
      console.log(`${playerName} is now ${nextProps.playerName}.  His score of ${score} is forfeit.`);
    }
  }
}
```

--

## `componentDidUpdate(prevProps, prevState)`

`componentDidUpdate()` is invoked immediately after updating occurs. This method is not called for the initial render.

```js
class Scorecard extends Component {
  componentDidUpdate(prevProps, prevState) {
    const { playerName } = this.props

    // `prevProps` are the props as they used to be and `this.props` are what they are now.
    // Same for `prevState` and `this.state`.
    if (prevProps.playerName !== playerName) {
      const { score } = prevState
      console.log(`${playerName} used to be ${prevProps.playerName}. His former score was ${score}.`)
    }
  }
}
```

---

# Unmounting

--

## `componentWillUnmount()`

`componentWillUnmount()` is invoked immediately before a component is unmounted and destroyed. Perform any necessary cleanup in this method, such as invalidating timers, canceling network requests, or cleaning up any DOM elements that were created in `componentDidMount`.

```js
class Scorecard extends Component {
  componentWillUnmount() {
    console.log('Sayonara!')
  }
}
```

---

![](/assets/images/react/react-lifecycle.svg)

---

# The End
