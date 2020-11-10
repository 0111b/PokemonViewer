# Pokemon viewer

![Build](https://github.com/0111b/PokemonViewer/workflows/Build/badge.svg)
![Swift](https://img.shields.io/badge/Swift-5.3-orange.svg)
![iOS](https://img.shields.io/badge/iOS-11-yellow.svg)
![License](https://img.shields.io/badge/license-MIT-ff69b4.svg)

Demo app showing Pokemons stats using [pokeapi](https://pokeapi.co)

# TOC

- [Functionality](#Functionality)
- [Screenshots](#Screenshots)
- [Requirements](#Requirements)
- [Details and rationale](#Details-and-rationale)
  - [General info](#General-info)
    - [User interface](#User-interface)
    - [Persistence](#Persistence)
    - [Third party](#Third-party)
    - [Architecture overview](#Architecture-overview)
    - [Localisation](#Localisation)
  - [How to build](#How-to-build)
  - [Common](#Common)
  - [App](#App)
  - [Model](#Model)
  - [Service](#Service)
  - [Screens](#Screens)
    - [Empty pokemon details](#Empty-pokemon-details)
    - [Pokemon list](#Pokemon-list)
    - [Pokemon details](#Pokemon-details)
    - [Sprite legend](#Sprite-legend)
  - [Tests](#Tests)
    - [Unit tests](#Unit-tests)
    - [UI tests](#UI-tests)
    - [UITeststingSupport](#UITeststingSupport)
- [Possible way for improvements](#Possible-way-for-improvements)

# Functionality

Displays a list of Pokemons with the ability to see more detailed info about chosen Pokemon.

# Screenshots

![iPhone-portrait](Screenshots/iPad-1.png?raw=true)
![iPhone-landscape.png](Screenshots/iPhone-1.png?raw=true)
![iPhone-landscape.png](Screenshots/iPhone-2.png?raw=true)
![iPhone-landscape.png](Screenshots/iPhone-3.png?raw=true)
![iPhone-landscape.png](Screenshots/iPhone-4.png?raw=true)
![iPhone-landscape.png](Screenshots/iPhone-5.png?raw=true)

# Requirements

- iOS 11 deployment target
- UI without Xib/Storyboard
- At most 1 third-party library
- MVVM
- offline mode

# Details and rationale

## General info

### User interface

The app launches with a list of Pokemons which can be viewed in 2 ways: list and grid.

Item size in the grid mode is dynamic and depends on the available space. This results in 2-4 items per row.

The list can be filtered by Pokemon's name.

If Pokemon has some specific type then it is highlighted in the cell corner with a color mark.

Details and stats are available on the Pokemon screen. It is possible to see sprites legend by tapping the info button.

### Persistence

During designing the offline mode I took into account the next things:

- there are no sensitive data
- no modifications are expected at the domain level

That's why I decided to cache data at the transport level (caching raw bytes) and it will be good enough in the current spec.

The app is using  *URLCache* as a default implementation, but it can be easily changed by adopting *NetworkCache*.

There are also a few request policies implemented that affect the use of cache during execution (see *RequestCachePolicy*).

The disadvantage of this approach is constant data decoding from raw data.

If more complex tasks with domain objects will be required then another solution can be added on the higher level.

### Third party

[swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) is used as single
third party dependency in the project.
This is the library with helper functions for snapshot testing.

Rationale:

- Test code is not shipped to the App Store
- The library is already maintained for a long term and timely updated
- It's open-source. And because the code base is not so big I don't see the possibility of vendor lock.
- The library is extensible and customizable; not relies on other dependencies

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

The app is trying to reduce network pressure by canceling requests for all items that are not visible on the screen.
The application also reacts to memory warnings by freeing images from memory.

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

### Sprite legend

Informational screen about possible sprite types

## Tests

### Unit tests

Unit tests are cover almost all logic of the application except the views.

Besides common mocks, there is a *Stubs* object which provides all data types required in tests.

To improve test quality it is possible to add randomization to the returned values of this object.

UI of the views is covered with snapshot tests.

### UI tests

UI tests are mostly used as integration tests.

They are checking how all modules
work together and cover the logic that is not handled by unit tests.

Page Object pattern is used in the implementation. It reduces code complexity, increases code reuse, and eliminate some class of errors.

### UITeststingSupport

This is the shared library that is compiled both with the app and with the UI test target.

It serves two main purposes:

- Share accessibility ids between both targets in a way that changes in one of them affect another
- Build the mechanism to share configuration required by tests with the application

# Possible way for improvements

There are several things that can be improved or introduced

## Compare Pokemon's

I believe that from the user perspective it will be useful to introduce
the screen on which multiple Pokemons can be compared before the battle.

## Collection diffing

In the current implementation when the new portion of content arrive app is just call *reloadData* on the collection view.

The better way will be to calculate the difference between the current values and apply it.

Nothing stops implement this manually but it is worth mentioning that it is implemented in the later iOS versions.

  - *UICollectionViewDiffableDataSource* is available on iOS 13.

  - *Collection.difference(from:)* is available since Swift 5.1 but it shipped by Apple also with iOS 13

Any effective LCS solving problem algorithm will work.

But in any case, this must be implemented as a separate generic data source.

## Managing dependency lifetime

With increasing complexity, it is worth considering to manage dependencies lifetime in the more smart way.

## Swift UI previews

It is possible to use SwiftUI previews for rapid UI development even with UIKit views.

Another option is to generate a complete catalog of all available views which can be used by UI/UX engineers for reference.
