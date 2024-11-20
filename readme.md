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

Multi-line text nodes are yet to be decided. As of now, the options are:

1. Consecutive non-empty lines of text are merged with a space
2. Any non-empty text line is always a single text element

**Note**: Consumers may have a better understanding of whether and how to join text
elements together, while the interpreter would have to decide on a joining
strategy (most likely concatenation with a space character in between).

### Conventions

OATS is a very simple format without many restrictions.
Nevertheless, the following suggestions are provided to ensure some reasonable
degree of uniformity between applications:

OATS tag names preserve case, but applications consuming OATS structures should
generally ignore case.

Tag names should use lowercase kebab-case.

## Interface
