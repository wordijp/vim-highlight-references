" see) https://github.com/prabirshrestha/vim-lsp/blob/master/autoload/lsp/utils.vim

if has('win32') || has('win64')
  function! highlight_references#utils#filename_to_path_uniform(filename) abort
    return substitute(substitute(a:filename, '^\u', '\l&', ''), '/', '\\', 'g')
  endfunction
  
  function! highlight_references#utils#uri_to_path_uniform(uri) abort
    " Drive path to lower case
    return substitute(substitute(s:decode_uri(a:uri[len('file:///'):]), '^\u', '\l&', ''), '/', '\\', 'g')
  endfunction
else
  function! highlight_references#utils#filename_to_path_uniform(filename) abort
    return a:filename
  endfunction

  function! highlight_references#utils#uri_to_path_uniform(uri) abort
    return s:decode_uri(a:uri[len('file://'):])
  endfunction
endif

" ---

function! s:decode_uri(uri) abort
    let l:ret = substitute(a:uri, '[?#].*', '', '')
    return substitute(l:ret, '%\(\x\x\)', '\=printf("%c", str2nr(submatch(1), 16))', 'g')
endfunction
