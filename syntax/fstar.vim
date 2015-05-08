" Vim syntax file
" Language:     F*
" Filenames:    *.fst
" Maintainers:  Michael Lowell Roberts <mirobert at microsoft dot com>
" URL:          http://research.microsoft.com/en-us/projects/fstar/
"
" Based on the ocaml.vim syntax file distributed with Vim.
" Distributed under the VIM LICENSE. Please refer to the LICENSE file or
" visit <http://vimdoc.sourceforge.net/htmldoc/uganda.html> for details.

if version < 600
  syntax clear
elseif exists("b:current_syntax") && b:current_syntax == "fstar"
  finish
endif

" F* is case sensitive.
syn case match

syn keyword fstarAnnotation type val
syn keyword fstarAssertion assert assume
syn keyword fstarBoolTypes True False
syn keyword fstarBoolValues true false
syn keyword fstarBuiltin Some None
syn keyword fstarBuiltin nat int list bool unit string
syn keyword fstarEffect Tot ML
syn keyword fstarIf if then else
syn keyword fstarKind Type Kind S
syn keyword fstarLambda fun
syn keyword fstarLemma Lemma ensures requires decreases
syn keyword fstarLet let in and
syn keyword fstarMatch match with function
syn keyword fstarModule module open
syn keyword fstarQuantifier forall exists
syn keyword fstarValueOperator not and or
syn match fstarDelimiter ","
syn match fstarDelimiter "->"
syn match fstarDelimiter ":"
syn match fstarDelimiter ";"
syn match fstarDelimiter "\."
syn match fstarFloat "\<-\=\d\(_\|\d\)*\.\?\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"
syn match fstarNumber "\<-\=0[b|B]\([01]\|_\)\+[l|L|n]\?\>"
syn match fstarNumber "\<-\=0[o|O]\(\o\|_\)\+[l|L|n]\?\>"
syn match fstarNumber "\<-\=0[x|X]\(\x\|_\)\+[l|L|n]\?\>"
syn match fstarNumber "\<-\=\d\(_\|\d\)*[l|L|n]\?\>"
syn match fstarPascalCase /\<\u\w*\>/
syn match fstarTypeOperator "/\\" " /\
syn match fstarTypeOperator "\\/" " \/
syn match fstarTypeVariable /\<\('\|#\)\(\l\|_\)\w*\>/
syn match fstarVariable /\<\('\|#\)\@!\(\l\|_\)\(\w\|'\)*\>/
syn region fstarLineComment start="//" end="$" keepend contains=@Spell
syn region fstarRegionComment start="(\*" end="\*)" contains=@Spell fold extend
syn region fstarString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

hi def link fstarAnnotation Keyword
hi def link fstarAssertion Keyword
hi def link fstarBoolTypes Type
hi def link fstarBoolValues Boolean
hi def link fstarBuiltin Type
hi def link fstarDelimiter Delimiter
hi def link fstarEffect Type
hi def link fstarFloat Float
hi def link fstarIf Conditional
hi def link fstarKind Type
hi def link fstarLambda Keyword
hi def link fstarLemma Keyword
hi def link fstarLet Keyword
hi def link fstarLineComment Comment
hi def link fstarMatch Conditional
hi def link fstarModule PreProc
hi def link fstarNumber Number
hi def link fstarPascalCase Include
hi def link fstarQuantifier Repeat
hi def link fstarRegionComment Comment
hi def link fstarString String
hi def link fstarTypeVariable Statement
hi def link fstarVariable Identifier

"syn match fstarTypeOperator "<==>"
syn match fstarTypeOperator "=="
"syn match fstarTypeOperator "==>"
"syn match fstarValueOperator "<"
"syn match fstarValueOperator "<="
syn match fstarValueOperator "="
"syn match fstarValueOperator ">"
"syn match fstarValueOperator ">="

hi def link fstarTypeOperator Function
hi def link fstarValueOperator Type

let b:current_syntax = "fstar"

" vim:set sts=3 sw=3 et ft=vim:
