# Eco - Fast, flexible, designer-friendly templates.

[![Build Status](https://travis-ci.org/eudoxia0/eco.svg?branch=master)](https://travis-ci.org/eudoxia0/eco)

# Goals

- **Simple:** Eco is essentially just a string concatenator. It introduces no
  constructs of its own: Every tag is pure Common Lisp code, plain and simple.
- **Easy to Use:** Proper use of Eco should not require more than a
  cursory read of this README from time to time.
- **Designer-friendly:** Lispers have written template engine after template
  engine that turns S-expressions into HTML. Which is great, if you're a
  lisper. Eco is meant to be used for more than HTML and also to be usable to
  the many designers and programmers who don't know the language and should not
  be expected to learn an obscure template syntax to be able to contribute.
- **Performance:** Eco uses the many performance advantages of Common
  Lisp. Templates are not interpreted or run in a VM, but compiled to Common
  Lisp, which is then compiled down to efficient machine code. By making each
  template a function that takes an (Optionally typed) argument list rather than
  passing an environment hash table like most other template engines, one can
  leverage the type inference features of modern Common Lisp implementations to
  create performant templates.

# Usage

A basic template (`.eco` extension) looks like this:

```erb
<% deftemplate index (title &optional posts) () %>
  <!DOCTYPE html>
  <html>
    <head>
      <title><%= title %></title>
    </head>
    <body>
      <% if posts %>
        <h1>Recent Posts</h1>
        <ul id="post-list">
          <% loop for (title . snippet) in posts do %>
            <li><%= title %> - <%= snippet %></li>
          <% end %>
        </ul>
      <% else %>
        <span>No recent posts.</span>
      <% end %>
    </body>
  </html>
<% end %>
```

To load this template, put this in your system definition file:

```lisp
(:eco-template "filename")
```

For interactive or quick tests on the REPL, templates can be loaded
using ECO:COMPILE-STRING,

```lisp
(eco:compile-string "<% deftemplate inline-test () () %>This is a test.<% end %>")
```

All templates are eventually compiled into Lisp functions. To get
their outputs, call the templates like any Lisp function:

```lisp
(eco-template:index "My Blog" nil)
```

Eco is designed to be output-agnostic, however, by default it will
autoescape HTML for convenience. Specify :ESCAPE-HTML NIL when
defining each template to disable this behaviour individually for each
template.

```erb
<% deftemplate output-js-logger (module) (:escape-html nil) %>
   function logDebug (message) {
       console.log("<%= module %>: " + message);
   }
<% end %>
```

# Tags

There are three types of tags in Eco:

- Expressions: `<%= <expr> %>` becomes `<expr>`.
- Blocks: `<% <code> <arg1> <arg2> %><body><% end %>` becomes `(<code> <arg1> <arg2> <body>)`.
- Calls: `<%- <fun> <arg1> <arg2> %><body><% end %>` becomes `(<fun> <arg1> <arg2> <body>)`.

Blocks are used to specify Lisp code "inline" in the template, and
tend to contain imperative code, their return values are ignored.
Expressions and calls are more functional as they return values to be
interpolated into their templates. The function called by the CALL
construct may be another templates, or any arbitrary Lisp function.

# Options

- `*template-package*`: The package the templates will be defined it. Defaults
  to `:eco-template`.

# Reference

## `deftemplate`

**Syntax:**

```erb
<% deftemplate name (&rest args) (&rest options) %>
  <body>
<% end %>
```

Defines a template. The only option that is currently defined is
:ESCAPE-HTML (default T)

# Examples

## `if`

**Syntax:**

```erb
<% if cond %>
  true branch
<% else %>
  false branch
<% end %>
```

# Implementation

Eco uses esrap to parse templates, which it then compiles down to Common Lisp
code.

# License

Copyright (c) 2014-2015 Fernando Borretti (eudoxiahp@gmail.com)

Licensed under the MIT License.
