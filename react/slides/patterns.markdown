---
layout: slide
title:  React Patterns
---


# Stateless function

--

[Stateless functions](https://facebook.github.io/react/docs/components-and-props.html) are a brilliant way to define highly reusable components. They don't hold `state`; they're just functions.

```javascript
const Greeting = () => <div>Hi there!</div>
```

They get passed `props` and `context`.

```javascript
const Greeting = (props, context) =>
  <div style={{color: context.color}}>Hi {props.name}!</div>
```

They can define local variables, where a function block is used.

```javascript
const Greeting = (props, context) => {
  const style = {
    fontWeight: "bold",
    color: context.color,
  }

  return <div style={style}>{props.name}</div>
}
```

--

But you could get the same result by using other functions.

```javascript
const getStyle = context => ({
  fontWeight: "bold",
  color: context.color,
})

const Greeting = (props, context) =>
  <div style={getStyle(context)}>{props.name}</div>
```

They can have defined `defaultProps`, `propTypes` and `contextTypes`.

```javascript
Greeting.propTypes = {
  name: PropTypes.string.isRequired
}
Greeting.defaultProps = {
  name: "Guest"
}
Greeting.contextTypes = {
  color: PropTypes.string
}
```

---

# JSX spread attributes

--

Spread Attributes is a JSX feature. It's syntactic sugar for passing all of an object's properties as JSX attributes.

These two examples are equivalent.
```javascript
// props written as attributes
<main className="main" role="main">{children}</main>

// props "spread" from object
<main {...{className: "main", role: "main", children}} />
```

Use this to forward `props` to underlying components.

```javascript
const FancyDiv = props =>
  <div className="fancy" {...props} />
```

Now, I can expect `FancyDiv` to add the attributes it's concerned with as well as those it's not.

```javascript
<FancyDiv data-id="my-fancy-div">So Fancy</FancyDiv>

// output: <div className="fancy" data-id="my-fancy-div">So Fancy</div>
```

--

Keep in mind that order matters. If `props.className` is defined, it'll clobber the `className` defined by `FancyDiv`

```javascript
<FancyDiv className="my-fancy-div" />

// output: <div className="my-fancy-div"></div>
```

We can make `FancyDiv`s className always "win" by placing it after the spread props `({...props})`.

```javascript
// my `className` clobbers your `className`
const FancyDiv = props =>
  <div {...props} className="fancy" />
```

You should handle these types of props gracefully. In this case, I'll merge the author's `props.className` with the `className` needed to style my component.

```javascript
const FancyDiv = ({ className, ...props }) =>
  <div
    className={["fancy", className].join(' ')}
    {...props}
  />
```

---

# Destructuring arguments

--

[Destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) is an ES2015 feature. It pairs nicely with `props` in Stateless Functions.

These examples are equivalent.
```javascript
const Greeting = props => <div>Hi {props.name}!</div>

const Greeting = ({ name }) => <div>Hi {name}!</div>
```

The [rest parameter syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) (`...`) allows you to collect all the remaining properties in a new object.

```javascript
const Greeting = ({ name, ...props }) =>
  <div>Hi {name}!</div>
```

In turn, this object can use `JSX Spread Attributes` to forward `props` to the composed component.

```javascript
const Greeting = ({ name, ...props }) =>
  <div {...props}>Hi {name}!</div>
```

Avoid forwarding non-DOM `props` to composed components. Destructuring makes this very easy because you can create a new `props` object **without** component-specific `props`.

---

# Conditional rendering

--

You can't use regular if/else conditions inside a component definition. [The conditional (ternary) operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_Operator) is your friend.

`if`

```javascript
{condition && <span>Rendered when `truthy`</span> }
```

`unless`

```javascript
{condition || <span>Rendered when `falsey`</span> }
```

--

`if-else` (tidy one-liners)

```javascript
{condition
  ? <span>Rendered when `truthy`</span>
  : <span>Rendered when `falsey`</span>
}
```

`if-else` (big blocks)

```javascript
{condition ? (
  <span>
    Rendered when `truthy`
  </span>
) : (
  <span>
    Rendered when `falsey`
  </span>
)}
```

---

# Children types

--

React can render `children` of many types. In most cases it's either an `array` or a `string`.

`string`

```javascript
<div>
  Hello World!
</div>
```

`array`

```javascript
<div>
  {["Hello ", <span>World</span>, "!"]}
</div>
```

Functions may be used as children. However, it requires `coordination with the parent component` to be useful.

`function`

```javascript
<div>
  {() => { return "hello world!"}()}
</div>
```

---

# Array as children

--

Providing an array as `children` is a very common. It's how lists are drawn in React.

We use `map()` to create an array of React Elements for every value in the array.

```javascript
<ul>
  {["first", "second"].map((item) => (
    <li>{item}</li>
  ))}
</ul>
```

That's equivalent to providing a literal `array`.

```javascript
<ul>
  {[
    <li>first</li>,
    <li>second</li>,
  ]}
</ul>
```

This pattern can be combined with destructuring, JSX Spread Attributes, and other components, for some serious terseness.

```javascript
<ul>
  {arrayOfMessageObjects.map(({ id, ...message }) =>
    <Message key={id} {...message} />
  )}
</ul>
```

---

# Function as children

--

Using a function as `children` isn't inherently useful.

```javascript
<div>{() => { return "hello world!"}()}</div>
```

However, it can be used in component authoring for some serious power.
<br>
This technique is commonly referred to as `render callbacks`.

This is a powerful technique used by libraries like [ReactMotion](https://github.com/chenglou/react-motion). When applied, rendering logic can be kept in the owner component, instead of being delegated.

See `Render callbacks`, for more details.

---

# Render callback

--

Here's a component that uses a Render callback. It's not useful, but it's an easy illustration to start with.

```javascript
const Width = ({ children }) => children(500)
```

The component calls `children` as a function, with some number of arguments. Here, it's the number `500`.

To use this component, we give it a `function as children`

```javascript
<Width>
  {width => <div>window is {width}</div>}
</Width>
```

We get this output.

```javascript
<div>window is 500</div>
```

--

With this setup, we can use this `width` to make rendering decisions.

```javascript
<Width>
  {width =>
    width > 600
      ? <div>min-width requirement met!</div>
      : null
  }
</Width>
```

If we plan to use this condition a lot, we can define another components to encapsulate the reused logic.

```javascript
const MinWidth = ({ width: minWidth, children }) =>
  <Width>
    {width =>
      width > minWidth
        ? children
        : null
    }
  </Width>
```

--

Obviously a static `Width` component isn't useful but one that watches the browser window is. Here's a sample implementation.

```javascript
class WindowWidth extends React.Component {
  constructor() {
    super()
    this.state = { width: 0 }
  }

  componentDidMount() {
    this.setState(
      {width: window.innerWidth},
      window.addEventListener(
        "resize",
        ({ target }) =>
          this.setState({width: target.innerWidth})
      )
    )
  }

  render() {
    return this.props.children(this.state.width)
  }
}
```

Many developers favor `Higher Order Components` for this type of functionality. It's a matter of preference.

---

# Children pass-through

--

You might create a component designed to apply `context` and render its `children`.

```javascript
class SomeContextProvider extends React.Component {
  getChildContext() {
    return {some: "context"}
  }

  render() {
    // how best do we return `children`?
  }
}
```

You're faced with a decision. Wrap `children` in an extraneous `<div />` or return `children` directly. The first options gives you extra markup (which can break some stylesheets). The second will result in unhelpful errors.

```javascript
// option 1: extra div
return <div>{children}</div>

// option 2: unhelpful errors
return children
```

It's best to treat `children` as an opaque data type. React provides `React.Children` for dealing with `children` appropriately.

```javascript
return React.Children.only(this.props.children)
```

---

# Proxy component

--

Buttons are everywhere in web apps. And every one of them must have the `type` attribute set to "button".

```javascript
<button type="button">
```

Writing this attribute hundreds of times is error prone. We can write a higher level component to proxy `props` to a lower-level `button` component.

```javascript
const Button = props =>
  <button type="button" {...props}>
```

We can use `Button` in place of `button` and ensure that the `type` attribute is consistently applied everywhere.

```javascript
<Button />
// <button type="button"><button>

<Button className="CTA">Send Money</Button>
// <button type="button" class="CTA">Send Money</button>
```

---

# Style component

--

This is a `Proxy component` applied to the practices of style.

Say we have a button. It uses classes to be styled as a "primary" button.

```javascript
<button type="button" className="btn btn-primary">
```

We can generate this output using a couple single-purpose components.

```javascript
const PrimaryBtn = props =>
  <Btn {...props} primary />

const Btn = ({ className, primary, ...props }) =>
  <button
    type="button"
    className={classnames(
      "btn",
      primary && "btn-primary",
      className
    )}
    {...props}
  />
```

--

It can help to visualize this.

```javascript
PrimaryBtn()
  ↳ Btn({primary: true})
    ↳ Button({className: "btn btn-primary"}, type: "button"})
      ↳ '<button type="button" class="btn btn-primary"></button>'
```

Using these components, all of these result in the same output.
```javascript
<PrimaryBtn />
<Btn primary />
<button type="button" className="btn btn-primary" />
```

This can be a huge boon to style maintenance. It isolates all concerns of style to a single component.

---

# Event switch

--

When writing event handlers it's common to adopt the `handle{eventName}` naming convention.

```javascript
handleClick(e) { /* do something */ }
```

For components that handle several event types, these function names can be repetitive. The names themselves might not provide much value, as they simply proxy to other actions/functions.

```javascript
handleClick() { require("./actions/doStuff")(/* action stuff */) }
handleMouseEnter() { this.setState({ hovered: true }) }
handleMouseLeave() { this.setState({ hovered: false }) }
```

--

Consider writing a single event handler for your component and switching on `event.type`.

```javascript
handleEvent({type}) {
  switch(type) {
    case "click":
      return require("./actions/doStuff")(/* action dates */)
    case "mouseenter":
      return this.setState({ hovered: true })
    case "mouseleave":
      return this.setState({ hovered: false })
    default:
      return console.warn(`No case for event type "${type}"`)
  }
}
```

Alternatively, for simple components, you can call imported actions/functions directly from components, using arrow functions.

```javascript
<div onClick={() => someImportedAction({ action: "DO_STUFF" })}
```

Don't fret about performance optimizations until you have problems. Seriously don't.

---

# Layout component

--

Layout components result in some form of static DOM element. It might not need to update frequently, if ever.

Consider a component that renders two `children` side-by-side.

```javascript
<HorizontalSplit
  leftSide={<SomeSmartComponent />}
  rightSide={<AnotherSmartComponent />}
/>
```

We can aggressively optimize this component.

While `HorizontalSplit` will be `parent` to both components, it will never be their `owner`. We can tell it to update never, without interrupting the lifecycle of the components inside.

```javascript
class HorizontalSplit extends React.Component {
  shouldComponentUpdate() {
    return false
  }

  render() {
    <FlexContainer>
      <div>{this.props.leftSide}</div>
      <div>{this.props.rightSide}</div>
    </FlexContainer>
  }
}
```

---

# Container component

--

"A container does data fetching and then renders its corresponding sub-component. That’s it."&mdash;[Jason Bonta](https://twitter.com/jasonbonta)

Given this reusable `CommentList` component.

```javascript
const CommentList = ({ comments }) =>
  <ul>
    {comments.map(comment =>
      <li>{comment.body}-{comment.author}</li>
    )}
  </ul>
```

--

We can create a new component responsible for fetching data and rendering the stateless `CommentList` component.

```javascript
class CommentListContainer extends React.Component {
  constructor() {
    super()
    this.state = { comments: [] }
  }

  componentDidMount() {
    $.ajax({
      url: "/my-comments.json",
      dataType: 'json',
      success: comments =>
        this.setState({comments: comments});
    })
  }

  render() {
    return <CommentList comments={this.state.comments} />
  }
}
```

We can write different containers for different application contexts.

---

# Higher-order component

--

A [higher-order function](https://en.wikipedia.org/wiki/Higher-order_function) is a function that takes and/or returns a function. It's not more complicated than that. So, what's a higher-order component?

If you're already using `container components`, these are just generic containers, wrapped up in a function.

Let's start with our stateless `Greeting` component.

```javascript
const Greeting = ({ name }) => {
  if (!name) { return <div>Connecting...</div> }

  return <div>Hi {name}!</div>
}
```

--

If it gets `props.name`, it's gonna render that data. Otherwise it'll say that it's "Connecting...". Now for the the higher-order bit.

```javascript
const Connect = ComposedComponent =>
  class extends React.Component {
    constructor() {
      super()
      this.state = { name: "" }
    }

    componentDidMount() {
      // this would fetch or connect to a store
      this.setState({ name: "Michael" })
    }

    render() {
      return (
        <ComposedComponent
          {...this.props}
          name={this.state.name}
        />
      )
    }
  }
```

--

This is just a function that returns component that renders the component we passed as an argument.

Last step, we need to wrap our our `Greeting` component in `Connect`.

```javascript
const ConnectedMyComponent = Connect(Greeting)
```

This is a powerful pattern for providing fetching and providing data to any number of `stateless function components`.

---

# State hoisting

--

`Stateless functions` don't hold state (as the name implies).

Events are changes in state.
Their data needs to be passed to stateful `container components` parents.

This is called "state hoisting".
It's accomplished by passing a callback from a container component to a child component.

```javascript
class NameContainer extends React.Component {
  render() {
    return <Name onChange={newName => alert(newName)} />
  }
}

const Name = ({ onChange }) =>
  <input onChange={e => onChange(e.target.value)} />
```

--

`Name` receives an `onChange` callback from `NameContainer` and calls on events.

The `alert` above makes for a terse demo but it's not changing state.
Let's change the internal state of `NameContainer`.

```javascript
class NameContainer extends React.Component {
  constructor() {
    super()
    this.state = {name: ""}
  }

  render() {
    return <Name onChange={newName => this.setState({name: newName})} />
  }
}
```

--

The state is `hoisted` to the container, by the provided callback, where it's used to update local state.
This sets a nice clear boundary and maximizes the re-usability of stateless function.

This pattern isn't limited to stateless functions.
Because stateless function don't have lifecycle events,
you'll use this pattern with component classes as well.

*`Controlled` input is an important pattern to know for use with state hoisting*

*(It's best to process the event object on the stateful component)*

---

# Controlled input

--

It's hard to talk about controlled inputs in the abstract.
Let's start with an uncontrolled (normal) input and go from there.

```javascript
<input type="text" />
```

When you fiddle with this input in the browser, you see your changes.
This is normal.

A controlled input disallows the DOM mutations that make this possible.
You set the `value` of the input in component-land and it doesn't change in DOM-land.

```javascript
<input type="text" value="This won't change. Try it." />
```

--

Obviously static inputs aren't very useful to your users.
So, we derive a `value` from state.

```javascript
class ControlledNameInput extends React.Component {
  constructor() {
    super()
    this.state = {name: ""}
  }

  render() {
    return <input type="text" value={this.state.name} />
  }
}
```

--

Then, changing the input is a matter of changing component state.

```javascript
    return (
      <input
        value={this.state.name}
        onChange={e => this.setState({ name: e.target.value })}
      />
    )
```

This is a controlled input.
It only updates the DOM when state has changed in our component.
This is invaluable when creating consistent UIs.

*If you're using `stateless functions` for form elements,
read about using `state hoisting` to move new state up the component tree.*

---

# Component Organization

--

* class definition
  * constructor
    * event handlers
  * 'component' lifecycle events
  * getters
  * render
* defaultProps
* proptypes

--

```javascript
class Person extends React.Component {
  constructor (props) {
    super(props);

    this.state = { smiling: false };

    this.handleClick = () => {
      this.setState({smiling: !this.state.smiling});
    };
  }

  componentWillMount () {
    // add event listeners (Flux Store, WebSocket, document, etc.)
  }

  componentDidMount () {
    // React.getDOMNode()
  }

  componentWillUnmount () {
    // remove event listeners (Flux Store, WebSocket, document, etc.)
  }

  get smilingMessage () {
    return (this.state.smiling) ? "is smiling" : "";
  }

  render () {
    return (
      <div onClick={this.handleClick}>
        {this.props.name} {this.smilingMessage}
      </div>
    );
  }
}

Person.defaultProps = {
  name: 'Guest'
};

Person.propTypes = {
  name: React.PropTypes.string
};
```

---

# Formatting Props

--

Wrap props on newlines for exactly 2 or more.

bad <!-- .element: class="filename" style="background-color: red" -->
```html
<Person
 firstName="Michael" />
 ```

good <!-- .element: class="filename" style="background-color: green" -->
 ```html
<Person firstName="Michael" />
```

bad <!-- .element: class="filename" style="background-color: red" -->
```html
<Person firstName="Michael" lastName="Chan" occupation="Designer" favoriteFood="Drunken Noodles" />
```

good <!-- .element: class="filename" style="background-color: green" -->
```html
<Person
 firstName="Michael"
 lastName="Chan"
 occupation="Designer"
 favoriteFood="Drunken Noodles" />
```

---

# Computed Props

--

Use getters to name computed properties.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
  firstAndLastName () {
    return `${this.props.firstName} ${this.props.lastname}`;
  }
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
  get fullName () {
    return `${this.props.firstName} ${this.props.lastname}`;
  }
```

---

# Compound State

--

Prefix compound state getters with a verb for readability.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
happyAndKnowsIt () {
  return this.state.happy && this.state.knowsIt;
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
get isHappyAndKnowsIt () {
  return this.state.happy && this.state.knowsIt;
}
```

These methods *MUST* return a `boolean` value.

---

# Prefer Ternary to Sub-render

--

Keep logic inside the `render` function.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
renderSmilingStatement () {
  return <strong>{(this.state.isSmiling) ? " is smiling." : ""}</strong>;
},

render () {
  return <div>{this.props.name}{this.renderSmilingStatement()}</div>;
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
render () {
  return (
    <div>
      {this.props.name}
      {(this.state.smiling)
        ? <span>is smiling</span>
        : null
      }
    </div>
  );
}
```

---

# View Components

--

Compose components into views. Don't create one-off components that merge layout
and domain components.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
class PeopleWrappedInBSRow extends React.Component {
  render () {
    return (
      <div className="row">
        <People people={this.state.people} />
      </div>
    );
  }
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
class BSRow extends React.Component {
  render () {
    return <div className="row">{this.props.children}</div>;
  }
}

class SomeView extends React.Component {
  render () {
    return (
      <BSRow>
        <People people={this.state.people} />
      </BSRow>
    );
  }
}
```

---

# Container Components

--

> A container does data fetching and then renders its corresponding
> sub-component. That's it. &mdash; Jason Bonta

--

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
// CommentList.js

class CommentList extends React.Component {
  getInitialState () {
    return { comments: [] };
  }

  componentDidMount () {
    $.ajax({
      url: "/my-comments.json",
      dataType: 'json',
      success: function(comments) {
        this.setState({comments: comments});
      }.bind(this)
    });
  }

  render () {
    return (
      <ul>
        {this.state.comments.map(({body, author}) => {
          return <li>{body}—{author}</li>;
        })}
      </ul>
    );
  }
}
```

--

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
// CommentList.js

class CommentList extends React.Component {
  render() {
    return (
      <ul>
        {this.props.comments.map(({body, author}) => {
          return <li>{body}—{author}</li>;
        })}
      </ul>
    );
  }
}
```

--

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
// CommentListContainer.js

class CommentListContainer extends React.Component {
  getInitialState () {
    return { comments: [] }
  }

  componentDidMount () {
    $.ajax({
      url: "/my-comments.json",
      dataType: 'json',
      success: function(comments) {
        this.setState({comments: comments});
      }.bind(this)
    });
  }

  render () {
    return <CommentList comments={this.state.comments} />;
  }
}
```

[Read more](https://medium.com/@learnreact/container-components-c0e67432e005)  
[Watch more](https://www.youtube.com/watch?v=KYzlpRvWZ6c&t=1351)

---

# Cached State in render

--

Do not keep state in `render`

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
render () {
  let name = `Mrs. ${this.props.name}`;

  return <div>{name}</div>;
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
render () {
  return <div>{`Mrs. ${this.props.name}`}</div>;
}
```

best <!-- .element: class="filename" style="background-color: green" -->
```javascript
get fancyName () {
  return `Mrs. ${this.props.name}`;
}

render () {
  return <div>{this.fancyName}</div>;
}
```

*This is mostly stylistic and keeps diffs nice. I doubt that there's a significant perf reason to do this.*

---

# Compound Conditions

--

Don't put compound conditions in `render`.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
render () {
  return <div>{if (this.state.happy && this.state.knowsIt) { return "Clapping hands" } }</div>;
}
```

better <!-- .element: class="filename" style="background-color: green" -->
```javascript
get isTotesHappy() {
  return this.state.happy && this.state.knowsIt;
},

render() {
  return <div>{(this.isTotesHappy) && "Clapping hands"}</div>;
}
```

The best solution for this would use a `Container component` to manage state and pass new state down as props.

---

# Existence Checking

--

Do not check existence of props at the root of a component.
Components should not have two possible return types.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
const Person = props => {
  if (this.props.firstName)
    return <div>{this.props.firstName}</div>
  else
    return null
}
```

--

Components should *always* render. Consider adding `defaultProps`, where a sensible default is appropriate.

better <!-- .element: class="filename" style="background-color: green" -->
```javascript
const Person = props =>
  <div>{this.props.firstName}</div>

Person.defaultProps = {
  firstName: "Guest"
}
```

If a component should be conditionally rendered, handle that in the owner component.

best <!-- .element: class="filename" style="background-color: green" -->
```javascript
const TheOwnerComponent = props =>
  <div>
    {props.person && <Person {...props.person} />}
  </div>
```

This is only where objects or arrays are used. Use PropTypes.shape to clarify
the types of nested data expected by the component.

---

# Setting State from Props

--

Do not set state from props without obvious intent.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
getInitialState () {
  return {
    items: this.props.items
  };
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
getInitialState () {
  return {
    items: this.props.initialItems
  };
}
```

---

# Naming Handler Methods

--

Name the handler methods after their triggering event.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
punchABadger () { /*...*/ },

render () {
  return <div onClick={this.punchABadger} />;
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
handleClick () { /*...*/ },

render () {
  return <div onClick={this.handleClick} />;
}
```

Handler names should:

- begin with `handle`
- end with the name of the event they handle (eg, `Click`, `Change`)
- be present-tense

If you need to disambiguate handlers, add additional information between
`handle` and the event name. For example, you can distinguish between `onChange`
handlers: `handleNameChange` and `handleAgeChange`. When you do this, ask
yourself if you should be creating a new component.

---

# Naming Events

--

Use custom event names for ownee events.

```javascript
class Owner extends React.Component {
  handleDelete () {
    // handle Ownee's onDelete event
  }

  render () {
    return <Ownee onDelete={this.handleDelete} />;
  }
}

class Ownee extends React.Component {
  render () {
    return <div onChange={this.props.onDelete} />;
  }
}

Ownee.propTypes = {
  onDelete: React.PropTypes.func.isRequired
};
```

---

# Using PropTypes

--

Use PropTypes to communicate expectations and log meaningful warnings.

```javascript
MyValidatedComponent.propTypes = {
  name: React.PropTypes.string
};
```
`MyValidatedComponent` will log a warning if it receives `name` of a type other than `string`.


```html
<Person name=1337 />
// Warning: Invalid prop `name` of type `number` supplied to `MyValidatedComponent`, expected `string`.
```

Components may also require `props`.

```javascript
MyValidatedComponent.propTypes = {
  name: React.PropTypes.string.isRequired
}
```

This component will now validate the presence of name.

```html
<Person />
// Warning: Required prop `name` was not specified in `Person`
```

---

# Using Entities

--

Use React's `String.fromCharCode()` for special characters.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
<div>PiCO · Mascot</div>
```

nope <!-- .element: class="filename" style="background-color: red" -->
```javascript
<div>PiCO &middot; Mascot</div>
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
<div>{'PiCO ' + String.fromCharCode(183) + ' Mascot'}</div>
```

better <!-- .element: class="filename" style="background-color: green" -->
```javascript
<div>{`PiCO ${String.fromCharCode(183)} Mascot`}</div>
```

---

# Tables

--

The browser thinks you're dumb. But React doesn't. Always use `tbody` in
`table` components.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
render () {
  return (
    <table>
      <tr>...</tr>
    </table>
  );
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
render () {
  return (
    <table>
      <tbody>
        <tr>...</tr>
      </tbody>
    </table>
  );
}
```

The browser is going to insert `tbody` if you forget. React will continue to
insert new `tr`s into the `table` and confuse the heck out of you. Always use
`tbody`.

---

# classNames

--

Use [classNames](https://www.npmjs.com/package/classnames) to manage conditional classes.

bad <!-- .element: class="filename" style="background-color: red" -->
```javascript
get classes () {
  let classes = ['MyComponent'];

  if (this.state.active) {
    classes.push('MyComponent--active');
  }

  return classes.join(' ');
}

render () {
  return <div className={this.classes} />;
}
```

good <!-- .element: class="filename" style="background-color: green" -->
```javascript
render () {
  let classes = {
    'MyComponent': true,
    'MyComponent--active': this.state.active
  };

  return <div className={classnames(classes)} />;
}
```

Read: [Class Name Manipulation](https://github.com/JedWatson/classnames/blob/master/README.md)

---

## References

https://github.com/chantastic/reactpatterns.com

https://github.com/planningcenter/react-patterns

---

# The End
