---
layout: slide
title: Webpack
---

# Webpack

--

## What is webpack

* Module bundler

The `import` and `export` statements have been standardized in `ES2015`. 

Although they are not supported in most browsers yet, webpack does support them out of the box. 

Webpack takes modules with dependencies and generates static assets representing those modules.

---

## Installing

Let's start by creating project folder and initialize using `npm init` command

```bash
npm install --save-dev webpack
```

Installing globally locks you down to a specific version of webpack and could fail in projects that use a different version.

package.json <!-- .element: class="filename" -->
```json
{
  "name": "webpack-examples",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "license": "MIT",
  "devDependencies": {
    "webpack": "^3.5.5"
  }
}
```

---

## Command Line Interface (CLI)

--

## Running by npm scripts

package.json <!-- .element: class="filename" -->
```json
{
  "name": "webpack-examples",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "license": "MIT",
  "scripts": {
    "start": "webpack"
  },
  "devDependencies": {
    "webpack": "^3.5.5"
  }
}
```

```
npm run start
```

--

Output:

```
No configuration file found and no output filename configured via CLI option.
A configuration file could be named 'webpack.config.js' in the current directory.
Use --help to display the CLI options.
```

---

## Init configuration file

```bash
touch webpack.config.js
npm install --save-dev html-webpack-plugin
```

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: path.join(__dirname, 'src', 'index.js'),
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Webpack app'
    })
  ]
}
```

--

Modules into `src` folder

hello.js <!-- .element: class="filename" -->
```js
export default function () {
  console.log('Webpack example')
}
```

index.js <!-- .element: class="filename" -->
```js
import hello from './hello'

hello()
```

--

```bash
npm run start
```

It will generate two files in `build` folder.

* `main.js` - our bundled js code
* `index.html` - html document which includes `main.js` and `Webpack app` title

--

## Some entry points

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: {
    'index': path.join(__dirname, 'src', 'index.js'),
    'about': path.join(__dirname, 'src', 'about.js')
  },
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Webpack app'
    })
  ]
}
```

Both bundled files `index.js` and `about.js` will be required into `index.html`

--

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: {
    'index': path.join(__dirname, 'src', 'index.js'),
    'about': path.join(__dirname, 'src', 'about.js'),
  },
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      filename: 'index.html',
      chunks: ['index'],
      title: 'Webpack app'
    }),
    new HtmlWebpackPlugin({
      filename: 'about.html',
      chunks: ['about'],
      title: 'Webpack app'
    })
  ]
}
```

--

## File watching

```json
"scripts": {
  "start": "webpack --watch"
}
```

This means that after the initial build, webpack will continue to watch for changes in any of the resolved files. Watch mode is turned off by default.

---

# Webpack dev server

* Running in memory
* Livereload
* Hot Module Replacement

--

## Installing

```bash
npm install --save-dev webpack-dev-server
```

webpack.config.js <!-- .element: class="filename" -->
```json
{
  "name": "webpack-examples",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "license": "MIT",
  "scripts": {
    "start": "webpack-dev-server",
    "build": "webpack"
  },
  "devDependencies": {
    "html-webpack-plugin": "^2.30.1",
    "webpack": "^3.5.5",
    "webpack-dev-server": "^2.7.1"
  }
}
```

--

```bash
npm run start
```

Project is running at http://localhost:8080/

It will automatically refresh page after file changes

--

## Configuration

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: path.join(__dirname, 'src', 'index.js'),
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Webpack app'
    })
  ],
  devServer: {
    stats: 'errors-only'
  }
}
```

[Read more](https://webpack.js.org/configuration/dev-server/)

--

## Production & Development

Two ways to solve it:

* Different configs
* Conditions by `NODE_ENV` variable

--

## Option `--config`

```json
"scripts": {
  "start": "webpack-dev-server --config webpack.dev.config.js",
  "build": "webpack --config webpack.prod.config.js"
}
```

--

## `NODE_ENV`

```json
"scripts": {
  "start": "NODE_ENV=development webpack-dev-server",
  "build": "NODE_ENV=production webpack"
}
```

--

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

const common = {
  entry: path.join(__dirname, 'src', 'index.js'),
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Webpack app'
    })
  ]
}


const devConfig = {
  devServer: {
    stats: 'errors-only'
  }
}

module.exports = function(env) {
  if (process.env.NODE_ENV === 'production') {
    return common;
  } else if (process.env.NODE_ENV === 'development') {
    return Object.assign(
      {},
      common,
      devConfig
    )
  }
}
```

---

# Loaders

Webpack enables use of loaders to preprocess files. 

--

## SASS

```bash
npm install node-sass style-loader css-loader sass-loader --save-dev
```

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: path.join(__dirname, 'src', 'index.js'),
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Webpack app'
    })
  ],
  module: {
    rules: [
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  }
}
```

--

Import styles to entry point:

src/index.js <!-- .element: class="filename" -->
```js
import './index.scss'
```

Then compiled css will be included in `<script>` tag

--

## Third party libraries

```bash
npm install normalize.css
```

```js
module: {
  rules: [
    {
      test: /\.css$/,
      exclude: /node_modules/,
      use: [
        'style-loader',
        'css-loader'
      ]
    }
  ]
}
```

src/index.js <!-- .element: class="filename" -->
```js
import 'normalize.css'
```
--

## file-loader

Instructs webpack to emit the required object as file and to return its public URL

```bash
npm install --save-dev file-loader
```

--

```json
module: {
  rules: [
    {
      test: /\.(jpg|png|svg)$/,
      loader: 'file-loader',
      options: {
        name: 'images/[name].[ext]'
      },
    },
  ],
},
```

[Documentation](https://webpack.js.org/loaders/file-loader/)

--

## Babel

Babel is a JavaScript compiler.

--

## Installing

```bash
npm install --save-dev babel-core babel-loader babel-preset-env babel-preset-react
```

webpack.config.js <!-- .element: class="filename" -->
```json
module: {
  rules: [
    {
      test: /\.(js|jsx)$/,
      exclude: /node_modules/,
      use: [ 'babel-loader' ]
    },
  ],
},
```

.babelrc <!-- .element: class="filename" -->
```
{
  "presets": [
    "env",
    "react"
  ]
}
```
--

## Hot Module Replacement

```bash
npm install --save react-hot-loader
```

package.json <!-- .element: class="filename" -->
```json
"scripts": {
  "start": "webpack-dev-server --hot"
},
```

.babelrc <!-- .element: class="filename" -->
```json
{
  "presets": [
    "env",
    "react"
  ],

  "plugins": [
    "react-hot-loader/babel"
  ]
}
```

--

src/index.js <!-- .element: class="filename" -->
```js
import React from 'react';
import { render } from 'react-dom';
import RootContainer from './containers/rootContainer.js';

render(<RootContainer />, document.getElementById('react-root'));

if (module.hot) {
  module.hot.accept('./containers/rootContainer.js', () => {
    const NextRootContainer = require('./containers/rootContainer.js').default;
    render(<NextRootContainer />, document.getElementById('react-root'));
  }
}
```

--

## React Constant Elements Transform

```bash
npm install --save-dev babel-plugin-transform-react-constant-elements
```

In
```js
const Hr = () => {
  return <hr className="hr" />;
};
```

Out
```js
const _ref = <hr className="hr" />;

const Hr = () => {
  return _ref;
};
```

--

.babelrc <!-- .element: class="filename" -->
```json
{
  "plugins": ["transform-react-constant-elements"]
}
```

[Babel Plugins](https://babeljs.io/docs/plugins/)

---

# Plugins

They are used to change the configuration of the bundler, optimize, add some objects to the modules.

--

## ExtractTextWebpackPlugin

Extract text from a bundle, or bundles, into a separate file.

```bash
npm install --save-dev extract-text-webpack-plugin
```

--

webpack.config.js <!-- .element: class="filename" -->
```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

const common = {
  entry: path.join(__dirname, 'src', 'index.js'),
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader", "sass-loader"]
        })
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("[name].css"),
    new HtmlWebpackPlugin({
      title: 'Webpack app'
    })
  ]
}
```

Styles will be included via `main.css` file

--

## UglifyjsWebpackPlugin

* Minification JavaScript

--

```bash
npm install --save-dev uglifyjs-webpack-plugin
```

webpack.config.js <!-- .element: class="filename" -->
```js
const UglifyJSPlugin = require('uglifyjs-webpack-plugin')

module.exports = {
  plugins: [
    new UglifyJSPlugin()
  ]
}
```

[Documentation](https://webpack.js.org/plugins/uglifyjs-webpack-plugin/)

---

# The End
