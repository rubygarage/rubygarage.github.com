---
layout: slide
title: Redux
---
![](/assets/images/redux/logo.png)
<!-- .element: style="max-width: 300px" -->

# Redux

---

##Writing Redux
The whole point with Redux is to have one single source of truth for your application state. The state is stored as a plain Javascript object in one place: the Redux Store. The state object is read only. If you want to change the state, you need to emit an Action, which is a plain JavaScript object.

--

![](/assets/images/redux/redux_app_diagram.png)

Your application can subscribe to get notified when the store has changed. When Redux is used with React, it is the React components that get notified when state changes, and can re-render based on new content in the store.

The store needs a way to know how to update the state in the store when it gets an Action. It uses a plain JavaScript function for this that Redux calls a reducer. The reducer function is passed in when the store is created.

--

To summarize, we need to be able to do three things with our store:

1. Get the current state of the store
2. Dispatch an action, which is passed as an argument to the reducer to update the state in the store.
3. Listen to when the store changes

We also need to define the reducer and the initial state at startup time. Let’s start with this:

```javascript
function createStore(reducer, initialState) {
    var currentReducer = reducer;
    var currentState = initialState;
}
```

--

## Get state


We have created a function that just saves the initial state and the reducer as local variables. Now let’s implement the possibility to get the state of the store.

Our store implementation

```javascript
function createStore(reducer, initialState) {
    var currentReducer = reducer;
    var currentState = initialState;
 
    return {
        getState() {
            return currentState;
        }
    };
}
```
We can now get the state object with `getState()`

--

## Dispatch an action
Next step is to implement support for dispatching an action.
```javascript
function createStore(reducer, initialState) {
    var currentReducer = reducer;
    var currentState = initialState;
 
    return {
        getState() {
            return currentState;
        },
        dispatch(action) {
            currentState = currentReducer(currentState, action);
            return action;
        }
    };
}
```

The dispatch  function passes the current state and the dispatched Action through the reducer that we defined at init. It then overwrites the old state with the new state.

--

## Subscribe for changes

Now we can both get current state and update the state! The last step is to be able to listen to changes:
```javascript
function createStore(reducer, initialState) {
    var currentReducer = reducer;
    var currentState = initialState;
    var listener = () => {};
 
    return {
        getState() {
            return currentState;
        },
        dispatch(action) {
            currentState = currentReducer(currentState, action);
            listener(); // Note that we added this line!
            return action;
        },
        subscribe(newListener) {
            listener = newListener;
        }
    };
}
```
Now we can call subscribe with a callback function as parameter that will be called whenever an action is dispatched.

--

##We are done. Let’s use it!

That’s the whole mini-Redux implementation! It’s actually a stripped down version of the real Redux code.
```javascript

function counter(state = 0, action) {
  switch (action.type) {
  case 'INCREMENT':
    return state + 1
  case 'DECREMENT':
    return state - 1
  default:
    return state
  }
}
 
let store = createStore(counter)
 
store.subscribe(() =>
  console.log(store.getState())
)
 
store.dispatch({ type: 'INCREMENT' })
store.dispatch({ type: 'INCREMENT' })
store.dispatch({ type: 'DECREMENT' })
```

---


## Work With Redux

--

## Actions

<br/>



Actions are payloads of information that send data from your application to your store. They are the only source of information for the store. You send them to the store using `store.dispatch()`.
```javascript
const ADD_TODO = 'ADD_TODO'

{
  type: ADD_TODO,
  text: 'Build my first Redux app'
}
```


--

Actions are plain JavaScript objects. Actions must have a type property that indicates the type of action being performed. Types should typically be defined as string constants. Once your app is large enough, you may want to move them into a separate module.


```javascript
import { ADD_TODO, REMOVE_TODO } from '../actionTypes'
```

--

## Action Creators

<br/>
Action creators are exactly that—functions that create actions. 
<br/>
It's easy to conflate the terms `action` and `action creator`, so do your best to use the proper term.
<br/>
In Redux action creators simply return an action. This makes them portable and easy to test.


```javascript
function addTodo(text) {
  return {
    type: ADD_TODO,
    text
  }
}
```

To actually initiate a dispatch, pass the result to the `dispatch()` function:
```javascript
dispatch(addTodo(text))
dispatch(completeTodo(index))
```

--

Alternatively, you can create a bound action creator that automatically dispatches:
```javascript

const boundAddTodo = (text) => dispatch(addTodo(text))
const boundCompleteTodo = (index) => dispatch(completeTodo(index))
```

Now you'll be able to call them directly:

```javascript
boundAddTodo(text)
boundCompleteTodo(index)
```
<br/>
The `dispatch()` function can be accessed directly from the store as `store.dispatch()`, but more likely you'll access it using a helper like react-redux's `connect()`. 

Action creators can also be asynchronous and have side-effects.

--

## Reducers

Actions describe the fact that something happened, but don't specify how the application's state changes in response. This is the job of reducers.

--

In Redux, all the application state is stored as a single object. It's a good idea to think of its shape before writing any code. What's the minimal representation of your app's state as an object?


For our todo app, we want to store two different things:
* The currently selected visibility filter;
* The actual list of todos.

--

You'll often find that you need to store some data, as well as some UI state, in the state tree. This is fine, but try to keep the data separate from the UI state.
```json
{
  visibilityFilter: 'SHOW_ALL',
  todos: [
    {
      text: 'Consider using Redux',
      completed: true,
    },
    {
      text: 'Keep all state in a single tree',
      completed: false
    }
  ]
}
```

Now that we've decided what our state object looks like, we're ready to write a reducer for it.

--

The reducer is a pure function that takes the previous state and an action, and returns the next state.


```javascript
  (previousState, action) => newState
```

It's called a reducer because it's the type of function you would pass to `Array.prototype.reduce(reducer, ?initialValue)`.

--
Just remember that the reducer must be pure.
Given the same arguments, it should calculate the next state and return it.
No surprises. No side effects. No API calls. No mutations. Just a calculation.


Things you should never do inside a reducer:

* Mutate its arguments;
* Perform side effects like API calls and routing transitions;
* Call non-pure functions, e.g. `Date.now()` or `Math.random()`.

--

We'll start by specifying the initial state. Redux will call our reducer with an undefined state for the first time. This is our chance to return the initial state of our app:

```javascript
import { VisibilityFilters } from './actions'

const initialState = {
  visibilityFilter: VisibilityFilters.SHOW_ALL,
  todos: []
}

function todoApp(state = initialState, action) {
  // For now, don't handle any actions
  // and just return the state given to us.
  return state
}
```

--

Now let's handle `SET_VISIBILITY_FILTER`. 

All it needs to do is to change `visibilityFilter` on the state.

```javascript
function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return { ...state, visibilityFilter: action.filter }
    default:
      return state
  }
}
```

Note that:
* We don't mutate the state. We create a copy with `{ ...state, ...newState }`.
* We return the previous state in the default case. It's important to return the previous state for any unknown action.

--

Finally, Redux provides a utility called combineReducers() that does the same boilerplate logic that the todoApp above currently does. With its help, we can rewrite todoApp like this:
```javascript
import { combineReducers } from 'redux'

const todoApp = combineReducers({
  visibilityFilter,
  todos
})

export default todoApp
```
Note that this is equivalent to:
```javascript
export default function todoApp(state = {}, action) {
  return {
    visibilityFilter: visibilityFilter(state.visibilityFilter, action),
    todos: todos(state.todos, action)
  }
}
```

--

You could also give them different keys, or call functions differently. These two ways to write a combined reducer are equivalent:
```javascript
const reducer = combineReducers({
  a: doSomethingWithA,
  b: processB,
  c: c
})

function reducer(state = {}, action) {
  return {
    a: doSomethingWithA(state.a, action),
    b: processB(state.b, action),
    c: c(state.c, action)
  }
}
```
All `combineReducers()` does is generate a function that calls your reducers with the slices of state selected according to their keys, and combining their results into a single object again. It's not magic. And like other reducers, `combineReducers()` does not create a new object if all of the reducers provided to it do not change state.


--

## Store

The Store is the object that brings them together. 

The store has the following responsibilities:
* Holds application state;
* Allows access to state via `getState()`;
* Allows state to be updated via `dispatch(action)`;
* Registers listeners via `subscribe(listener)`;
* Handles unregistering of listeners via the function returned by `subscribe(listener)`.

<br/>

It's important to note that you'll only have a single store in a Redux application.

When you want to split your data handling logic, you'll use reducer composition instead of many stores.

--

It's easy to create a store if you have a reducer. In the previous section, we used `combineReducers()` to combine several reducers into one. We will now import it, and pass it to `createStore()`.

```javascript
import { createStore } from 'redux'
import todoApp from './reducers'
let store = createStore(todoApp)
```

<br />
You may optionally specify the initial state as the second argument to `createStore()`. This is useful for hydrating the state of the client to match the state of a Redux application running on the server.

```javascript
let store = createStore(todoApp, window.STATE_FROM_SERVER)
```
--

## Dispatching Actions

Now that we have created a store, let's verify our program works! Even without any UI, we can already test the update logic.

```javascript
import { addTodo, toggleTodo, setVisibilityFilter, VisibilityFilters } from './actions'

// Log the initial state
console.log(store.getState())

// Every time the state changes, log it
// Note that subscribe() returns a function for unregistering the listener

let unsubscribe = store.subscribe(() =>
  console.log(store.getState())
)

// Dispatch some actions
store.dispatch(addTodo('Learn about actions'))
store.dispatch(addTodo('Learn about reducers'))
store.dispatch(addTodo('Learn about store'))
store.dispatch(toggleTodo(0))
store.dispatch(toggleTodo(1))
store.dispatch(setVisibilityFilter(VisibilityFilters.SHOW_COMPLETED))

// Stop listening to state updates
unsubscribe()
```
--

## Data Flow

Redux architecture revolves around a strict unidirectional data flow.
This means that all data in an application follows the same lifecycle pattern, making the logic of your app more predictable and easier to understand. It also encourages data normalization, so that you don't end up with multiple, independent copies of the same data that are unaware of one another.

--

### 1. You call `store.dispatch(action)`.    
An action is a plain object describing what happened. For example: 
```json
{ type: 'LIKE_ARTICLE', articleId: 42 }
{ type: 'FETCH_USER_SUCCESS', response: { id: 3, name: 'Mary' } }
{ type: 'ADD_TODO', text: 'Read the Redux docs.' }
```

 Think of an action as a very brief snippet of news. “Mary liked article 42.” or “‘Read the Redux docs.' was added to the list of todos.” You can call `store.dispatch(action)` from anywhere in your app, including components and XHR callbacks, or even at scheduled intervals. 

--

### 2. The Redux store calls the reducer function you gave it. 

The store will pass two arguments to the reducer: the current state tree and the action. For example, the root reducer might receive something like this: 
```javascript
// The current application state (list of todos and chosen filter)
   let previousState = {
      visibleTodoFilter: 'SHOW_ALL',
      todos: [
        {
          text: 'Read the docs.',
          complete: false
        }
      ]
  }

  // The action being performed (adding a todo)
  let action = {
      type: 'ADD_TODO',
      text: 'Understand the flow.'
  }

  // Your reducer returns the next application state
  let nextState = todoApp(previousState, action)
```

 Note that a reducer is a pure function. It only computes the next state. It should be completely predictable, calling it with the same inputs many times should produce the same outputs. It shouldn't perform any side effects like API calls or router transitions. These should happen before an action is dispatched.

--

### 3. The root reducer may combine the output of multiple reducers into a single state tree. 

How you structure the root reducer is completely up to you. Redux ships with a `combineReducers()` helper function, useful for “splitting” the root reducer into separate functions that each manage one branch of the state tree. Here's how `combineReducers()` works.

Let's say you have two reducers, one for a list of todos, and another for the currently selected filter setting: 
```javascript

function todos(state = [], action) {
  // Somehow calculate it...
  return nextState
}

function visibleTodoFilter(state = 'SHOW_ALL', action) {
  // Somehow calculate it...
  return nextState
}

let todoApp = combineReducers({
  todos,
  visibleTodoFilter
})
```
--

 When you emit an action, todoApp returned by `combineReducers` will call both reducers:
```javascript
  let nextTodos = todos(state.todos, action)
  let nextVisibleTodoFilter = visibleTodoFilter(state.visibleTodoFilter, action)
```
 It will then combine both sets of results into a single state tree: 
```JavaScript
return {
  todos: nextTodos, 
  visibleTodoFilter: nextVisibleTodoFilter 
}
```
 While `combineReducers()` is a handy helper utility, you don't have to use it; feel free to write your own root reducer!

--

### 4. The Redux store saves the complete state tree returned by the root reducer.

 This new tree is now the next state of your app!

Every listener registered with `store.subscribe(listener)` will now be invoked, listeners may call `store.getState()` to get the current state.

 Now, the UI can be updated to reflect the new state. If you use bindings like React Redux, this is the point at which `component.setState(newState)` is called.


---

## Getting started

Install it once globally:
<!-- .element: style="margin-left:30px; text-align: left" -->
```bash
npm install -g create-react-app
```
You’ll need to have Node >= 6 on your machine. You can use 
<!-- .element: style="margin-left:60px; text-align: left; font-size: 25px;" -->
[nvm](https://github.com/creationix/nvm) 
to easily switch Node versions between different projects.
<!-- .element: style="text-align: left; font-size: 25px;" -->

<br/>

To create a new app, run:
<!-- .element: style="margin-left:30px; text-align: left" -->
```bash
create-react-app react-redux-example
```


It will create a directory called react-redux-example inside the current folder.
<!-- .element: style="margin-left:30px; text-align: left" -->
```bash
cd react-redux-example/
npm start
```

<br/>


Source code: 
<!-- .element: style="margin-left:30px; text-align: left" -->
https://github.com/GarrisonD/react-redux-example


--
## Communication between components

<br />

We need to pass state from `Form` to `Graphics` component.

![](/assets/images/redux/first-example.png)
<!-- .element: style="margin: 0 auto; " -->

But unfortunately we can't pass state from one component to another 
<br />
on the same nesting level.
<br />

```bash
git reset --hard '1651f002a092a8cbc2408040555cd3e7dcea2c02'
```

--

## 1. React Way (Local state)

<br />

![](/assets/images/redux/react-way-example.png)

For passing data from A to B we create parent C
<br/>
that will store and pass data to its children.

--

## React Way - Step 1

![](/assets/images/redux/img-2-2.png)

First of all we should create common parent component for these two components.
```bash
git reset --hard '1d9a191c63ff50b445b927b6a0dc960ed6e05d54' && git reset --soft HEAD~1
```
--

## React Way - Step 2

![](/assets/images/redux/img-3.png)

Create storage in parent component and pass its data to children.

```bash
git reset --hard '8e0721609631098ca6f0b82d6c484b18b61585d4' && git reset --soft HEAD~1
```

--

## React Way - Step 3

![](/assets/images/redux/img-4.png)

Add event handlers for inputs in the Form to pass input changes from Form to parent component.

```bash
git reset --hard '16a3ee7f4b63d0bfff93488ab5ad512ebb27923a' && git reset --soft HEAD~1
```

--
## React Way - Step 4

![](/assets/images/redux/img-5.png)

Upgrade form component: add fields for controlling circle `X` and `Y` values.


```bash
git reset --hard 'fab1729f1ef2ec52b34132decab41551a75e689b' && git reset --soft HEAD~3
```

--

## React Way - Step 5

So whats wrong with this code?
<br />

We have plenty of code duplication! For example, when we pass data from `GraphicsEditor` to `SpecsFields` and `PositionFields` through `Form`. And number of LOC increases rapidly with nesting level.

--

## React Way - Step 6

What about `...props` ?
<br />

- **Advantages:**
  <br/>
  &nbsp;&nbsp;Much less LOC
  <br/>
  
- **Disadvantages:**
  <br/>
  &nbsp;&nbsp;Form's dependencies are implicit
  <br/>
  &nbsp;&nbsp;Change event of one field forces rerender of another field even from another field group

<br/>

```bash
git reset --hard '6e5d2de9edaa1d1289fccde5015714a62ab022cc' && git reset --soft HEAD~1
``` 

---
## Redux Way (Store)
<br />
![](/assets/images/redux/img-store.png)

For passing data from A to B we configure Redux Store
<br/>
that will store data that any React component can manage.



--

## Redux Ingredients

--

## Ingredient #1 - Store

![](/assets/images/redux/img-store-1.png)

First of all, Store is an object that keeps hash (key-value) data structure or object.
<!-- .element: style="margin: 0 auto; " -->

```bash 
git reset --hard '712bb153d4fb55738cfcbc498b6a4aa8a5ac1a9a' && git reset --soft HEAD~1
```
--
### But how can we access data in the Store?
![](/assets/images/redux/img-store-2.png)


We can easily obtain data from the Store by calling `getState()` function.

<br/>
```JavaScript
const store = /* magic */

store.getState() // { key1: value1, key2: value2, key3: value3, ... }
```


--
### But how can we update data in the Store?


![](/assets/images/redux/img-store-3.png)

But we can't just modify the state. We can only achieve
<br/>
it by using `reducers` that react to dispatched `actions`.

--

## Ingredient #2 - Action

Action is a plain JS object. It has one *required* field with name `type`.

<br/>

Simple action:
<!-- .element: style="margin-left:30px; text-align: left" -->
```JavaScript
{ type: 'INCREMENT' }
```
<br/>

Action with payload:
<!-- .element: style="margin-left:30px; text-align: left" -->
```JavaScript
{ type: 'USER/LOGIN', username: 'vasya' }
```

--

## Ingredient #3 - Reducer

It will be easier to understand if you think about it as a `transformer`.
<br/>

Reducer is a `pure function` that takes `current state` and `action`, and returns new state.
```JavaScript
const count = (state = 0, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1
    case 'DECREMENT':
      return state - 1  
    default:
      return state
  }
}
```

--

## Ingredient #4 - Selector

Selector is a function that takes state as first argument and returns piece of it.

```JavaScript
const state = {
  count: 123
}

const getCount = (state) => state.count

getCount(state) // 123
```

```JavaScript
const state = {
  todos: [
    { name: 'Hello', done: true },
    { name: 'World', done: false }
  ]
}

const getTodosInProgress = (state) => 
  state.todos.filter(todo => !todo.done)

getTodosInProgress(state) // [{ name: 'World', done: false }]
```

```bash
git reset --hard '5751c14eb5c5e3fb93721f877a8d1c2caaff8fd0' && git reset --soft HEAD~1
```

--

## Dispatching actions.

```bash
git reset --hard 'dfb21e4a37f52e9f4d49453bee5d745b0d89dd02' && git reset --soft HEAD~1
```
---

## State Normalization
--
## Why?
Since the moment our application starts to expand, it becomes harder and harder to control state. Many of the data coming from the server is nested and relational in nature. For example, the Author can have many Posts, each Post can have a lot of comments and all comments can be written by different users. In order not to complicate the development in the future, we must correctly store our data in the state.
--
Data for this kind of application might look like:
<br />
This data structure is very complex, and some data is repeated.
```JavaScript
const blogPosts = [
  {
    id: "post1",
    author: {username: "user1", name: "User 1"},
    body: "......",
    comments: [
      {
        id: "comment1",
        author: {username: "user2", name: "User 2"},
        comment: ".....",
      },
      {
        id: "comment2",
        author: {username: "user3", name: "User 3"},
        comment: ".....",
      }
    ]
  },
  {
    id: "post2",
    author: {username: "user2", name: "User 2"},
    body: "......",
    comments: [
      {
        id: "comment3",
        author: {username: "user3", name: "User 3"},
        comment: ".....",
      },
      {
        id: "comment4",
        author: {username: "user1", name: "User 1"},
        comment: ".....",
      },
      {
        id: "comment5",
        author: {username: "user3", name: "User 3"},
        comment: ".....",
      }
    ]    
  }
  // and repeat many times
]
```
<!-- .element: style="max-height: 400px;" -->

####This is a problem for several reasons:
<!-- .element:text-align: left" -->

- When a piece of data is duplicated in several places, it becomes harder to make sure that it is updated appropriately.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
- Nested data means that the corresponding reducer logic has to be more nested or more complex. In particular, trying to update a deeply nested field can become very ugly very fast.
- Since immutable data updates require all ancestors in the state tree to be copied and updated as well, and new object references will cause connected UI components to re-render, an update to a deeply nested data object could force totally unrelated UI components to re-render even if the data they're displaying hasn't actually changed.
--
## Designing a Normalized State

<br />

####The basic concepts of normalizing data are:

- Each type of data gets its own "table" in the state.
- Each "data table" should store the individual items in an object, with the IDs of the items as keys and the items themselves as the values.
- Any references to individual items should be done by storing the item's ID.
-Arrays of IDs should be used to indicate ordering.

--
####An example of a normalized state structure for the blog example above might look like:
```JSON
{
  posts : {
    byId : {
      "post1" : {
        id : "post1",
        author : "user1",
        body : "......",
        comments : ["comment1", "comment2"]
      },
      "post2" : {
        id : "post2",
        author : "user2",
        body : "......",
        comments : ["comment3", "comment4", "comment5"]
      }
    }
    allIds : ["post1", "post2"]
  },
  comments : {
    byId : {
      "comment1" : {
        id : "comment1",
        author : "user2",
        comment : ".....",
      },
      "comment2" : {
        id : "comment2",
        author : "user3",
        comment : ".....",
      },
      ...
    },
    allIds : ["comment1", "comment2", ...]
  },
  users : {
    byId : {
      "user1" : {
        username : "user1",
        name : "User 1",
      }
      "user2" : {
        username : "user2",
        name : "User 2",
      }
      ...
    },
    allIds : ["user1", "user2", ...]
  }
}
```
--
This state structure is much flatter overall. 

####Compared to the original nested format, this is an improvement in several ways:

- Because each item is only defined in one place, we don't have to try to make changes in multiple places if that item is updated.

- The reducer logic doesn't have to deal with deep levels of nesting, so it will probably be much simpler.

- The logic for retrieving or updating a given item is now fairly simple and consistent. Given an item's type and its ID, we can directly look it up in a couple simple steps, without having to dig through other objects to find it.

- Since each data type is separated, an update like changing the text of a comment would only require new copies of the `comments -> byId -> comment` portion of the tree. This will generally mean fewer portions of the UI that need to update because their data has changed. In contrast, updating a comment in the original nested shape would have required updating the comment object, the parent post object, the array of all post objects, and likely have caused all of the Post components and Comment components in the UI to re-render themselves.
--
## Organizing Normalized Data in State

<br/>

A typical application will likely have a mixture of relational data and non-relational data. While there is no single rule for exactly how those different types of data should be organized, one common pattern is to put the relational `tables` under a common parent key, such as `entities`.
<br/>

A state structure using this approach might look like:

```JSON
{
  simpleDomainData1: {....},
  simpleDomainData2: {....}
  entities : {
    entityType1 : {....},
    entityType2 : {....}
  }
  ui : {
    uiSection1 : {....},
    uiSection2 : {....}
  }
}
```
--
## Relationships and Tables
<br/>
Because we're treating a portion of our Redux store as a `database`, many of the principles of database design also apply here as well.
<br/>
For example, if we have a many-to-many relationship, we can model that using an intermediate table that stores the IDs of the corresponding items.
For consistency, we would probably also want to use the same `byId` and `allIds` approach that we used for the actual item tables, like this:
<!-- .element: style="text-align: left" -->

```JSON
{
  entities: {
    authors: { byId: {}, allIds: [] },
    books: { byId: {}, allIds: [] },
    authorBook: {
      byId: {
        1: {
          id: 1,
          authorId: 5,
          bookId: 22
        },
        2: {
          id: 2,
          authorId: 5,
          bookId: 15,
        }
      },
      ...
      allIds: [1, 2, ...]
    }
  }
}
```
---

##What to Put in the Redux Store?
--
A common issue when working with Redux is deciding what information goes inside our state and what is left outside, either in React’s state.

<br />
####There are a few questions to consider when deciding whether to add something to the state:

- Should this data be persisted across page refresh?

- Should this data be persisted across route changes?
<!-- .element: style="text-align: left" -->

- Is this data used in multiple places in the UI?
<!-- .element: style="text-align: left" -->

If the answer to any of these questions is “yes,” the data should go into the state. If the answer to all of these questions is “no,” it could still go into the state, but it’s not a must.»
<!-- .element: style="text-align: left" -->
--

### Example 1 - Should this data be persisted across page refresh?

![](/assets/images/redux/persist-flow-example-img-1.png)


--

### Example 2 - Should this data be persisted across route changes?


![](/assets/images/redux/routing-changes-example.png)

--

### Example 3 - Is this data used in multiple places in the UI?

![](/assets/images/redux/multiply-places-ui-example.png)

--
A few examples of data that can be kept outside of the redux storage:

- Currently selected tab in a tab control on a page
<!-- .element: style="margin-left:1px; text-align: left" -->

- Hover visibility/invisibiity on a control
<!-- .element: style="margin-left:1px; text-align: left" -->

- Modal being open/closed
<!-- .element: style="margin-left:1px; text-align: left" -->

- Currently displayed errors
<!-- .element: style="margin-left:1px; text-align: left" -->

<br />
Some information can be safely lost without affecting the user’s experience or corrupting his data.
---
## Middleware
--

Provides capability to `put CODE` between dispatching an `action` and reaching the `reducer`.

--
## Basic Redux life-cycle

![](/assets/images/redux/redux-life-cycle.png)
--
## Redux life-cycle with middlewares
![](/assets/images/redux/redux-middleware-lifecycle.png)

--
## Simplest example - logger middleware
![](/assets/images/redux/middleware-logger-example.png)
--
## Logger middleware implementation:

In case we need the store <!-- .element: class="filename" -->
```JavaScript
export default store => next => action => {
  //do something 
  //next(action)
} 
```
Simple logger implementation <!-- .element: class="filename" -->

```JavaScript
export default store => next => action => {
  // log state before running reducers
  console.log(`Before running reducers: `, store.getState())

  // log action that will be processed by reducers
  console.log(`${new Date()} ${action.type}`)

  // run processing action by reducers
  next(action)

  // log state after running reducers
  console.log(`After running reducers: `, store.getState())
}
```

<br/>

```bash
git reset --hard '5068bed26d9fc27f9017ef30cb1e38ad37b10022'
```

--

## Using our middleware


src/index.js <!-- .element: class="filename" -->
```JavaScript
export const configureStore = () => {
  /* some configuration here */

  return createStore(
    reducer,

    applyMiddleware(
      middleware1,
      middleware2,
      middleware3
    )
  )
}

```
--
## Popular middlewares

- redux-promise https://github.com/acdlite/redux-promise

- redux-thunk https://github.com/gaearon/redux-thunk

- redux-saga https://github.com/redux-saga/redux-saga

- redux-logger https://github.com/evgenyrodionov/redux-logger

---
## React Redux
--
## Map State To Props

When your selectors depend on nothing  <!-- .element: class="filename" -->

```JavaScript
const mapStateToProps = (state) => {
  return {
    data1: selector1(state),
    data2: selector2(state)
  }
}
```

When your selectors depend on incoming props  <!-- .element: class="filename" -->
```JavaScript
const mapStateToProps = (state, ownProps) => {
  return {
    data1: selector1(state),
    data2: selector2(state),

    data3: selector3(state, ownProps.value)
  }
}
```

--

## Map Dispatch To Props

Action creator  <!-- .element: class="filename" -->
```JavaScript
const increaseCounter = () => ({
  type: 'INCREASE_COUNTER'
})
```

Light version  <!-- .element: class="filename" -->
```JavaScript
const mapDispatchToProps = {
  increaseCounter
}
```

Full version  <!-- .element: class="filename" -->
```JavaScript
const mapDispatchToProps = (dispatch) => ({
  increaseCounter: () => dispatch(increaseCounter())
})
```

<br />

```JavaScript
export connect(null, mapDispatchToProps)(CounterApp)

/* if mapStateToProps is defined somewhere in context */
export connect(mapStateToProps, mapDispatchToProps)(CounterApp)
```

--

## Merge Props

```JavaScript
const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...ownProps,
  ...stateProps,

  action: () => doSomething(stateProps.value, ownProps.value)
})

/* if mapStateToProps and mapDispatchToProps are defined somewhere in context */
export connect(mapStateToProps, mapDispatchToProps, mergeProps)(CounterApp)
```

---
## Useful resources:
- **Redux Docs**
  <br/>
  http://redux.js.org/
- **Getting Started with Redux - Video Series**  
  https://egghead.io/series/getting-started-with-redux
  <br/>
  https://github.com/tayiorbeii/egghead.io_redux_course_notes
- **Modern Web Development with React and Redux**
  http://blog.isquaredsoftware.com/2017/02/presentation-react-redux-intro/    
- **The Complete Redux Book**
  <br/>
  https://leanpub.com/redux-book
- **More**   
  https://github.com/markerikson/react-redux-links/
 
---
# Thank you.