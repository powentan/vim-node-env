" customize utilities for nodejs
if exists("g:nodejs_utilities")
    finish
endif
let g:nodejs_utilities = 1


fun g:GotoFile()
    let line = getline(".")
    let default_file = expand("<cfile>")
    let pattern = "require('" . default_file . "'"
    
    let open_file = ""
    if line =~ pattern
        let open_file = default_file . ".js"
    else
        let open_file = default_file
    endif

    let path = expand("%:p:h")
    " open file
    exec "edit " . path . "/" . open_file
endf

" override default function
map gf :call g:GotoFile()<CR>
