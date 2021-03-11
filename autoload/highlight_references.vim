let s:redraw_timer_id = 0

function! highlight_references#redrawLazy() abort
  if s:redraw_timer_id != 0
    call timer_stop(s:redraw_timer_id)
    let s:redraw_timer_id = 0
  end

  let s:redraw_timer_id = timer_start(g:highlight_references_interval, function('s:redraw_'))
endfunction

" ---

function! s:redraw_(_)
  let s:redraw_timer_id = 0

  if !hlexists('highlightReference')
    highlight link highlightReference CursorColumn
  endif

  call highlight_references#lsp#clear_highlight()

  if getline('.')[col('.')-1] == ' ' | return | endif

  if highlight_references#lsp#vim_lsp#check_enabled()
    call highlight_references#lsp#vim_lsp#highlight()
  elseif highlight_references#lsp#coc#check_enabled()
    call highlight_references#lsp#coc#highlight()
  elseif highlight_references#lsp#LanguageClient#check_enabled()
    call highlight_references#lsp#LanguageClient#highlight()
  endif
endfunction
