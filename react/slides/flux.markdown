---
layout: slide
title:  Flux

---
# Flux
![](/assets/images/react/flux/logo.png)

---
### Flux is a pattern, that was created at Facebook, with main goal to 
### simplify state management inside client side applications.
#### (Not really new idea, rather combination of some existing patterns)

---
# State
- **Domain** <small>(Artilces, Comments, Likes)</small>
- **Application** <small>(Session, Connections, Is Something Enabled)</small>
- **Operation** <small>(In Progress, Success, Fail)</small>

---
## Can we avoid state management? No.
![](/assets/images/react/flux/haskell_vs_c.png)

---
# Why do we need Flux?
### Let's do a small trip to the past.
### A long time ago in a galaxy not so far away...

---
# Typical js app 10 years ago
```javascript
$(document).ready(function() {
  $('#slider').awesomeSlider();

  $('#tabs').awesomeTabs();

  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('#scrollTop').fadeIn();
    } else {
      $('#scrollTop').fadeOut();
    }
  });

  $('#scrollTop').click(function() {
    $('html, body').animate({
      scrollTop : 0
    }, 800);

    return false;
  });
});
```

---
# Jquery noodles
```javascript
(function($){
  $('.wish-list .wish-add').on('click', function() {
    var name =  $('.wish-list input[name="name"]').val();
    var price =  parseFloat($('.wish-list input[name="price"]').val());

    var sum = $('.wish-list .wish-list-sum').text();
    sum = sum ? parseFloat(sum) : 0;
    sum += price;

    $('.wish-list .wish-list-items').append('<li>' + (name - price) + '<a data-price="' + price + '" class="wish-remove" href="#">(remove)</a></li>');
    $('.wish-list .wish-list-sum').html(sum);
  });

  $('.wish-list .wish-list-items').on('click', '.wish-remove', function() {
    var price = $(this).data('price');
    var sum = parseFloat($('.wish-list-sum').text()) - price;

    $(this).parent().remove();
    $('.wish-list .wish-list-sum').text(sum);
  });
})(jQuery);
```

---
# Module pattern
```javascript
var Counter = (function () {
	var public = {};

	var _value = 0;
	var _$counter = $('#counter');

	function _render() {
		$counter.text(_value);
	}

	public.increment = function increment() {
		_value++;
		_render();
	};

	public.decrement = function decrement() {
		_value--;
		_render();
	};

	public.isDecrementDisabled = function() {
		return _value === 0;
	};

	return public;
}());
```

---
# Knockout
```javascript
var CounterVM = function() {
	this.value = ko.observable(0);

	this.increment = function increment() {
		this.value(this.value() + 1);
	};
	
	this.decrement = function decrement() {
		this.value(this.value() - 1);
	};
	
	this.isDecrementDisabled = ko.computed(function() {
			return this.value() === 0;
	}, this);
};
 
ko.applyBindings(new CounterVM());
```

```html
<div>
	<span data-bind='text: value'></span>

	<button data-bind='click: increment'>
		Increment
	</button>

	<button data-bind='click: decrement, disable: isDecrementDisabled'>
		Decrement
	</button>
</div>
```

---
# Angular
```javascript
angular.controller('CounterCtrl', function () {
	this.value = 0;

	this.increment = function increment() {
		this.value++;
	};

	this.decrement = function decrement() {
		this.value--;
	};

	this.isDecrementDisabled = function() {
		return this.value === 0;
	};
});
```

```html
<div ng-controller="CounterCtrl as counter">
	<span>{{ counter.value }}</span>

	<button ng-click="counter.increment()">
		Increment
	</button>

	<button ng-click="counter.decrement()" ng-disabled="counter.isDecrementDisabled()">
		Decrement
	</button>
</div>
```

---
# Problems
- State is spread across the application
- State is mutable across the application
- Handlers make decisions about state changes
- Unexpected effects caused by cascading updates

---
# State layer as solution
## (aka services)
- ~~State is spread across the application~~
- ~~State is mutable across the application~~
- Handlers make decisions about state changes
- Unexpected effects caused by cascading updates

---
# Flux to the rescue
- State is separated from view/view model layer
- State mutations is separated from view/view model layer
- State is responsible for making decisions about mutations based on events
- Unidirectional data flow

![](/assets/images/react/flux/scheme.png)

---
# Core Parts
- ### View
- ### Action
- ### Store
- ### Dispatcher

---
# View
- Listens for store's change events
- Sends actions to dispatcher

---
# Action
- Represents application changes

---
# Store
- Keeps aplicaiton state
- Registers itself in the dispatcher
- Updates state based on actions from dispatcher
- Emits change event for subscribed views

---
# Dispatcher
- Sends actions to all registered stores

---
# Yet Another Counter Example 

---
```javascript
import React from 'react';
import Counter from './counter';

const App = () => (
  <div className="app">
    <Counter />
  </div>
);

export default App;
```

```javascript
import React, { Component } from 'react';

class Counter extends Component {
  constructor(props) {
    super(props);

    this.increment = this.increment.bind(this);
    this.decrement = this.decrement.bind(this);

    this.state = {
      value: 0
    };
  }

  increment() {
    this.setState({
      value: this.state.value + 1
    });
  }

  decrement() {
    this.setState({
      value: this.state.value - 1
    });
  }

  render() {
    return (
      <div className="counter">
        <div>{this.state.value}</div>

        <button onClick={this.increment}>Increment</button>
        <button onClick={this.decrement}>Decrement</button>
      </div>
    );
  }
}

export default Counter;
```

---
# Requirements 
Share counter value in other parts of the appplication
## (ಥ﹏ಥ)

---
# Solution 
Let's implement Flux pattern
## \ (•◡•) /

---
# Disclaimer
### I think this is the least possible Flux implementation. 
### So don't copypaste code that you will see in production.

---
```javascript
class Dispatcher {
  constructor() {
    this._callbacks = [];
  }

  register(store) {
    this._callbacks.push(
      store.handle.bind(store)
    );
  }

  dispatch(action) {
    this._callbacks.forEach((callback) => callback(action));
  }
}

export default new Dispatcher;
```

---
```javascript
export const COUNTER_INCREMENT = 'COUNTER_INCREMENT';
export const COUNTER_DECREMENT = 'COUNTER_DECREMENT';
```

```javascript
import { COUNTER_INCREMENT, COUNTER_DECREMENT } from './types';

export const increment = () => ({
  type: COUNTER_INCREMENT
});

export const decrement = () => ({
  type: COUNTER_DECREMENT
});
```

---
```javascript
import { EventEmitter } from 'events';
import Dispatcher from './dispatcher';
import { COUNTER_INCREMENT, COUNTER_DECREMENT } from './types';

const CounterStore = Object.assign({}, EventEmitter.prototype, {
  value: 0,

  handle(action) {
    switch (action.type) {
      case COUNTER_INCREMENT:
        this.value++;
        break;
      case COUNTER_DECREMENT:
        this.value--;
        break;
      default:
        break;
    }

    this.emit('change');
  }
});

Dispatcher.register(CounterStore);

export default CounterStore;
```

---
```javascript
import React, { Component } from 'react';
import Counter from './counter';
import OtherPlace from './other_place'
import CounterStore from './counter_store';

const getAppState = () => ({
  counterValue: CounterStore.value
});

class App extends Component {
  constructor(props) {
    super(props);

    this.state = getAppState();

    this.handleChange = this.handleChange.bind(this);
  }

  componentDidMount() {
    CounterStore.on('change', this.handleChange);
  }

  componentWillUnmount() {
    CounterStore.off('change', this.handleChange);
  }

  handleChange() {
    this.setState(
      getAppState()
    );
  }

  render() {
    return (
      <div className="app">
        <Counter value={this.state.counterValue} />
        <br />
        <OtherPlace value={this.state.counterValue} />
      </div>
    );
  }
}

export default App;
```

---
```javascript
import React, { Component } from 'react';
import { increment, decrement } from './counter_actions';
import Dispatcher from './dispatcher';

class Counter extends Component {
  increment() {
    Dispatcher.dispatch(
      increment()
    );
  }

  decrement() {
    Dispatcher.dispatch(
      decrement()
    );
  }

  render() {
    return (
      <div className="counter">
        <div>{this.props.value}</div>

        <button onClick={this.increment}>Increment</button>
        <button onClick={this.decrement}>Decrement</button>
      </div>
    );
  }
}

export default Counter;
```
---
```javascript
import React from 'react';

const OtherPlace = (props) => (
  <div>
    And a counter is: {props.value}
  </div>
);

export default OtherPlace;
```

---
# Pros
- Predictable shape of state
- Easy to share data in your application

---
# Cons
- A lot of boilerplate code
- Сoupling to flux framework api
- Can be hard to integrate to existing project

---
# Related Patterns

---
## Command Query Responsibility Segregation
## (aka CQRS)
#### Strict separation between read (Query) and write (Commands) operations.

---
# Event Sourcing
#### Event Sourcing ensures that all changes to application state are stored as a sequence of events. 
#### Cause sometimes we don't just want to see where we are,  we also want to know how we got there.

---
# Usefull Links
- [Flux first appearance](http://facebook.github.io/flux/)
- [Flux utils from facebook](https://github.com/facebook/flux)
- [Event Sourcing and CQRS](https://www.youtube.com/watch?v=8JKjvY4etTY)
