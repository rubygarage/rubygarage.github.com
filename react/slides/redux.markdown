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
---
# Thank you.