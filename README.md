# Testing Nirvana
Go/split/create/peek/run to test/source.

> This is in alpha stage, **create/run not yet supported**.\
> Use a [test explorer][4] extension to get a "run current test" feature for now


## Install
[Marketplace][1]


## Usage
Having a function name highlited
- Testing Nirvana: Split to file
- Testing Nirvana: Go to file
- Peek Definition

Use a [macro][2] for better peek experience.

settings.json
```json
    "macros.list": {
        "peekTest" : ["editor.action.peekDefinition", "list.focusLast", "list.expand", "list.focusLast"],
    },
```


## Why
To make testing a first class citzen in VsCode. Choose how you want to work:
- openning your tests "inline" with **peek**
- **splitting** your editor
- **going** back and forth between your tests

See ongoing [official][3] efforts.

## [Contributing](CONTRIBUTING.md)


[1]: https://marketplace.visualstudio.com/items?itemName=icetbr.vscode-testing-nirvana
[2]: https://marketplace.visualstudio.com/items?itemName=ctf0.macros
[3]: https://github.com/microsoft/vscode/issues/126932
[4]: https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-mocha-test-adapter
