
command! -nargs=* WsonConfig call wenyan#wson#config(<f-args>)
command! -nargs=? WsonEncode call wenyan#wson#encode(<q-args>)
command! -nargs=? WsonDecode call wenyan#wson#decode(<q-args>)

" Func: #load
function! wenyan#plugin#load() abort
    return 1
endfunction
