fun! CheckNodejs()
    let set_flag = 0
    let first_line = getline(1)
    if expand("%:e") == "js"
        let set_flag = 1
    elseif first_line =~"^#!.*node"
        let set_flag = 1
    endif

    if set_flag == 1
        setlocal filetype=node
    endif
endf

autocmd! BufRead,BufNewFile * call CheckNodejs()

function! EnhCommentifyCallback(ft)
    if a:ft == 'node'
        let b:ECcommentOpen = '//'
        let b:ECcommentClose = ''
    elseif a:ft == 'jade'
        let b:ECcommentOpen = '//'
        let b:ECcommentClose = ''
    endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

