---
layout: slide
title: React Router 4
---

![](/assets/images/react-router-4/react-router-logo.png)

## React Router 4

---

First of all, add `react-router-dom` package to project dependencies.

<br />

To install with `npm`, run:

```bash
npm install --save react-router-dom
```

<br />

To install with `Yarn`, run:

```bash
yarn add react-router-dom
```

--

If you are using `webpack-dev-server`, add `--history-api-fallback`:

```bash
webpack-dev-server ... --history-api-fallback
```

<br />

Or update your Webpack config:

```js
{
  ...

  devServer: {
    historyApiFallback: true
  }

  ...
}
```

---

For example, this is an entry point of our SPA:

```js
import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import Application from './Application'

import store from './redux-store'

ReactDOM.render(
  <Provider store={store}>
    <Application />
  </Provider>,

  document.getElementById('app')
)
```

--

Import `BrowserRouter` from `react-router-dom` package:

```js
import { BrowserRouter } from 'react-router-dom'
```

<br />

And wrap your `Application` with imported `BrowserRouter`:

```js
...

ReactDOM.render(
  <Provider store={store}>
    <BrowserRouter>
      <Application />
    </BrowserRouter>
  </Provider>,

  document.getElementById('app')
)

...
```

<br />

WARNING! `BrowserRouter` use `History API` under the hood and it won't work with Github Pages. <br />
If you are going to deploy your application to Github Pages use `HashRouter` instead.

---

Let's imagine we want to display these components:

```js
const Home  = () => <span>It is home page!</span>  // for /
const About = () => <span>It is about page!</span> // for /about
```

<br />

To make it possible we import `Route` from `react-router-dom` package:

```js
import { Route } from 'react-router-dom'
```

<br />

And update our `Application` component:

```js
const Application = () => (
  <div>
    <Route path='/'      component={Home}  />
    <Route path='/about' component={About} />
  </div>
)
```

--

Visit `http://www.example.com/`:

```html
...

<span>It is home page!</span>

...
```

<br />

Visit `http://www.example.com/about`:

```html
...

<span>It is home page!</span> <!-- WTF? It's /about page -->
<span>It is about page!</span>

...
```

--

In order to understand what's happened let's think like `React Router 4`.

By default it checks if `path` property of `<Route ... />` equals

to `window.location` or is a sub of `window.location`.

<br />

For example, when visiting `http://www.example.com/one/two/three`:

```js
<Route path='/one'           ... /> // will be rendered
<Route path='/one/two'       ... /> // will be rendered
<Route path='/one/two/three' ... /> // will be rendered
```

<br />

In order to disable this super feature we can use `exact` flag:

```js
<Route exact path='/one'           ... /> // will be rendered only on /one
<Route exact path='/one/two'       ... /> // will be rendered only on /one/two
<Route exact path='/one/two/three' ... /> // will be rendered only on /one/two/three
```

---

Cool! Let's create links for our routes!

<br />

First of all, import `Link` from `react-router-dom` package:

```js
import { Link } from 'react-router-dom'
```

<br />

And create links for `Home` and `About` routes:

```js
const Header = () => (
  <div>
    <Link to='/'     >Home </Link>
    <Link to='/about'>About</Link>
  </div>
)
```

<br />

You can also use `replace` to replace the current entry in the history stack instead of adding a new one:

```js
// Let's imagine it's out history before clicking: / -> /abc

<Link to='/def'        >...</Link> // history after clicking: / -> /abc -> /def
<Link to='/def' replace>...</Link> // history after clicking: / -> /def
```

--

Cool! But we want beautiful links!

<br />

First of all, import `NavLink` from `react-router-dom` package:

```js
import { NavLink } from 'react-router-dom'
```

<br />

Replace your `Link`s with `NavLink`s:

```js
// appends 'active' class if window.location === '/a'
<NavLink to='/a' activeClassName='active'>...</NavLink>

// appends red color style if window.location === '/b'
<NavLink to='/b' activeStyle={{ color: 'red' }}>...</NavLink>

// callback for determining whether the link is active
<NavLink to='/c' isActive={() => ...}>...</NavLink>

// the same as for <Route exact ... />
<NavLink exact ... >...</NavLink>
```

---

Cool! But we need redirects!

<br />

First of all, import `Redirect` from `react-router-dom` package:

```js
import { Redirect } from 'react-router-dom'
```

<br />

Render `Redirect` to perform redirecting:

```js
...

render () {
  if (!this.props.user) {

    // if user is unauthorized,
    // then redirect to login page

    return <Redirect to='/signin' />
  }

  return <div>TOP SECRET...</div>
}

...
```

--

Import `Redirect` and `Switch` from `react-router-dom` package:

```js
import { Switch, Redirect } from 'react-router-dom'
```

<br />

Configure redirecting from `/old-path` to `/new-path`:

```js
<Switch>
  <Redirect from='/old-path' to='/new-path' />
  <Route path='/new-path' component={...} />
</Switch>
```

<br />

Use `push` flag to create new entry in the `History`:

```js
<Redirect from='/old-path' to='/new-path'      /> // history after redirecting: /home -> /new-path
<Redirect from='/old-path' to='/new-path' push /> // history after redirecting: /home -> /old-path -> /new-path
```

---

Cool. But we need 404 fallback!

<br />

Import `Switch` from 'react-router-dom' package:

```js
import { Switch } from 'react-router-dom'
```

<br />

And configure `Route` with fallback component:

```js
<Switch>
  <Route to='/a' component={...} />
  <Route to='/b' component={...} />
  <Route to='/c' component={...} />

  ...

  // Notice that fallback route should be the last one
  <Route component={() => '404 - Not Found'} />
</Switch>
```

---

Cool. But we want to control everything programmatically!

Add `react-router-redux` package to project dependencies:

<br />

To install with `yarn`, run:

```bash
yarn add react-router-redux@next
```

<br />

To install with `npm`, run:

```bash
npm install --save react-router-redux@next
```

--

Notify `Redux` store about new reducer:

<br />

```js
import { combineReducers } from 'redux'

import { routerReducer } from 'react-router-redux'

export default combineReducers({
  ..., router: routerReducer
})
```

--

Notify `Redux` store about new middleware:

```js
import { routerMiddleware as createRouterMiddleware } from 'react-router-redux'

...

const configureStore = history => {
  ...

  const routerMiddleware =
    createRouterMiddleware(
      history
    )

  const middlewares = applyMiddleware(
    ..., routerMiddleware, ...
  )

  ...
}
```

--

Update entry point of your application:

```js
import { createBrowserHistory } from 'history'
import { ConnectedRouter } from 'react-router-redux'

...

import { configureStore } from './redux-store'

const history = createHashHistory()
const store = configureStore(history)

...

ReactDOM.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Application />
    </ConnectedRouter>
  </Provider>,

  document.getElementById('app')
)

...
```

---

Dispatch `push` and `replace` actions:

```js
import { push, replace } from 'react-router-redux'

const Page = props => (
  <div>
    ...

    // acts as Link
    <button onClick={() => props.push('/abc')}>
      Click me!
    <button>

    // acts as Redirect
    <button onClick={() => props.replace('/abc')}>
      Click me!
    <button>

    ...
  </div>
)

const mapDispatchToProps = {
  push, replace
}

export default connect(null,)
```

--

Except `push` and `replace` feel free to use:

- `go` - Moves backwards or forwards a relative number of locations in history.

- `goBack` - Moves backwards one location. Equivalent to go(-1)

- `goForward` - Moves forward one location. Equivalent to go(1)
