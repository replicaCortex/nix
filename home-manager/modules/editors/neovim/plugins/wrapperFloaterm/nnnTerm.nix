{
  programs.nixvim = {
    extraConfigLuaPre = ''
      vim.cmd("source ~/.config/nvim/autoload/floaterm/wrapper/nnn.vim")

      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
          local arg = vim.fn.argv(0)
          if arg == "." then
            vim.cmd("bdelete")
            vim.cmd("FloatermNew nnn")
          end
        end
      })
    '';

    keymaps = [
      # {
      #   mode = "n";
      #   key = "<leader>ff";
      #   action = "<CMD>FloatermNew --title=nnnManager nnn<CR>";
      #   options = {
      #     silent = true;
      #   };
      # }

      {
        mode = "n";
        key = "<C-n>";
        action = "<CMD>FloatermNew nnn<CR>";
        options = {
          silent = true;
        };
      }

      # {
      #   mode = "t";
      #   key = "<C-n>";
      #   action = "<CMD>FloatermToggle<CR><CMD>FloatermNew nnn<CR>";
      #   options = {
      #     silent = true;
      #   };
      # }
    ];
  };

  home.file = {
    "/.config/nvim/autoload/floaterm/wrapper/nnn.vim".text = ''
      " vim:sw=2:
      " ============================================================================
      " FileName: nnn.vim
      " Author: voldikss <dyzplus@gmail.com>
      " GitHub: https://github.com/voldikss
      " ============================================================================

      function! floaterm#wrapper#nnn#(cmd, jobopts, config) abort
        let s:nnn_tmpfile = tempname()
        let original_dir = getcwd()
        lcd %:p:h

        let cmdlist = split(a:cmd)
        let cmd = 'nnn -P p -p "' . s:nnn_tmpfile . '"'
        if len(cmdlist) > 1
          let cmd .= ' ' . join(cmdlist[1:], ' ')
        else
          let cmd .= ' "' . getcwd() . '"'
        endif

        exe "lcd " . original_dir
        let cmd = [&shell, &shellcmdflag, cmd]
        let jobopts = {'on_exit': funcref('s:nnn_callback')}
        call floaterm#util#deep_extend(a:jobopts, jobopts)
        return [v:false, cmd]
      endfunction

      function! s:nnn_callback(job, data, event, opener) abort
        if filereadable(s:nnn_tmpfile)
          let filenames = readfile(s:nnn_tmpfile)
          if !empty(filenames)
            if has('nvim')
              call floaterm#window#hide(bufnr('%'))
            endif
            let locations = []
            for filename in filenames
              let dict = {'filename': fnamemodify(filename, ':p')}
              call add(locations, dict)
            endfor
            call floaterm#util#open(locations, a:opener)
          endif
        endif
      endfunction
    '';
  };
}
