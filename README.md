# Pokemon viewer

Demo app showing Pokemons stats using [pokeapi](https://pokeapi.co)

[TOC]

# Functionality

Displays a list of Pokemons with the ability to see more detailed info about chosen Pokemon.

# Screenshots

![iPhone-portrait](Screenshots/iPhone-portrait.png?raw=true)
![iPhone-landscape.png](Screenshots/iPhone-landscape.png?raw=true)
![iPad-landscape](Screenshots/iPad-landscape.png?raw=true)

# Requirements

- iOS 11 deployment target
- UI without Xib/Storyboard
- No third-party
- MVVM
- offline mode

# Details and rationale

## General info

### Layout

The app launches with a list of Pokemons which can be viewed in 2 ways: list and grid.

Item size in the grid mode is dynamic and depends on the available space.
This results in 3-4 items per row on the iPhone in the landscape mode and 2 elements in other cases.

On the iPad both, the list and the details can be viewed in parallel.

### Persistence

During designing the offline mode I took into account the next things:

- there are no sensitive data
- no modifications are expected at the domain level

That's why I decided to cache data at the transport level (caching raw bytes) and it will be good enough in the current spec.

The app is using  *URLCache* as a default implementation, but it can be easily changed by adopting *NetworkCache*.

There are also a few request policies implemented that affect the use of cache during execution (see *RequestCachePolicy*).

If more complex tasks with domain objects will be required then another solution can be added on the higher level.

### Architecture overview

In general SOA architecture is used.

Everything above the presentation layer is fully composable and interchangeable.
Areas of responsibility are clearly defined.

The code contains the required minimum of entities. If some complex business logic is supposed,
it will be a good idea to introduce some kind of interactor between services and view models.

On the presentation layer, the basic implementation of the flow coordinator pattern is used.
This allows applying any changes to the screen order or multiple flow compositions like a breeze.

Simple *Observable* is used as a binding between view and view model.
No custom operators implemented, but it is possible.

The preferable way of transferring data from the view model is an object with explicit states which eliminates inconsistent options.

Most of the views support the separation of the data and style. Each of them can be applied separately.

### Localisation

The app is localized for these languages: en, it, ru.

There should be several strings files, each with its own purpose:

**Screens** - contains strings used in the UI for every individual screen

**Models** - contains strings that are specific to the domain model and can be reused in multiple places
etc.

All values must be accessed via constants defined in the *Strings.swift*.

This file should be generated automatically. Check the [App](#App) section.


## How to build

Use the "PokemonViewer" scheme to run the app and the tests.

For convenience, there is a *Makefile* which allows to run tests, clean and lint the project.

It also has commands to help set up the environment.

Linter is strongly recommended but not required and it should not break the build.

## Common

This part contains generic code which has no dependencies itself.

All of this can be easily reused in other projects.

Let's walkthrough

- **Atomic**

some synchronization primitives

- **Reactive**

observable implementation and related things

- **Network**

HTTP request building, caching, and fetching

- **UIKit**

syntax sugar around UIKit

- **Service**

base class for API services and image loading service

- **View**

generic, reusable views

## App

This part contains settings and resources related to the entire application.

It is app lifecycle files, main flow coordinator, application assets, common data formatters and log definitions.

Important is *AppDependency*. It defines application behavior by determining all dependencies
and check if the app is executed in the test mode (see below).

Last but not least are files which constants definition about app feel and look.

Fonts, colors, images, strings must be in sync with the design system and updated in time.

It is pretty easy to use existing or write custom code generation tool for this.

Using constants also reduces the chance of errors or typos.

## Model

App wide domain objects

## Service

- Defines pokeapi service and its DTO
- Defines other services used in the UI tests

## Screens

### Empty pokemon details

This shown as a detail when no pokemon is selected

### Pokemon list

Main pokemon list and related entities

### Pokemon details

Pokemon stats and detailed info

## Tests

### Unit tests

Unit tests are cover almost all logic of the application except the views.

Besides common mocks, there is a *Stubs* object which provides all data types required in tests.

To improve test quality it is possible to add randomization to the returned values of this object.

### UI tests

UI tests are mostly used as integration tests.

They are checking how all modules
work together and cover the logic that is not handled by unit tests.

Page Object pattern is used in the implementation.  It reduces code complexity, increases code reuse, and eliminate some class of errors.

### UITeststingSupport

This is the shared library that is compiled both with the app and with the UI test target.

It serves two main purposes:

- Share accessibility ids between both targets in a way that changes in one of them affect another
- Build the mechanism to share configuration required by tests with the application

# Possible way for improvements

There are several things that can be improved or introduced


- **Collection diffing**

In the current implementation when the new portion of content arrive app is just call *reloadData* on the collection view.

The better way will be to calculate the difference between the current values and apply them.

There are several options according to the deployment target.


  - *UICollectionViewDiffableDataSource* is available on iOS 13.

  - *Collection.difference(from:)* is available since Swift 5.1 but sadly, it shipped by Apple also with iOS 13

  - some third-party library exists that solving this problem

  - nothing to stop implement this manually

In any case, this must be implemented as a separate generic data source.

- **Memory pressure**

It is good to subscribe and react appropriately where possible

- **Managing dependency lifetime**

With increasing complexity, it is worth considering to manage dependencies lifetime in the more smart way

- **Snapshot testing**

The remaining thing that is not covered by tests in the current solution is UI.

I'm recommending to use [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) from the Point-Free guys. It has proven quality and in any way, this code does not ship with the app. So, there will be no vendor lock.

- **Swift UI previews**

It is possible to use SwiftUI previews for rapid UI development even with UIKit views.

Another option is to generate a complete catalog of all available views which can be used by UI/UX engineers for reference.

- **CI/CD integration**

just a must