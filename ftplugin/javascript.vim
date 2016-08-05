" customize utilities for nodejs
" if !exists("g:node_env")
  " finish
" endif

if exists("g:nodejs_utilities")
    finish
endif
let g:nodejs_utilities = 1
" debug flag
let s:debug = 0

fun Debug(msg)
    if !s:debug 
        return
    endif
    echo a:msg
endf

fun s:GotoEs6Module()
endf

fun s:GotoCommonJsModule(file)
    let filename = a:file
    if fnamemodify(expand("<cfile>"), ":e") != "js"
        let filename = filename . ".js"
    endif

    " switch current directory to the path of open file(follows symbolic link)
    let open_file_dir = fnamemodify(resolve(expand('%')), ':p:h')
    call Debug('file path = ' . open_file_dir)
    exec 'lcd ' . open_file_dir

    " FIXME: workaround for windows
    let module_paths = ['./node_modules']

    if !has('win32')
      let path_str = system("node -e 'console.log(module.paths)'")
      let module_paths = eval(substitute(path_str, nr2char(10), '', 'g'))
    endif

    " Add open file dir to module paths
    call add(module_paths, open_file_dir)
    call Debug(module_paths)

    call Debug("filename = " . filename)
    let filename = resolve(expand(filename))
    call Debug("expand filename = " . filename)
    let abs_path = ''
    let abs_paths = uniq(globpath(join(module_paths, ","), filename, 0, 1))
    if(!empty(abs_paths))
        let abs_path = abs_paths[0]
    endif

    if abs_path != ""
        if isdirectory(abs_path)
            exec "edit! " . abs_path . "/index.js"
        endif
    else
        " return a list of all avaliable paths
        let abs_paths = globpath(join(module_paths, ","), a:file . "/index.js", 0, 1)
        if len(abs_paths) == 0
            let abs_paths = globpath(join(module_paths, ","), a:file . "/" . a:file . ".js", 0, 1)
        endif
        if len(abs_paths) != 0
            let abs_path = resolve(abs_paths[0])
        endif
    endif
    call Debug("abs_path = " . abs_path)

    if(abs_path != '')
        exec "silent edit! " . abs_path
    endif
endf

fun g:GotoFile()
    let line = getline(".")
    let default_file = expand("<cfile>")
    let require_pattern = "require(\\s*['\"]" . default_file . "['\"]\\s*"
    
    " let filename = ""
    " if line =~ require_pattern
    call s:GotoCommonJsModule(default_file)
    " elseif 0
    " endif

endf

" override default function
map gf :call g:GotoFile()<CR>

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

" 
if exists("g:tern#command") && &filetype == "javascript" 
    nmap <C-]> :TernDef<CR>
endif
