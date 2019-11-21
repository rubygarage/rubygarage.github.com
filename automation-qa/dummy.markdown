---
layout: slide
title:  Dummy slide
---

## Colorization

```bash
$ rspec spec/arrays/push_spec.rb --color
```

## Formating

Progress format (default)

```bash
$ rspec spec/arrays/push_spec.rb
```

or

```bash
$ rspec spec/arrays/push_spec.rb  --format progress

....F.....*.....

# '.' represents a passing example, 'F' is failing, and '*' is pending.
```

--

### Built-in Formatters

```bash
-f, --format FORMATTER    
```

Choose a FORMATTER:

- `progress` (default) - Prints dots for passing examples, F for failures, * for pending.

- `documentation` - Prints the docstrings passed to describe and it methods (and their aliases).

- `html`

- `json` - Useful for archiving data for subsequent analysis.

- `failures`  "file:line:reason", suitable for editors integration.

--

### Documentation format

```bash
$ rspec spec/arrays/push_spec.rb --format documentation

Array
  #last
    should return the last element
    should not remove the last element
  #pop
    should return the last element
    should remove the last element

Finished in 0.00212 seconds
4 examples, 0 failures
```

### Additional tools for formatting

```bash
$ gem install fuubar
```

```bash
$ rspec spec/arrays/push_spec.rb  --format Fuubar
```

Output to file
```bash
$ rspec spec --format documentation --out rspec.txt
```

---