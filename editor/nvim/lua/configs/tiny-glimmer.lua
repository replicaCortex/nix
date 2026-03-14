require("tiny-glimmer").setup {
  overwrite = {
    undo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "#FB4934",
          max_duration = 500,
          min_duration = 500,
        },
      },
      undo_mapping = "u",
    },

    redo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "#B8BB26",
          max_duration = 500,
          min_duration = 500,
        },
      },
      redo_mapping = "<c-r>",
    },

    paste = {
      enabled = true,
      default_animation = "fade",
      paste_mapping = "p",
      Paste_mapping = "P",
    },
  },

  animations = {
    fade = {
      from_color = "#FE8019",
      to_color = "#282828",
    },
  },
}
