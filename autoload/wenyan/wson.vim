" File: wson
" Author: lymslive
" Description: wenyan-json
" Create: 2020-01-12
" Modify: 2020-01-12

let s:Wson = v:null
let s:dOption = {'simple':0, 'pretty':0}

" Func: s:get_wson 
function! s:get_wson() abort
    if empty(s:Wson)
        let l:CWson = g:wenyan#CWson#space.class
        let s:Wson = l:CWson.new(s:dOption)
    endif
    return s:Wson
endfunction

" Func: s:config 
function! s:config(args) abort
    let l:option = {}
    for l:arg in a:args
        let l:tokens = split(l:arg, '=')
        if len(l:tokens) < 1
            continue
        endif
        let l:key = l:tokens[0]
        let l:val = 1
        if len(l:tokens) >= 2
            let l:val = l:tokens[1]
        endif
        let l:option[l:key] = l:val
    endfor
    if !empty(l:option)
        let l:CWson = g:wenyan#CWson#space.class
        let s:Wson = l:CWson.new(l:option)
    endif
endfunction

" Func: #config 
function! wenyan#wson#config(...) abort
    return s:config(a:000)
endfunction

" Func: #encode 
function! wenyan#wson#encode(text) abort
    if empty(a:text)
        return s:encode_json_buffer()
    endif
    let l:wson = s:encode_json_text(a:text)
    echo l:wson
    return l:wson
endfunction

" Func: s:encode_json_buffer 
function! s:encode_json_buffer() abort
    let l:lines = getline(1, '$')
    let l:text = join(l:lines, '')
    let l:wson = s:encode_json_text(l:text)
    let l:file = s:saveas_file('wson')
    if 0 == writefile(split(l:wson, "\n"), l:file)
        execute 'edit ' . l:file
    endif
    return l:wson
endfunction

" Func: s:encode_json_text 
" json text -> wson text
function! s:encode_json_text(text) abort
    " let l:json = json_decode(a:text)
    " return s:encode(l:json)
    let l:wson = s:get_wson()
    return l:wson.encode_source(a:text)
endfunction

" Func: #decode 
function! wenyan#wson#decode(text) abort
    if empty(a:text)
        return s:decode_json_buffer()
    endif
    let l:wson = s:decode_json_text(a:text)
    echo l:wson
    return l:wson
endfunction

" Func: s:decode_json_buffer 
function! s:decode_json_buffer() abort
    let l:lines = getline(1, '$')
    let l:text = join(l:lines, '')
    let l:json = s:decode_json_text(l:text)
    let l:file = s:saveas_file('json')
    if 0 == writefile(split(l:json, "\n"), l:file)
        execute 'edit ' . l:file
    endif
    return l:json
endfunction

" Func: s:decode_json_text 
" wson text -> json text
function! s:decode_json_text(text) abort
    let l:wson = s:get_wson()
    return l:wson.decode_source(a:text)
endfunction

" Func: s:saveas_file 
" find a suitable filename to save as with another extention
" no overwrite solve confict by add .1 .2 before extention
function! s:saveas_file(ext) abort
    let l:fileroot = expand('%:p:r')
    let l:filename = l:fileroot . '.' . a:ext
    let l:number = 0
    while filereadable(l:filename)
        let l:number += 1
        let l:filename = printf('%s_%d.%s', l:fileroot, l:number, a:ext)
    endwhile
    return l:filename
endfunction

finish
