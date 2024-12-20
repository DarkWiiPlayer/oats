# OATS

**O**utput **A**gnostic **T**agging **S**ystem aka. OATS implemented in Lua.

## Format

### Overview

- Tree structure like XML
- No attributes, only children
- No namespaces
- Nesting by Indentation

Nodes are enclosed with square brackets

```
[document]
```

Nested elements are indented

```
[document]
    [nested-tag]
    nested text
```

Tags with only one text node can be shortened to one-line tags:

```
[tag-name] single text node

evaluates to the same as

[tag-name]
    single text node
```

Text nodes mixed with one-line tags can further be shortened with inline tags:

```
Plain text with some
[bold] tagged
text
[emphasis] in between

evaluates to the same as

Plain text with some [bold tagged] text [emphasis in between]
```

**Note**: Consumers may have a better understanding of whether and how to join text
elements together, while the interpreter would have to decide on a joining
strategy (most likely concatenation with a space character in between).

### Data Type

OATS makes no attempts to interpret text.
Everything is considered a string and it is left up to the consuming application
to decide how to interpret the textual representation.

### Conventions

OATS is a very simple format without many restrictions.
Nevertheless, the following suggestions are provided to ensure some reasonable
degree of uniformity between applications:

OATS tag names preserve case, but applications consuming OATS structures should
generally ignore case.

Tag names should use lowercase kebab-case.

Applications that interpret parts of a tag name as a namespace should use a
single colon `:` as the namespace separator, with namespaces preceding the tag
name.

## Interface
