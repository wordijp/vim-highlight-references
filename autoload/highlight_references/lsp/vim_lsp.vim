function! highlight_references#lsp#vim_lsp#check_enabled() abort
  return exists('*lsp#send_request')
    && exists('*lsp#get_allowed_servers')
    && exists('*lsp#get_text_document_identifier')
    && exists('*lsp#get_position')
    && exists('*lsp#capabilities#has_document_highlight_provider')
    && execute(':LspStatus') =~ 'running'
endfunction

function! highlight_references#lsp#vim_lsp#highlight() abort
  if !!get(g:, 'lsp_highlight_references_enabled', 0) | return | endif

  let l:capability = 'lsp#capabilities#has_document_highlight_provider(v:val)'
  let l:servers = filter(lsp#get_allowed_servers(), l:capability)

  if len(l:servers) == 0
      return
  endif

  call lsp#send_request(l:servers[0], {
      \ 'method': 'textDocument/documentHighlight',
      \ 'params': {
      \   'textDocument': lsp#get_text_document_identifier(),
      \   'position': lsp#get_position(),
      \ },
      \ 'on_notification': function('s:handle_references'),
      \ })
endfunction

function! s:handle_references(data) abort
  call highlight_references#lsp#add_response(a:data)
endfunction
