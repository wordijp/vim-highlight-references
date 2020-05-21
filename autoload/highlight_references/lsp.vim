let s:NULL_TYPE = 7

function! highlight_references#lsp#add_response(data) abort
  if !has_key(a:data['response'], 'result') | return | endif
  
  let l:result = a:data['response']['result']
  if type(l:result) == s:NULL_TYPE && l:result == v:null | return | endif
  if len(l:result) == 0 | return | endif

  let l:req_path = has_key(a:data['request']['params']['textDocument'], 'filename')
        \ ? highlight_references#utils#filename_to_path_uniform(a:data['request']['params']['textDocument']['filename'])
        \ : highlight_references#utils#uri_to_path_uniform(a:data['request']['params']['textDocument']['uri'])

  let l:poses = []
  if has_key(l:result[0], 'targetUri')
    let l:poses = map(filter(l:result, "highlight_references#utils#uri_to_path_uniform(v:val['targetUri']) == l:req_path"),
        \ "[".
        \   "v:val['targetSelectionRange']['start']['line'] + 1,".
        \   "v:val['targetSelectionRange']['start']['character'] + 1,".
        \   "v:val['targetSelectionRange']['end']['character'] - v:val['targetSelectionRange']['start']['character']".
        \ "]")
  elseif has_key(l:result[0], 'uri')
    let l:poses = map(filter(l:result, "highlight_references#utils#uri_to_path_uniform(v:val['uri']) == l:req_path"),
        \ "[".
        \   "v:val['range']['start']['line'] + 1,".
        \   "v:val['range']['start']['character'] + 1,".
        \   "v:val['range']['end']['character'] - v:val['range']['start']['character']".
        \ "]")
  else
    let l:poses = map(l:result,
        \ "[".
        \   "v:val['range']['start']['line'] + 1,".
        \   "v:val['range']['start']['character'] + 1,".
        \   "v:val['range']['end']['character'] - v:val['range']['start']['character']".
        \ "]")
  endif

  call s:add_matchaddpos(l:poses)
endfunction

function! s:add_matchaddpos(poses) abort
  if !exists('w:highlight_references_matchaddpos_id')
    let w:highlight_references_matchaddpos_id = []
  endif

  let l:i = 0
  let l:size = len(a:poses)
  while l:i < l:size
    let l:ids = matchaddpos('highlightReference', a:poses[l:i : l:i + 7], 0)
    call add(w:highlight_references_matchaddpos_id, l:ids)
    let l:i += 8
  endwhile
endfunction

function! highlight_references#lsp#clear_highlight() abort
  if exists('w:highlight_references_matchaddpos_id')
    for l:x in w:highlight_references_matchaddpos_id
      call matchdelete(l:x)
    endfor
    unlet w:highlight_references_matchaddpos_id
  endif
endfunction
