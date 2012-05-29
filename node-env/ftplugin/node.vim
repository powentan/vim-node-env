" customize utilities for nodejs
if exists("g:nodejs_utilities")
    finish
endif
let g:nodejs_utilities = 1


fun g:GotoFile()
    echo getpos(".")
    let line = getline(".")
    let default_file = expand("<cfile>")
    let pattern = "require('" . default_file . "'"
    
    echo line
    let open_file = ""
    if line =~ pattern
        let open_file = default_file . ".js"
    else
        let open_file = default_file
    endif

    echo open_file
    " open file
    exec "edit " . open_file
endf

" override default function
map gf :call g:GotoFile()<CR>
