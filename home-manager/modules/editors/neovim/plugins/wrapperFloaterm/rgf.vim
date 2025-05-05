function! floaterm#wrapper#rgf#(cmd, jobopts, config) abort
  let s:rg_tmpfile = tempname()
  let current_file = shellescape(expand('%:p'))

  let rg_cmd = printf(
        \ 'rg --line-number --color=always --no-heading --smart-case {q} %s',
        \ current_file)

  let preview_cmd = printf(
        \ 'bat --style=numbers --color=always --highlight-line {1} %s',
        \ current_file)

  let fzf_cmd = printf(
        \ 'fzf --ansi --no-height --preview=%s'
        \   . ' --phony --query= --prompt="World   file: "'
        \   . ' --delimiter=:' 
        \   . ' --preview-window=+{1}-/2:65%%:down:wrap'
        \   . ' --bind="change:reload:%s || true"',
        \ shellescape(preview_cmd),
        \ rg_cmd)

  let cmd = printf('%s > %s', fzf_cmd, shellescape(s:rg_tmpfile))
  let cmd = [&shell, &shellcmdflag, cmd]
  let jobopts = {'on_exit': funcref('s:rg_callback')}
  call floaterm#util#deep_extend(a:jobopts, jobopts)
  return [v:false, cmd]
endfunction

function! s:rg_callback(job, data, event, opener) abort
  if filereadable(s:rg_tmpfile)
    let lines = readfile(s:rg_tmpfile)
    if !empty(lines)
      if has('nvim')
        call floaterm#window#hide(bufnr('%'))
      endif
      for line in lines
        let lnum = matchstr(line, '^\d\+')
        if !empty(lnum)
          execute 'normal! ' . lnum . 'G'
          break 
        endif
      endfor
    endif
    call delete(s:rg_tmpfile)
  endif
endfunction
