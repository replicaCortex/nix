{...}: {
  programs.nixvim = {
    plugins.leap = {
      enable = true;
    };

    extraConfigLuaPre = ''

      require("leap").opts.labels = {
      	"s",
      	"f",
      	"n",
      	"j",
      	"k",
      	"l",
      	"h",
      	"o",
      	"d",
      	"w",
      	"e",
      	"m",
      	"b",
      	"u",
      	"y",
      	"v",
      	"r",
      	"g",
      	"t",
      	"c",
      	"x",
      	"z",
      	"S",
      	"F",
      	"N",
      	"J",
      	"K",
      	"L",
      	"H",
      	"O",
      	"D",
      	"W",
      	"E",
      	"M",
      	"B",
      	"U",
      	"Y",
      	"V",
      	"R",
      	"G",
      	"T",
      	"C",
      	"X",
      	"Z",
      }

      require("leap").opts.safe_labels = {
      	"s",
      	"f",
      	"n",
      	"u",
      	"t",
      	"S",
      	"F",
      	"N",
      	"L",
      	"H",
      	"M",
      	"U",
      	"G",
      	"T",
      	"Z",
      }

      require("leap").opts.highlight_unlabeled_phase_one_targets = true

      require("leap").opts.substitute_chars = {
      	["\r"] = "¬",
      	[" "] = "·",
      }

      require("leap").opts.equivalence_classes = {
      	" \n",
      	")]}>",
      	"([{<",
      	{ '"', "'", "`" },
      }

      require("leap").opts.special_keys = {
      	repeat_search = "",
      	next_phase_one_target = "",
      	next_target = { ";" },
      	prev_target = { "," },
      	next_group = "",
      	prev_group = "",
      	multi_accept = "",
      	multi_revert = "",
      }

      -- Настройка цвета для LeapBackdrop
      vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#666666" })

      vim.keymap.set({ 'n', 'x', 'o' }, "ы", "<Plug>(leap-forward)", { })
      vim.keymap.set({'n', 'x', 'o'}, 'Ы',  '<Plug>(leap-backward)', { })

      -- spooky

      -- require("leap-spooky").setup({
      -- 	extra_text_objects = nil,
      -- 	affixes = {
      -- 		magnetic = { window = "m" },
      -- 		remote = { window = "r" },
      -- 	},
      -- 	prefix = false,
      -- 	paste_on_remote_yank = false,
      -- })
    '';

    # extraPlugins = [
    #   (pkgs.vimUtils.buildVimPlugin {
    #     name = "leap-spooky.nvim";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "ggandor";
    #       repo = "leap-spooky.nvim";
    #       rev = "5f44a1f63dc1c4ce50244e92da5bc0d8d1f6eb47";
    #       hash = "sha256-XpWDFpiMZ6Up6gLzC6L0XWSiysgh5+6g0vxqi2vzdqE=";
    #     };
    #   })
    # ];
  };
}
