require("tiny-glimmer").setup {
  overwrite = {
    yank = {
      enabled = true,
      default_animation = "fade",
    },

    paste = {
      enabled = true,
      default_animation = "fade",
    },

    redo = {
      enabled = true,
      default_animation = {
        settings = {
          from_color = "#B8BB26",
        },
      },
    },

    undo = {
      enabled = true,
      default_animation = {
        settings = {
          from_color = "#FB4934",
        },
      },
    },
  },

  animations = {
    fade = {
      easing = "inOutSine",
      from_color = "IncSearch",
      to_color = "Normal",
    },
  },
}
