return {
  enabled = true,
  sources = {
    files = {
      exclude = { "node_modules" },
    },
    grep = {
      exclude = { "node_modules" },
    },
  },
  matcher = {
    frecency = true
  },
  layout = {
    reverse = true,
    layout = {
      box = "horizontal",
      width = 0.9,
      height = 0.9,
      border = "none",
      {
        box = "vertical",
        { win = "list",  title = " Results ", title_pos = "center", border = "rounded" },
        { win = "input", height = 1,          border = "rounded",   title = "{title} {live} {flags}", title_pos = "center" },
      },
      {
        win = "preview",
        title = "{preview:Preview}",
        width = 0.6,
        border = "rounded",
        title_pos = "center",
      },
    },
  },
}
