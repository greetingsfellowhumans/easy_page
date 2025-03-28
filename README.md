# EasyPage

This is a bundle of Phoenix components and scaffolding tools I use all the time. YMMV.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `easy_page` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:easy_page, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/easy_page>.

## Usage

Add a bunch of template files somewhere (probably in assets).
Then add something like this to your config/dev.exs

```elixir
config :easy_page,
  scaffolds: [
    new: [
      replacements: ["index", "Index"],
      paths: [
        {"./assets/templates/new_page/index.exs", "./lib/demo_web/pages/index/index.ex"},
        {"./assets/templates/new_page/mount.exs", "./lib/demo_web/pages/index/mount.ex"},
        {"./assets/templates/new_page/handlers.exs", "./lib/demo_web/pages/index/handlers.ex"},
        {"./assets/templates/new_page/index_test.exs",
         "./test/demo_web/pages/index/index_test.exs"}
      ]
    ]
  ]
```

To get started quickly, grab the templates from [https://github.com/greetingsfellowhumans/easy_page/tree/main/assets/templates](https://github.com/greetingsfellowhumans/easy_page/tree/main/assets/templates) and place them in ./assets/templates/

Now finally we get to use the handy CLI

```bash
mix easy_page
```

Which will walk you through the process of copying the files from their template path, into the destination path specified in the config. As it copies, it will automatically search and replace text.

You can create your own custom scaffolds beyond just :new.

Remember the default templates are just a starting point. You can, and SHOULD customize them to make them your own. As a base, they just create a simple page with a live_view tabination component. There are separate modules for the page entrypoint, the mount function, handlers, and a test.

You almost certainly want to go through each file and replace DemoWeb with your own module name, as well as change the destination paths accordingly.