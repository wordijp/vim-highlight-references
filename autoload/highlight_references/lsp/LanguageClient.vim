function! highlight_references#lsp#LanguageClient#check_enabled() abort
  return exists('*LSP#filename')
    && exists('*LSP#text')
    && exists('*LSP#line')
    && exists('*LSP#character')
    && exists('*LanguageClient#isServerRunning')
    && LanguageClient#isServerRunning() == 1
endfunction

function! highlight_references#lsp#LanguageClient#highlight() abort
  let l:Callback = function('s:handle_references', [LSP#filename()])
  let l:params = {
              \ 'filename': LSP#filename(),
              \ 'text': LSP#text(),
              \ 'line': LSP#line(),
              \ 'character': LSP#character(),
              \ 'handle': v:false,
              \ }
  return LanguageClient#Call('textDocument/documentHighlight', l:params, l:Callback)
endfunction

function! s:handle_references(filename, data) abort
  let l:data = {'response': a:data, 'request': {'params': {'textDocument': {'filename': a:filename}}}}
  call highlight_references#lsp#add_response(l:data)
endfunction
