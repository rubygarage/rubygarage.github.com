---
layout: slide
title: Testing
---

# Testing React Apps

---

## Tools

* [Jest](https://facebook.github.io/jest/) - Unit and snapshot testing framework.

* [Enzyme](http://airbnb.io/enzyme/) - Convenient utilities to work

with shallow rendering,
static rendered markup or DOM rendering.

---

## Installing

--

## Jest

[Create React App](https://github.com/facebookincubator/create-react-app) already ships with jest pre-configured.

--

App.js <!-- .element: class="filename" -->
```js
import React, { Component } from 'react'

class App extends Component {
  render() {
    return (
      <div>
        <h1>Welcome to React Testing</h1>
      </div>
    );
  }
}

export default App;
```

--

App.test.js <!-- .element: class="filename" -->
```js
import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
});
```

When you run `npm test`, Jest will launch in the watch mode.

--

## Filename Conventions

Jest will look for test files with any of the following popular naming conventions:

* Files with `.js` suffix in `__tests__` folders.
* Files with `.test.js` suffix.
* Files with `.spec.js` suffix.

The `.test.js` / `.spec.js` files (or the `__tests__` folders)

can be located at any depth under the src top level folder.

--

## Configuring Jest

jest.config.js <!-- .element: class="filename" -->
```js
module.exports = {
  verbose: true,
  moduleDirectories: [
    "node_modules",
    "src"
  ],
  testPathIgnorePatterns: [
    "<rootDir>/node_modules/"
  ],
  setupFiles: [
    "<rootDir>/__test__/setupTest.js"
  ],
  testRegex: "(/__test__/.*|\\.(test|spec))\\.js",
  moduleFileExtensions: [
    "js",
    "json",
    "jsx"
  ]
}
```
Jest configuration [documentation](https://facebook.github.io/jest/docs/en/configuration.html)
--

## Enzyme

```bash
npm install --save-dev enzyme enzyme-to-json jest-enzyme
```

[enzyme-to-json](https://github.com/adriantoine/enzyme-to-json) - convert Enzyme wrappers for Jest snapshot matcher

[jest-enzyme](https://github.com/blainekasten/enzyme-matchers) - helpful view matchers to simplify tests

--

Import it in `setupTests.js` to make `jest-enzyme` matchers available in every test

setupTests.js <!-- .element: class="filename" -->
```js
import 'jest-enzyme';
```

--

App.test.js <!-- .element: class="filename" -->
```js
import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'
import toJson from 'enzyme-to-json'
import renderer from 'react-test-renderer'

describe('Component: App', () => {
  it('should match its snapshot', () => {
    const tree = renderer.create(
      <App />
     ).toJSON();

    expect(tree).toMatchSnapshot();
  });
});
```

`expect(tree).toMatchSnapshot();` will generate a snapshot in a separate folder `__snapshots__`

where we have a file `App.test.js.snap` which stores our component output.

--

App.test.js.snap <!-- .element: class="filename" -->
```
exports[`Component: App should match its empty snapshot 1`] = `
<div>
  <h1>
    Welcome to React Testing
  </h1>
</div>
`;
```

--

To update snapshot use should run `npm test -- -u` or type `u` into watch mode

---

## Unit testing

Jest uses "matchers" to let you test values in different ways.

--

## Type Matches

```js
test('null', () => {
  const value = null;
  expect(value).toBeNull();
  expect(value).toBeDefined();
  expect(value).not.toBeUndefined();
  expect(value).not.toBeTruthy();
  expect(value).toBeFalsy();
});
```

--

## Numbers

```js
test('two plus two', () => {
  const value = 2 + 2;
  expect(value).toBeGreaterThan(3);
  expect(value).toBeGreaterThanOrEqual(3.5);
  expect(value).toBeLessThan(5);
  expect(value).toBeLessThanOrEqual(4.5);

  // toBe and toEqual are equivalent for numbers
  expect(value).toBe(4);
  expect(value).toEqual(4);
});
```

--

## String

```js
const apple1 = {
  name: 'product',
  weight: 12,
};
const apple2 = {
  name: 'product',
  weight: 12,
};

describe('two apples', () => {
  it('have all the same properties', () => {
    expect(apple1).toEqual(apple2);
  });
  it('are not the exact same apple', () => {
    expect(apple1).not.toBe(apple2);
  });
});
```

--

You can check strings against regular expressions with `toMatch`

```js
it('string testing example', () => {
  expect('string testing example').toMatch(/testing/);
});
```

--

## Array

```js
const shoppingList = [
  'bananas',
  'trash bags',
  'sauce',
];

it('the shopping list has bananas on it', () => {
  expect(shoppingList).toContain('bananas');
});
```

[Matchers docs](https://facebook.github.io/jest/docs/en/expect.html)

---

## Testing Asynchronous Code

Jest has several ways to handle code that runs asynchronously.

--

## ```Done``` callback
Jest will wait until the ```done``` callback is called before finishing the test.

```js
test('the data is shopping list', done => {
  callback = (data) => {
    expect(data).toBe('shopping list');
    done();
  }

  asyncAction(callback);
});
```

--

If the function accepts a done parameter and  ```done()``` is never called

```js
it('works synchronously', done => {
  expect(1).toBeGreaterThan(0);
})
```

the test will fail, which is what you want to happen

```bash
  ● Moxios › works synchronously

    Timeout - Async callback was not invoked within the 5000ms timeout specified by jest.setTimeout.

      at node_modules/jest-jasmine2/build/queue_runner.js:72:21
      at Timeout.callback [as _onTimeout] (node_modules/jsdom/lib/jsdom/browser/Window.js:633:19)
```

--

## Matchers

You can also use the ```.resolves``` or ```.rejects``` matcher in your expect statement, and Jest will wait for that promise to resolve/rejected

.resolves
```js
test('the fetch data with shopping list', () => {
  expect.assertions(1);
  expect(fetchShoppingList()).resolves.toBe('shopping list');
});
```

.rejects
```js
test('the fetch fails with an error', () => {
  expect.assertions(1);
  expect(fetchData()).rejects.toMatch('error');
});
```
---

## Testing components

* Testing props

* Testing browser events

* Testing event handlers

Enzyme kinds of rendering

* Shallow rendering

* Full Rendering

* Static Rendering

--

## Shallow Rendering

Lets you instantiate a component and effectively get the result of its.

Render method just a single level deep instead of rendering components recursively to a DOM.


[Shallow Rendering API](http://airbnb.io/enzyme/docs/api/shallow.html)

--

App.test.js <!-- .element: class="filename" -->
```js
import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'
import toJson from 'enzyme-to-json'
import { shallow } from 'enzyme'
import renderer from 'react-test-renderer'

describe('Component: App Shallow Rendering', () => {
  it('should match snapshot and have headline', () => {
    const wrapper = shallow(<App />);
    expect(wrapper).toMatchSnapshot();

    expect(wrapper.find('h1').text()).toEqual('Welcome to React Testing');
  });
});
```

--

## Full Rendering

Sometimes you want to interact with an element in a child component to test effect in your component.

For that you need a proper DOM rendering with Enzyme’s mount method.

[Full Rendering API](http://airbnb.io/enzyme/docs/api/mount.html)

--

```js
// ...
import toJson from 'enzyme-to-json'
import { mount } from 'enzyme'

it('should render a document title', () => {
  const wrapper = mount(<App />);
  expect(toJson(wrapper)).toMatchSnapshot();
});
// ...
```

--

## Static Rendering

Enzyme's render function is used to `render` react components to static HTML

and analyze the resulting HTML structure.

`render` uses a third party HTML parsing and traversal library [Cheerio](https://cheerio.js.org/).

[Static Rendering API](http://airbnb.io/enzyme/docs/api/render.html)

--

```js
// ...
import { render } from 'enzyme'

const wrapper = render(<App />);
expect(wrapper).toMatchSnapshot();
// ...
```

--

## Testing props

Sometimes you want to be more explicit and see real values in tests.

In that case use Enzyme API with regular Jest assertions

```js
it('should render a document title', () => {
  const wrapper = shallow(
    <DocumentTitle title="Events" />
  );

  expect(wrapper.prop('title')).toEqual('Events');
});
```

--

## Testing events

You can simulate an event like click or change and then compare component to a snapshot

```js
// imports...

class Foo extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }
  render() {
    const { count } = this.state;
    return (
      <div>
        <div className={`clicks-${count}`}>
          {count} clicks
        </div>
        <a href="url" onClick={() => { this.setState({ count: count + 1 }); }}>
          Increment
        </a>
      </div>
    );
  }
}
```

```js
// imports...

it('should change counter', () => {
  const wrapper = shallow(<Foo />);

  expect(wrapper.find('.clicks-0').length).to.equal(1);
  wrapper.find('a').simulate('click');
  expect(wrapper.find('.clicks-1').length).to.equal(1);
});
```
--

## Testing event handlers

Similar to events testing but instead of testing component’s rendered

output with a snapshot use Jest’s [mock](https://facebook.github.io/jest/docs/en/mock-function-api.html) function to test an event handler itself

```js
it('should pass a selected value to the onChange handler', () => {
  const onChange = jest.fn();
  const wrapper = shallow(
    <SomeComponent items={ITEMS} onChange={onChange} />
  );

  expect(wrapper).toMatchSnapshot();

  wrapper.find('select').simulate('change', {
    target: { '5' },
  });

  expect(onChange).toBeCalledWith('5');
});
```

---

## Testing Redux

--

## Actions

In Redux, action creators are functions which return plain objects.

When testing action creators we want to test whether the correct action creator

was called and also whether the right action was returned.

```js
export function addTodo(text) {
  return {
    type: 'ADD_TODO',
    text
  }
}
```

--

```js
import * as actions from '../actions/TodoActions'
import * as types from '../constants/ActionTypes'

describe('actions', () => {
  it('should create an action to add a todo', () => {
    const text = 'Example'
    const expectedAction = {
      type: types.ADD_TODO,
      text
    }
    expect(actions.addTodo(text)).toEqual(expectedAction)
  })
})
```

--

## Asynchronous Actions

For async action creators using [redux-thunk](https://github.com/gaearon/redux-thunk) or other middleware, it's best to completely mock the Redux store for tests.

You can also use [axios-mock-adapter](https://github.com/ctimmerm/axios-mock-adapter) to mock the HTTP requests called by [axios](https://github.com/axios/axios).

--

```js
import thunk from 'redux-thunk';
import axios from 'axios';
import configureMockStore from 'redux-mock-store';
import MockAdapter from 'axios-mock-adapter';

it('fetch todoes', () => {
  const axiosMock = new MockAdapter(axios);
  const stubStore = mockStore(configureMockStore([thunk]));
  const TODOES = [
    {
      id: 1,
      text: 'Buy bananas',
    }
  ];

  axiosMock.onGet('/todoes').reply(200, TODOES);

  const expectedActions = [
    { type: types.TODO_LIST + types.REQUEST },
    { type: types.TODO_LIST + types.SUCCESS, payload: { data: TODOES } },
  ];

  return stubStore.dispatch(actions.ferchTodoes()).then(() => {
    expect(actions).toEqual(expectedActions);
});
```

--

## Reducers

A reducer should return the new state after applying the action to the previous state.

```js
import { ADD_TODO } from '../constants/ActionTypes'

const initialState = [
  {
    text: 'Redux Testing',
    id: 0
  }
]

export default function todos(state = initialState, action) {
  switch (action.type) {
    case ADD_TODO:
      return [
        {
          id: state.reduce((maxId, todo) => Math.max(todo.id, maxId), -1) + 1,
          text: action.text
        },
        ...state
      ]

    default:
      return state
  }
}
```

--

Testing initial state

```js
import reducer from '../reducers/todos'

describe('todos reducer', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual([
      {
        text: 'Redux Testing',
        id: 0
      }
    ])
  })
})
```

--

Testing of new state returning

```js
import reducer from '../reducers/todos'
import * as types from '../constants/ActionTypes'

describe('todos reducer', () => {
  it('should returns new state', () => {
    expect(
      reducer(
        [
          {
            text: 'Redux Testing',
            id: 0
          }
        ],
        {
          type: types.ADD_TODO,
          text: 'Run the tests'
        }
      )
    ).toEqual([
      {
        text: 'Run the tests',
        id: 1
      },
      {
        text: 'Redux Testing',
        id: 0
      }
    ])
  })
})
```

---

# The End
