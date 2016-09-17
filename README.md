[![CircleCI](https://circleci.com/gh/playgroundbooks/playgroundbook.svg?style=svg)](https://circleci.com/gh/playgroundbooks/playgroundbook)

# playgroundbook

A series of tools for Swift Playground and Playground books based on [Apple's documentation](https://developer.apple.com/library/prerelease/content/documentation/Xcode/Conceptual/swift_playgrounds_doc_format/index.html#//apple_ref/doc/uid/TP40017343-CH47-SW4).

It's a work in progress (see [issues](https://github.com/ashfurrow/playground-book-lint/issues)) but you can use it now.

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
  - name: Chapter 1
    edge_to_edge_live_view: false # defaults to true
    live_view_mode: "VisibleByDefault" # defaults to "HiddenByDefault"
  - name: Chapter 2
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

### Creating a Playground from markdown

Maybe you want to do something for a website, or a git repo first, and then generate your Playground? Well in those cases your source of truth is the markdown document. For that case, we have `playgroundbook wrapper`.

For example, you might have a folder that looks like:

``` sh
> tree Beginners/Lesson\ One

Beginners/Lesson\ One
├── README.md
├── README_ZH.md
└── img
    ├── emptyplayground.png
    ├── multipleresults.png
    ├── newplayground.png
    ├── results.png
    ├── tentimes.png
    └── welcome.png
```

You can run:
```sh
playgroundbook wrapper "Beginners/Lesson\ One/README.md" "Lesson One"
```

And it will switch out swift codeblocks into the playground. You _have_ to use  triple backticks with swift <code>```swift</code>. No space between them. You should avoid using backtick blocks for anything other than Swift code, if you need to show examples, [use Markdown's indentation rules](https://guides.github.com/features/mastering-markdown/#GitHub-flavored-markdown) with four spaces.

```sh
> tree Beginners/Lesson\ One

Beginners/Lesson\ One
├── Lesson\ One.playground
│   ├── Contents.swift
│   ├── Resources
│   │   └── img
│   │       ├── emptyplayground.png
│   │       ├── newplayground.png
│   │       ├── results.png
│   │       └── welcome.png
│   ├── contents.xcplayground
│   └── timeline.xctimeline
├── README.md
...
```

You might notice that a subset of images, have moved well, they're the only one being used in the `README.md`. Slick huh?


Contributing
------------

Hey! Like this tool? Awesome! We could actually really use your help!

Open source isn't just writing code. We could use your help with any of the
following:

- Finding (and reporting!) bugs.
- New feature suggestions.
- Answering questions on issues.
- Reviewing pull requests.
- Helping to manage issue priorities.
- Fixing bugs/new features.

If any of that sounds cool to you, send a pull request! After a few
contributions, we'll add you as an admin to the repo so you can merge pull
requests and help steer the ship :ship: You can read more details about that [in our contributor guidelines](https://github.com/playgroundbooks/playgroundbook/blob/master/Community.md).

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by [its terms](https://github.com/playgroundbooks/playgroundbook/blob/master/Code of Conduct.md).

## License

MIT, except for the `starter.playgroundbook` in the unit tests, which is licensed by Apple.
