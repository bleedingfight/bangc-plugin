au BufNewFile,BufRead *.mlu set filetype=mlu
syntax keyword bangcKeyword loop times to while
syntax keyword bangcKeyword if elsif else
syntax keyword bangcKeyword class return

syntax keyword bangcFunction print join string

highlight link bangcKeyword Keyword
highlight link bangcFunction Function
