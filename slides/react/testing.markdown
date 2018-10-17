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
import * as asyncActions from '../actions/TodoActions'
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

  return stubStore.dispatch(asyncActions.fetchTodoes()).then(() => {
    const actions = stubStore.getActions();
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

## Testing containers

* Testing lifecycle methods

* Testing maps state and dispatch to props

--

SignUp.js <!-- .element: class="filename" -->
```js
import React, { Component } from 'react'
import { connect } from 'react-redux'
import { checkAuthentication } from 'actions/authentication'
import SignUpForm from 'containers/auth/SignUpForm'


class SignUp extends Component {
  componentWillMount() {
    this.props.checkAuthentication()
  }

  render() {
    return (
      <div>
        <SignUpForm {...this.props} />
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  referral: state.referral
})

const mapDispatchToProps = {
  checkAuthentication
}

export default connect(mapStateToProps, mapDispatchToProps)(SignUp)
```

--

Testing lifecycle methods

```js
import React from 'react'
import { shallow } from 'enzyme'
import SignUp from 'containers/auth/SignUp'

describe('componentWillMount()', () => {
  const defaultProps = {
    checkAuthentication: jest.fn(),
  }

  it('calls checkAuthentication()', () => {
    const component = shallow(<SignUp {...defaultProps} />)
    component.instance().componentWillMount()

    expect(component.instance().checkAuthentication).toHaveBeenCalled()
  })
})
```

--

Testing maps state and dispatch to props

```js
import React from 'react'
import { shallow } from 'enzyme'
import configureStore from 'redux-mock-store'
import SignUp from 'containers/auth/SignUp'

it('maps state and dispatch to props', () => {
  const store = configureStore()({})
  const container = shallow(<SignUp store={store} />)

  expect(container.props()).toEqual(expect.objectContaining({
    checkAuthentication: expect.any(Function),
    referral: expect.any(String)
  }))
})
```

---

## Testing Reselect

--

[Reselect](https://github.com/reduxjs/reselect) is simple “selector” library for Redux (and others)

* Selectors can compute derived data, allowing Redux to store the minimal possible state.
* Selectors are efficient. A selector is not recomputed unless one of its arguments changes.
* Selectors are composable. They can be used as input to other selectors.

--

For a given input, a selector should always produce the same output. For this reason they are simple to unit test.

```js
const selector = createSelector(
  state => state.a,
  state => state.b,
  (a, b) => ({
    c: a * 2,
    d: b * 3
  })
)

test('selector unit test', () => {
  expect(selector({ a: 1, b: 2 })).toEqual({ c: 2, d: 6 })
  expect(selector({ a: 2, b: 3 })).toEqual({ c: 4, d: 9 })
})
```

--

It may also be useful to check that the memoization function for a selector works correctly with the state update function (i.e. the reducer if you are using Redux). Each selector has a `recomputations` method that will return the number of times it has been recomputed:

```js
suite('selector', () => {
  let state = { a: 1, b: 2 }

  const reducer = (state, action) => (
    {
      a: action(state.a),
      b: action(state.b)
    }
  )

  const selector = createSelector(
    state => state.a,
    state => state.b,
    (a, b) => ({
      c: a * 2,
      d: b * 3
    })
  )

  const plusOne = x => x + 1
  const id = x => x

  test('selector unit test', () => {
    state = reducer(state, plusOne)
    expect(selector(state)).toEqual({ c: 4, d: 9 })

    state = reducer(state, id)
    expect(selector(state)).toEqual({ c: 4, d: 9 })
    expect(selector.recomputations()).toEqual(1)

    state = reducer(state, plusOne)
    expect(selector(state)).toEqual({ c: 6, d: 12 })
    expect(selector.recomputations()).toEqual(2)
  })
})
```

--

Additionally, selectors keep a reference to the last result function as `.resultFunc`. If you have selectors composed of many other selectors this can help you test each selector without coupling all of your tests to the shape of your state.

--

For example if you have a set of selectors like this:

selectors.js <!-- .element: class="filename" -->
```js
export const firstSelector = createSelector( ... )
export const secondSelector = createSelector( ... )
export const thirdSelector = createSelector( ... )

export const myComposedSelector = createSelector(
  firstSelector,
  secondSelector,
  thirdSelector,
  (first, second, third) => first * second < third
)
```

--

And then a set of unit tests like this:

selectors.spec.js <!-- .element: class="filename" -->
```js
// tests for the first three selectors...
test('firstSelector unit test', () => { ... })
test('secondSelector unit test', () => { ... })
test('thirdSelector unit test', () => { ... })

// We have already tested the previous
// three selector outputs so we can just call `.resultFunc`
// with the values we want to test directly:
test('myComposedSelector unit test', () => {
  // here instead of calling selector()
  // we just call selector.resultFunc()
  expect(myComposedSelector.resultFunc(1, 2, 3)).toBeTruthy()
  expect(myComposedSelector.resultFunc(2, 2, 1)).toBeFalsy()
})
```

--

Finally, each selector has a `resetRecomputations` method that sets
recomputations back to 0.  The intended use is for a complex selector that may
have many independent tests and you don't want to manually manage the
computation count or create a "dummy" selector for each test.

---

## Production examples

--

### Action creators

--

src/actions/market.js <!-- .element: class="filename" -->

```js
import { GET_MARKET_CARDS, ADD_CARD_TO_MARKET, SET_MARKET_INITIAL_STATE, REQUEST } from 'constants/actions'

export function getMarketCards(params) {
  return { type: GET_MARKET_CARDS + REQUEST, params }
}

export function addCardToMarket(card) {
  return { type: ADD_CARD_TO_MARKET, card }
}

export function setMarketInitialState() {
  return { type: SET_MARKET_INITIAL_STATE }
}
```

--

src/actions/\__tests\__/market.spec.js <!-- .element: class="filename" -->

```js
import { addCardToMarket, getMarketCards, setMarketInitialState } from 'actions/market'

describe('Market actions', () => {
  it('creates an action to get cards', () => {
    const expectedAction = { type: 'GET_MARKET_CARDS_REQUEST' }

    expect(getMarketCards()).toEqual(expectedAction)
  })

  it('creates an action to add card', () => {
    const expectedAction = { type: 'ADD_CARD_TO_MARKET' }

    expect(addCardToMarket()).toEqual(expectedAction)
  })

  it('creates an action to reset market to initial state', () => {
    const expectedAction = { type: 'SET_MARKET_INITIAL_STATE' }

    expect(setMarketInitialState()).toEqual(expectedAction)
  })
})
```

--

### Selectors

--

src/selectors/page.js <!-- .element: class="filename" -->

```js
import { createSelector } from 'reselect'

export const getPages = (state) => state.entities.pages || {}
export const getPagesIds = (state) => state.pages.list || []

export const getInvitersPages = createSelector(
  getPagesIds,
  getPages,
  (pagesIds, pages) => (pagesIds ? pagesIds.map((id) => (pages[id])) : [])
)

export const getPagesInvitersOptions = createSelector(
  getInvitersPages,
  (invitersPages) => invitersPages.map((invitersPage) => (
    {
      label: invitersPage.mediaName,
      value: invitersPage.id,
      avatarUrl: invitersPage.profileImageSmall
    }
  ))
)
```

--

src/selectors/\__tests\__/page.spec.js <!-- .element: class="filename" -->

```js
import { getPages, getPagesIds, getInvitersPages, getPagesInvitersOptions } from 'selectors/page'

describe('pages selector', () => {
  const state = {
    pages: {
      list: ['1']
    },
    entities: {
      pages: {
        1: { id: '1', type: 'pages', mediaName: 'media-name', profileImageSmall: 'image.jpg' },
        2: { id: '2', type: 'pages', mediaName: 'media-name-2', profileImageSmall: 'image2.jpg' }
      }
    }
  }

  it('returns all pages', () => {
    expect(getPages(state)).toEqual(state.entities.pages)
  })

  it('returns pages ids', () => {
    expect(getPagesIds(state)).toEqual(state.pages.list)
  })

  it('returns array of pages by ids', () => {
    expect(getInvitersPages(state)).toEqual([state.entities.pages[1]])
  })

  it('returns pages options for select', () => {
    const { 1: selectedPage } = state.entities.pages

    const expectedOptions = [{
      label: selectedPage.mediaName,
      value: selectedPage.id,
      avatarUrl: selectedPage.profileImageSmall
    }]

    expect(getPagesInvitersOptions(state)).toEqual(expectedOptions)
  })
})
```

--

### Reducers

--

src/reducers/history.js <!-- .element: class="filename" -->

```js
import { GET_HISTORY_CARDS, SET_HISTORY_INITIAL_STATE, REQUEST, SUCCESS, ERROR } from 'constants/actions'

const initialState = {
  cards: [],
  loading: false,
  page: 0,
  hasMore: true
}

export default function history(state = initialState, action) {
  const { type, results, params } = action

  switch (type) {
    case SET_HISTORY_INITIAL_STATE: return { ...state, ...initialState }
    case GET_HISTORY_CARDS + REQUEST: return { ...state, loading: true, page: params.page }
    case GET_HISTORY_CARDS + ERROR: return { ...state, loading: false, hasMore: false }
    case GET_HISTORY_CARDS + SUCCESS: {
      const cards = results.cards || []

      return {
        ...state,
        cards: [...new Set([...state.cards, ...cards])],
        loading: false,
        page: state.page,
        hasMore: cards.length !== 0
      }
    }
    default: return state
  }
}
```

--

src/reducers/\__tests\__/history.spec.js <!-- .element: class="filename" -->

```js
import history from 'reducers/history'

describe('History reducer', () => {
  it('has an initial state', () => {
    expect(history(undefined, { type: 'unexpected' })).toEqual({
      cards: [],
      loading: false,
      page: 0,
      hasMore: true
    })
  })

  it('can handle GET_HISTORY_CARDS_REQUEST', () => {
    const params = { page: 0 }

    expect(history(undefined, { type: 'GET_HISTORY_CARDS_REQUEST', params })).toEqual({
      cards: [],
      loading: true,
      page: 0,
      hasMore: true
    })
  })

  it('can handle GET_HISTORY_CARDS_SUCCESS', () => {
    const results = {
      cards: [1, 2, 3]
    }

    expect(history(undefined, { type: 'GET_HISTORY_CARDS_SUCCESS', results })).toEqual({
      cards: [1, 2, 3],
      loading: false,
      page: 0,
      hasMore: true
    })
  })

  it('can handle GET_HISTORY_CARDS_ERROR', () => {
    expect(history(undefined, { type: 'GET_HISTORY_CARDS_ERROR' })).toEqual({
      cards: [],
      loading: false,
      page: 0,
      hasMore: false
    })
  })

  it('can handle SET_HISTORY_INITIAL_STATE', () => {
    const initialState = {
      cards: [1, 2, 3],
      loading: true,
      page: 1480,
      hasMore: false
    }

    const action = {
      type: 'SET_HISTORY_INITIAL_STATE'
    }

    expect(history(initialState, action)).toEqual({
      cards: [],
      loading: false,
      page: 0,
      hasMore: true
    })
  })
})
```

--

### Containers

--

src/views/Stores/container.js <!-- .element: class="filename" -->

```js
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { showModal } from 'state/modal/actions';
import StoresComponent from './component';

class Stores extends React.Component {
  handleToggleCreateStoreModal = () => {
    this.props.showModal({ modalType: 'CREATE_STORE' });
  };

  render() {
    return (
      <StoresComponent
        {...this.props}
        handleToggleCreateStoreModal={this.handleToggleCreateStoreModal}
      />
    );
  }
}

Stores.defaultProps = {
  isStoresPresent: null,
};

Stores.propTypes = {
  isStoresPresent: PropTypes.bool,
  showModal: PropTypes.func.isRequired,
};

const mapStateToProps = state => ({
  isStoresPresent: state.stores.isStoresPresent,
});

const mapDispatchToProps = {
  showModal,
};

export { Stores as StoresContainer };
export default connect(mapStateToProps, mapDispatchToProps)(Stores);
```

--

src/views/Stores/\__tests\__/container.spec.js <!-- .element: class="filename" -->

```js
import React from 'react';
import { shallow } from 'enzyme';
import configureStore from 'redux-mock-store';
import diveTo from 'utils/testHelpers/diveToEnzyme';
import { showModal } from 'state/modal/actions';
import StoresWrapped, { StoresContainer } from '../container';

jest.mock('state/modal/actions', () => ({
  showModal: jest.fn(),
}));

describe('Stores container', () => {
  const store = configureStore()({
    stores: {
      isStoresPresent: true,
    },
  });
  store.dispatch = jest.fn();

  const wrapper = shallow(<StoresWrapped store={store} history={{}} />);
  const container = diveTo(wrapper, StoresContainer);
  const instance = container.instance();

  it('renders Stores component', () => {
    expect(container).toMatchSnapshot();
  });

  it('map state and dispatch to props', () => {
    expect(instance.props).toEqual(expect.objectContaining({
      isStoresPresent: expect.any(Boolean),
    }));
  });

  it('handleToggleCreateStoreModal()', () => {
    instance.handleToggleCreateStoreModal();
    expect(showModal).toHaveBeenCalledWith({ modalType: 'CREATE_STORE' });
  });
});
```

--

### Side effects (Sagas)

--

src/sagas/users.js <!-- .element: class="filename" -->

```js
import axios from 'axios'
import { normalize } from 'normalize-json-api'
import { takeEvery, call, put } from 'redux-saga/effects'
import { LOAD_USERS, REQUEST, SUCCESS } from 'constants/actions'

export function* loadUsers({ params, resolve, reject }) {
  try {
    const response = yield call(axios.get, '/api/mobile/users', params)
    const { entities, results } = yield call(normalize, response.data)
    yield put({ type: LOAD_USERS + SUCCESS, entities, users: results.users })
    yield call(resolve)
  } catch (error) {
    yield call(reject, error)
  }
}

export default function* watchLoadUsers() {
  yield takeEvery(LOAD_USERS + REQUEST, loadUsers)
}
```

--

src/sagas/\__tests\__/users.spec.js <!-- .element: class="filename" -->

```ruby
jest.mock('responses/users')

import axios from 'axios'
import { normalize } from 'normalize-json-api'
import { call, put } from 'redux-saga/effects'
import { loadUsers } from 'sagas/users'
import { response } from 'responses/users'

describe('loadUsers()', () => {
  const params = { params: {} }
  const resolve = jest.fn()
  const reject = jest.fn()

  it('is success', () => {
    const saga = loadUsers({ params, resolve, reject })

    expect(saga.next().value).toEqual(
      call(axios.get, '/api/mobile/users', params)
    )

    expect(saga.next({ data: response }).value).toEqual(
      call(normalize, response)
    )

    const normalizedResponse = normalize(response)

    expect(saga.next(normalizedResponse).value).toEqual(
      put({
        type: 'LOAD_USERS_SUCCESS',
        entities: normalizedResponse.entities,
        users: normalizedResponse.results.users
      })
    )

    expect(saga.next().value).toEqual(
      call(resolve)
    )

    expect(saga.next().done).toBe(true)
  })

  it('is failure', () => {
    const saga = loadUsers({ params, resolve, reject })
    const error = new Error('Unexpected Network Error')

    expect(saga.next().value).toEqual(
      call(axios.get, '/api/mobile/users', params)
    )

    expect(saga.throw(error).value).toEqual(
      call(reject, error)
    )

    expect(saga.next().done).toBe(true)
  })
})
```

--

src/sagas/\__mocks\__/responses/users.js <!-- .element: class="filename" -->

```js
export const response = {
  data: {
    attributes: {
      email: 'dmitriy.grechukha@gmail.com',
      profileImageBig: '/uploads/attachable/profile_image/file/1367/big_4f9c3f52-3b40-49e0-8a74-43e0415181e3.jpg',
      profileImageSmall: '/uploads/attachable/profile_image/file/1367/small_4f9c3f52-3b40-49e0-8a74-43e0415181e3.jpg',
      provider: 'twitter',
      uid: '141283971',
      username: 'timlar'
    },
    id: '319',
    relationships: {
      profileCard: {
        data: {
          id: '1285',
          type: 'profileCards'
        }
      },
      roles: {
        data: [
          {
            id: '3',
            type: 'roles'
          }
        ]
      }
    },
    type: 'users'
  },
  included: [
    {
      attributes: {
        name: 'merchant',
        title: 'Merchant'
      },
      id: '3',
      type: 'roles'
    },
    {
      id: '1285',
      relationships: {
        profileData: {
          data: {
            id: '344',
            type: 'profileDatas'
          }
        }
      },
      type: 'profileCards'
    },
    {
      attributes: {
        fullname: 'timlar'
      },
      id: '344',
      type: 'profileDatas'
    }
  ]
}
```

--

### Side effects (Redux Logic)

--

src/state/concepts/storeOnboarding/operations.js <!-- .element: class="filename" -->

```js
import { createLogic } from 'redux-logic';
import { mapKeys, camelCase } from 'lodash';
import * as types from './types';
import { setOnboarding } from './actions';

export const getOnboardingOperation = createLogic({
  type: types.GET_ONBOARDING,
  latest: true,

  async process({ httpClient, getState }, dispatch, done) {
    const state = getState();
    const { activeStore } = state.stores;
    const url = `/account/stores/${activeStore}/onboarding`;
    const data = await httpClient.get(url).then(resp => resp.data);

    dispatch(setOnboarding(mapKeys(data.data.attributes, ((_, key) => camelCase(key)))));
    done();
  },
});

export const changeOnboardingOperation = createLogic({
  type: types.CHANGE_ONBOARDING,
  latest: true,

  async process({ httpClient, getState }, dispatch, done) {
    const state = getState();
    const { activeStore } = state.stores;
    const { onboarding } = state;
    const params = {
      onboarding: {
        connect_to_wp_settings_visible: onboarding.connectToWpSettings.visible,
        shipping_settings_visible: onboarding.shippingSettings.visible,
        tax_settings_visible: onboarding.taxSettings.visible,
        email_settings_visible: onboarding.emailSettings.visible,
        checkout_settings_visible: onboarding.checkoutSettings.visible,
        transfer_ownership_settings_visible: onboarding.transferOwnershipSettings.visible,
        payment_settings_visible: onboarding.paymentSettings.visible,
      },
    };
    const url = `/account/stores/${activeStore}/onboarding`;

    await httpClient.patch(url, params);

    done();
  },
});

export default [
  getOnboardingOperation,
  changeOnboardingOperation,
];
```

--

src/state/concepts/storeOnboarding/\__tests\__/operations.spec.js <!-- .element: class="filename" -->

```js
import * as operations from 'concepts/storeOnboarding/operations';
import httpClientMock from 'utils/testHelpers/httpClientMock';
import onboardingResponse from 'concepts/storeOnboarding/__mocks__/storeOnboardingResponses';
import onboardingState from 'concepts/storeOnboarding/__mocks__/storeOnboardingResponses';

let dispatch;

describe('getOnboardingOperation', () => {
  describe('success', () => {
    beforeEach((done) => {
      const httpClient = httpClientMock({ method: 'get', response: { data: onboardingResponse } });
      const getState = jest.fn();

      getState.mockReturnValue({
        onboarding: null,
        stores: {
          activeStore: '1',
        },
      });
      dispatch = jest.fn(() => done());
      operations.getOnboardingOperation.process({ httpClient, getState }, dispatch, done);
    });

    it('dispatches action onboarding/SET_ONBOARDING', () => {
      expect(dispatch.mock.calls.length).toBe(1);

      expect(dispatch.mock.calls[0][0]).toEqual({
        type: 'onboarding/SET_ONBOARDING',
        payload: {
          checkoutSettings: {
            completed: true,
            visible: true,
          },
          connectToWpSettings: {
            visible: true,
          },
          emailSettings: {
            completed: false,
            visible: true,
          },
          paymentSettings: {
            completed: false,
            visible: true,
          },
          shippingSettings: {
            completed: true,
            visible: true,
          },
          taxSettings: {
            completed: true,
            visible: true,
          },
          transferOwnershipSettings: {
            visible: true,
          },
        },
      });
    });
  });
});

describe('changeOnboardingOperation', () => {
  describe('success', () => {
    const mockedDone = jest.fn();

    beforeEach(() => {
      const httpClient = httpClientMock({ method: 'patch', response: { data: {} } });
      const getState = jest.fn();

      getState.mockReturnValue({
        ...onboardingState,
        stores: {
          activeStore: '1',
        },
      });
      dispatch = jest.fn();
      operations.changeOnboardingOperation.process({ httpClient, getState }, dispatch, mockedDone);
    });

    it('calls done()', () => {
      expect(mockedDone.mock.calls.length).toBe(1);
    });
  });
});
```

--

src/state/concepts/storeOnboarding/\__mocks\__/storeOnboardingResponses.js <!-- .element: class="filename" -->

```js
const onboardingResponse = {
  data: {
    attributes: {
      'checkout-settings': {
        completed: true,
        visible: true,
      },
      'connect-to-wp-settings': {
        visible: true,
      },
      'email-settings': {
        completed: false,
        visible: true,
      },
      'payment-settings': {
        completed: false,
        visible: true,
      },
      'shipping-settings': {
        completed: true,
        visible: true,
      },
      'tax-settings': {
        completed: true,
        visible: true,
      },
      'transfer-ownership-settings': {
        visible: true,
      },
    },
    id: '1',
    type: 'onboarding-settings',
  },
};

export default onboardingResponse;
```

--

src/state/concepts/storeOnboarding/\__mocks\__/onboardingState.js <!-- .element: class="filename" -->

```js
const onboardingState = {
  onboarding: {
    connectToWpSettings: { visible: true },
    shippingSettings: { visible: true, completed: false },
    taxSettings: { visible: true, completed: false },
    emailSettings: { visible: true, completed: false },
    checkoutSettings: { visible: true, completed: false },
    paymentSettings: { visible: true, completed: false },
    transferOwnershipSettings: { visible: true },
  },
};

export default onboardingState;
```

src/utils/testHelpers/httpClientMock.js <!-- .element: class="filename" -->

```js
const httpClientMock = ({ method, response, reject } = { reject: false }) => ({
  [method]: () => new Promise((resolve, deny) => {
    if (reject) {
      deny(response);
    } else {
      resolve(response);
    }
  }),
});

export default httpClientMock;
```

---

# The End
