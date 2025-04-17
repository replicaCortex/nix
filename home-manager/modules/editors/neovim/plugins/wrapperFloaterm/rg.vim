        if executable('bat')
          let s:viewer = 'bat --style=numbers --color=always --highlight-line {2}'
        elseif executable('batcat')
          let s:viewer = 'batcat --style=numbers --color=always --highlight-line {2}'
        else
          let s:viewer = 'cat -n'
        endif

        function! floaterm#wrapper#rg#(cmd, jobopts, config) abort
          let s:rg_tmpfile = tempname()
          let prog = 'fzf'
          let arglist = [
                \ '--ansi',
                \ '--multi',
                \ '--no-height',
                \ '--delimiter=:',
                \ '--phony',
                \ '--query=',
                \ '--prompt=RG > ',
                \ '--bind=change:reload:rg --column --line-number --no-heading --color=always --smart-case --no-ignore {q} || true',
                \ '--bind=ctrl-/:toggle-preview',
                \ '--bind=alt-a:select-all,alt-d:deselect-all',
		\ '--layout=reverse',
                \ '--preview-window=+{2}-/2:right:wrap',
		\ printf('--preview=%s {1}', s:viewer)
                \ ]
          " Fixed printf syntax with proper argument handling
          let cmd = printf('%s %s > %s',
                \ prog,
                \ join(map(copy(arglist), {_, v -> shellescape(v)}), ' '),
                \ shellescape(s:rg_tmpfile))
          let cmd = [&shell, &shellcmdflag, cmd]
          let jobopts = {
                \ 'on_exit': funcref('s:rg_callback')
                \ }
          call floaterm#util#deep_extend(a:jobopts, jobopts)
          return [v:false, cmd]
        endfunction

      function! s:rg_callback(job, data, event, opener) abort
        if filereadable(s:rg_tmpfile)
          let filenames = readfile(s:rg_tmpfile)
          if !empty(filenames)
            if has('nvim')
              call floaterm#window#hide(bufnr('%'))
            endif
            let locations = []
            for filename in filenames
              let parts = matchlist(filename, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
              let dict = {
                    \ 'filename': fnamemodify(parts[1], ':p'),
                    \ 'lnum': parts[2],
                    \ 'text': parts[4]
                    \ }
              call add(locations, dict)
            endfor
            call floaterm#util#open(locations, a:opener)
          endif
          call delete(s:rg_tmpfile)
        endif
      endfunction
