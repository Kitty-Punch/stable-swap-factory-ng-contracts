# Foundry: Invariant & Fuzzing Template

## Overview

This repository is a template to use in smart contract development.

Some supported features:

- Fuzzing test examples.
- Invariant test examples.
- Support Vyper contracts using [VyperDeployer](./test/utils/VyperDeployer.sol).
- Fuzzing/Invariant (including fork testing) tests configured in the Github actions workflow.
- Support fork testing. More info in [this example](./test/fuzz/WrappedTokenFork.t.sol).

## Requirements

- [Foundry](https://book.getfoundry.sh/getting-started/installation) +0.2.0

## Get Started

- Copy/paste `.env.template` and create `.env` file.
- Fill in `.env` with your our values.
- Run `forge build`
- Run `forge test`

## Commands

### Run tests (including invariants and forks)

`forge test`

### Run coverage

`forge coverage`

## Other Docs

- [Vyper Support](./docs/support-vyper.md)
- [Learning Resources](./docs/learning-resources.md)
