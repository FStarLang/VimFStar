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

" This seems to be a common trope.
syn keyword fstarTodo contained TODO FIXME XXX NOTE

" Comments
syn region fstarLineComment start="//"hs=e+1  end="$" keepend contains=@Spell
syn region fstarRegionComment start="(\*"hs=e+1 end="\*)"he=s-1 contains=@Spell,fstarRegionComment,fstarTodo fold extend
hi def link fstarLineComment Comment
hi def link fstarRegionComment Comment

" keywords
syn keyword fstarAnnotation type val
hi def link fstarAnnotation Keyword
syn keyword fstarAssertion assert assume
hi def link fstarAssertion Debug
syn keyword fstarLambda fun
hi def link fstarLambda Keyword
syn keyword fstarLemma Lemma ensures requires decreases
hi def link fstarLemma Macro
syn keyword fstarLet let in and
hi def link fstarLet Keyword
syn keyword fstarQuantifier forall exists
hi def link fstarQuantifier Repeat

" builtin types and kinds
syn keyword fstarKinds Type S
hi def link fstarKinds Define
syn keyword fstarTypes nat int 
syn keyword fstarTypes list string
syn keyword fstarTypes bool unit 
hi def link fstarTypes Boolean
syn keyword fstarEffects Tot ML
hi def link fstarEffects Type
syn keyword fstarBoolean true false True False
hi def link fstarBoolean Boolean

" conditional statements
syn keyword fstarIf if then else
hi def link fstarKind Conditional
syn keyword fstarMatch match with
syn keyword fstarMatch function
hi def link fstarMatch Conditional

" modules
syn keyword fstarModule module open
hi def link fstarModule Include

" general identifiers.
" note: this pattern cannot end with a \> because it matches that before it
" will match a ', cutting the highlighting off early.
" todo: i'd like to be able to differentiate a pattern from a normal
" expression.
syn match fstarIdentifier "\<[a-zA-Z_][a-zA-Z0-9_']*"
hi def link fstarIdentifier Identifier

" todo: i'd like to differentiate this from module names.
syn match fstarConstructor "\<\u[a-zA-Z0-9_']*"
hi def link fstarConstructor Function

syn match fstarTypeVariable "'\l[a-zA-Z0-9_]*"
hi def link fstarTypeVariable Type

" operators
syn keyword fstarValueOperator not and or
hi def link fstarValueOperator Operator
syn match fstarWildcard "\<_\>"
hi def link fstarWildcard Operator

" literals
syn match fstarNumber "\<-\=\d\(_\|\d\)*\.\?\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"
syn match fstarNumber "\<-\=0[b|B]\([01]\|_\)\+[l|L|n]\?\>"
syn match fstarNumber "\<-\=0[o|O]\(\o\|_\)\+[l|L|n]\?\>"
syn match fstarNumber "\<-\=0[x|X]\(\x\|_\)\+[l|L|n]\?\>"
syn match fstarNumber "\<-\=\d\(_\|\d\)*[l|L|n]\?\>"
hi def link fstarNumber Number
" todo: the hs & he suffixes don't appear to be working here.
syn region fstarString start=+"+hs=e skip=+\\\\\|\\"+ end=+"+he=s contains=@Spell
hi def link fstarString String

"syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="(" matchgroup=ocamlKeyword end=")" contains=ALLBUT,@ocamlContained,ocamlParenErr
"syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="{" matchgroup=ocamlKeyword end="}"  contains=ALLBUT,@ocamlContained,ocamlBraceErr
"syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="\[" matchgroup=ocamlKeyword end="\]" contains=ALLBUT,@ocamlContained,ocamlBrackErr
"syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="\[|" matchgroup=ocamlKeyword end="|\]" contains=ALLBUT,@ocamlContained,ocamlArrErr

"syn match fstarDelimiter ","
"syn match fstarDelimiter "->"
"syn match fstarDelimiter ":"
"syn match fstarDelimiter ";"
"syn match fstarDelimiter "\."
"syn match fstarPascalCase /\<\u\w*\>/
"syn match fstarTypeOperator "/\\" " /\
"syn match fstarTypeOperator "\\/" " \/
"syn match fstarTypeOperator "<==>"
"syn match fstarTypeOperator "=="
"syn match fstarTypeOperator "==>"
"syn match fstarValueOperator "<"
"syn match fstarValueOperator "<="
"syn match fstarValueOperator "="
"syn match fstarValueOperator ">"
"syn match fstarValueOperator ">="

let b:current_syntax = "fstar"

" vim:set sts=3 sw=3 et ft=vim:
