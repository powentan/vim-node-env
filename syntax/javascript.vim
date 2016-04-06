" nodejs syntax file
if exists("b:current_syntax") && exists("g:node_env")
  finish
endif

" setup keywords
syn keyword nodeKeyword require exports
syn match nodeSharpBang "^#!.*"

" highlight
hi def link nodeKeyword keyword
hi def link nodeSharpBang PreProc

" let b:current_syntax = "node"
