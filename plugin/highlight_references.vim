if exists('g:highlight_references_loaded')
  finish
endif
let g:highlight_references_loaded = 1

let g:highlight_references_interval = get(g:, 'highlight_references_interval', 200)

augroup highlight_references_enable
  autocmd!
  autocmd CursorMoved * call highlight_references#redrawLazy()
  autocmd CursorMovedI * call highlight_references#redrawLazy()
augroup END
