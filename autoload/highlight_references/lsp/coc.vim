function! highlight_references#lsp#coc#check_enabled() abort
  return exists('*coc#rpc#ready')
    && coc#rpc#ready() == 1
endfunction

function! highlight_references#lsp#coc#highlight() abort
  call coc#rpc#request('cocAction', ['highlight'])
endfunction
