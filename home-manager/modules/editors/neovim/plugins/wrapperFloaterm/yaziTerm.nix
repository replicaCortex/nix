{
  programs.nixvim = {
    extraConfigLuaPre = ''
      vim.cmd("source ~/.config/nvim/autoload/floaterm/wrapper/yazi.vim")

      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
          local arg = vim.fn.argv(0)
          if arg == "." then
            vim.cmd("bdelete")
            vim.cmd("FloatermNew yazi")
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
        action = "<CMD>FloatermNew --title=yaziManager yazi<CR>";
        options = {
          silent = true;
        };
      }
    ];
  };

  home.file = {
    "/.config/nvim/autoload/floaterm/wrapper/yazi.vim".text = ''
      " vim:sw=2:
      " ============================================================================
      " FileName: yazi.vim
      " Author: Sam Varga <sam@vargasd.com>
      " GitHub: https://github.com/vargasd
      " ============================================================================

      function! floaterm#wrapper#yazi#(cmd, jobopts, config) abort
        let s:yazi_tmpfile = tempname()
        let original_dir = getcwd()
        lcd %:p:h

        let cmdlist = split(a:cmd)
        let cmd = 'yazi --chooser-file "' . s:yazi_tmpfile . '"'
        if len(cmdlist) > 1
          let cmd .= ' ' . join(cmdlist[1:], ' ')
        else
          let cmd .= ' "' . getcwd() . '"'
        endif

        exe "lcd " . original_dir
        let cmd = [&shell, &shellcmdflag, cmd]
        let jobopts = {'on_exit': funcref('s:yazi_callback')}
        call floaterm#util#deep_extend(a:jobopts, jobopts)
        return [v:false, cmd]
      endfunction

      function! s:yazi_callback(job, data, event, opener) abort
        if filereadable(s:yazi_tmpfile)
          let filenames = readfile(s:yazi_tmpfile)
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
