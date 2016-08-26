[![CircleCI](https://circleci.com/gh/ashfurrow/playground-book-lint.svg?style=svg)](https://circleci.com/gh/ashfurrow/playground-book-lint)

# playgroundbook

Linter for Swift Playground books based on [Apple's documentation](https://developer.apple.com/library/prerelease/content/documentation/Xcode/Conceptual/swift_playgrounds_doc_format/index.html#//apple_ref/doc/uid/TP40017343-CH47-SW4). It's a work in progress (see [issues](https://github.com/ashfurrow/playground-book-lint/issues)) but you can use it now.

## Installation

```sh
> [sudo] gem install playgroundbook
```

## Usage

To lint an existing playground book:

```sh
> playgroundbook lint MyPlaygroundbook.playgroundbook
```

To generate a playground book:

```sh
> playgroundbook render book.yaml
```

The yml file should be in the following format:

```yaml
name: Testing book
identifier: com.ashfurrow.example
resources: assets # Optional
deployment_target: ios10.0 # Optional
imports: # Optional, defaults to UIKit 
 - UIKit
 - CoreGraphics
chapters:
  - Chapter 1
  - Chapter 2
  - etc...
```

Each chapter needs to have a corresponding playground; so `Chapter 1` requires there be a `Chapter 1.playground` playground. The playgrounds can reference (not copy) resources from an optionally specified directory. `import` frameworks are specified in the yaml file and are added to every page of the book. Each chapter needs to be in the following format:

```swift
// This is the preamble that is shared among all the pages within this chapter.

func sharedFunc() {
  print("This should be accessible to all pages.")
}

//// Page 1

str = "Yo, it's page 1."
sharedFunc()

//// Page 2

sharedFunc()
str = "Page 2 awww yeah."
```

Pages are divided by lines beginning with a quadruple slash, followed by that pages name.

## License

MIT, except for the `starter.playgroundbook` in the unit tests, which is licensed by Apple.
