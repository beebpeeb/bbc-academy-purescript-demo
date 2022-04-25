# Dagskrá RÚV

## Install

```
$ npm install
```

## Run

```
$ npm start
```

The first time this command is run, PureScript package dependencies will be installed and the project will be compiled before being opened automatically in your default web browser.

Subsequent runs will be much faster.

Observe that the PureScipt compiler generates (readable) JavaScript which is written into the `output` directory as Common JS modules. The upcoming 0.15 release of the PureScript compiler will switch entirely to ES6 modules.

These JavaScript modules are then bundled by [Parcel](https://parceljs.org/) and the running application can be viewed on [localhost:1234](localhost:1234).

## Test

```
$ npm test
```

## Editor Integration

Visual Studio Code has excellent support for PureScript when the [PureScript IDE](https://marketplace.visualstudio.com/items?itemName=nwolverson.ide-purescript) extension is installed.
