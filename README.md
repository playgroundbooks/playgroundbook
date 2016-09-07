[![CircleCI](https://circleci.com/gh/ashfurrow/playgroundbook.svg?style=svg)](https://circleci.com/gh/ashfurrow/playgroundbook)

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
cover: cover.jpeg # Optional
deployment_target: ios10.0 # Optional
imports: # Optional, defaults to UIKit 
 - UIKit
 - CoreGraphics
chapters:
  - Chapter 1
  - Chapter 2
  - etc...
glossary:
  term: definition
```

Each chapter needs to have a corresponding playground; so `Chapter 1` requires there be a `Chapter 1.playground` playground. The playgrounds can reference (not copy) resources from an optionally specified directory. `import` frameworks are specified in the yaml file and are added to every page of the book. You can specify a cover image file name that's stored in the `resources` directory (it should be 400x300 pixels). Finally, you can supply a glossary, a dictionary of term/definition pairs. This lets you link to terms in markdown. For example:

```md
... [term](glossary://term) ...
```

Only the link to the term must be URL encoded. For example, the term "reuse identifier" would be defined in the yaml as `reuse identifier` but linked to as `glossary://reuse%20identifier`.  

Each chapter needs to be in the following format:

```swift
// This is the preamble that is shared among all the pages within this chapter.

public var str = "Hi!"

public func sharedFunc() {
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

### Limitations of Book Rendering

Preamble (anything about the first `////` page) is put in its own file. That means declarations there need to be `public` to be visible within individual pages (even though when you're writing, everything is in one file). Additionally, the preamble is at the top-level and can't contain expressions. This would cause a compiler error in the Swift Playrounds iPad app:

```swift
public let layout = UICollectionViewFlowLayout()
layout.itemSize = CGSize(width: 20, height: 20)
```

Instead, you have to wrap it in a closure, like this:

```swift
public var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 20, height: 20)
    return layout
}()
```

It's awkward; if you have suggestions, open an issue :+1: 

Sharing resources is only available book-wide and not specific to chapters. Sharing code outside the preamble isn't supported yet.

Playground books support a rich set of awesome features to make learning how to code really easy, and this tool uses almost none of them. It sacrifices this experience for the sake of being able to easily write the books on your Mac.

## License

MIT, except for the `starter.playgroundbook` in the unit tests, which is licensed by Apple.
