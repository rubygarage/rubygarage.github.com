---
layout: slide
title: Redux
---
![](/assets/images/redux/logo.png)
<!-- .element: style="max-width: 300px" -->

# Redux

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
# State Normalization
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
--
##What to Put in the Redux Storage?
<br/>
A common issue when working with Redux is deciding what information goes inside our state and what is left outside, either in React’s state.

<br />
####There are a few questions to consider when deciding whether to add something to the state:

- Should this data be persisted across page refresh?

- Should this data be persisted across route changes?
<!-- .element: style="text-align: left" -->

- Is this data used in multiple places in the UI?
<!-- .element: style="text-align: left" -->

- If the answer to any of these questions is “yes,” the data should go into the state. If the answer to all of these questions is “no,” it could still go into the state, but it’s not a must.»
<!-- .element: style="text-align: left" -->


--
####A few examples of data that can be kept outside of the redux storage:

- Currently selected tab in a tab control on a page
<!-- .element: style="margin-left:1px; text-align: left" -->

- Hover visibility/invisibiity on a control
<!-- .element: style="margin-left:1px; text-align: left" -->

- Lightbox being open/closed
<!-- .element: style="margin-left:1px; text-align: left" -->

- Currently displayed errors
<!-- .element: style="margin-left:1px; text-align: left" -->

<br />
Some information can be safely lost without affecting the user’s experience or corrupting his data.
---
# Middleware
--
Provides capability to 
<br/>
`put CODE`
<br/>
between
<br/>
dispatching an `action`
<br/>
and
<br/>
reaching the `reducer`
--
## Basic Redux life-cycle

![](/assets/images/redux/redux-life-cycle.png)
--
## Redux life-cycle with middlewares
![](/assets/images/redux/redux-middleware-lifecycle.png)
--
## Middleware benefits:

- Composable
- Independent
--
## Middleware stack example
![](/assets/images/redux/middleware-stack-example.png)
--
## Middleware structure:

- It is a `function` that receives the `store`

- `It MUST return a function` with arg `next`

- `That returns a function` with arg `action`

  - Where we do our stuff
  - And `return`

    - `next(action)`
    - `state.dispatch(action)`
--
## Middleware structure
<br/>

ES 5 middleware declaration<!-- .element: class="filename" -->
```JavaScript
  export default function(store) { 
    return function(next) { 
      return function(action) {
        //do something
        //use next(action) or
        //state.dispatch(action) 
      } 
    } 
  } 
```
--
## Middleware structure ES6

src/middleware/myMiddleware.js <!-- .element: class="filename" -->
```JavaScript
export default store => next => action => {
  //do something 
  //next(action); or state.dispatch(action); 
  } 
} 
```
In case we don’t need the store <!-- .element: class="filename" -->
```JavaScript
export default ({dispatch}) => next => action => { 
  //our stuff 
  } 
}  
```
--
## Simplest example - logger
![](/assets/images/redux/middleware-logger-example.png)
--
## Using our middleware


src/index.js <!-- .element: class="filename" -->
```JavaScript
import {createStore, applyMiddleware } from 'redux'; 
import reducers from './reducers';
import MyMid from './middlewares/my-middleware'; 

const createStoreWithMiddleware = applyMiddleware(myMid)(createStore); 

ReactDOM.render( 
  <Provider store={createStoreWithMiddleware(reducers)}> 
    <App /> 
  </Provider> 
  , document.querySelector('.container')); 
```
--

## Modify action middleware workflow
![](/assets/images/redux/middleware-workflow.png)

--
## Dispatch action example - superstitious counter
![](/assets/images/redux/middleware-flow-example2.png)

--
## Popular middlewares

- redux-promise https://github.com/acdlite/redux-promise

- redux-thunk https://github.com/gaearon/redux-thunk

- redux-saga https://github.com/redux-saga/redux-saga

- redux-logger https://github.com/evgenyrodionov/redux-logger
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