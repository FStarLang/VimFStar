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
syn keyword fstarTodo contained TODO todo FIXME XXX NOTE
hi def link fstarTodo Todo

" keywords
syn keyword fstarAnnotation type val
hi def link fstarAnnotation Keyword
syn keyword fstarAssertion assert assume
hi def link fstarAssertion Keyword
syn keyword fstarLambda fun
hi def link fstarLambda Keyword
syn keyword fstarLemma Lemma ensures requires decreases
hi def link fstarLemma keyword
syn keyword fstarLet let in and rec
hi def link fstarLet Keyword
syn keyword fstarQuantifier forall exists
hi def link fstarQuantifier Repeat

" builtin types and kinds
syn keyword fstarBuiltinKinds Type S
hi def link fstarBuiltinKinds Type
syn keyword fstarBuiltinTypes nat int 
syn keyword fstarBuiltinTypes list string
syn keyword fstarBuiltinTypes bool unit 
syn keyword fstarBuiltinTypes option
hi def link fstarBuiltinTypes Type
syn keyword fstarBuiltinEffects Tot ML 
hi def link fstarBuiltinEffects Type
syn keyword fstarBooleansAsValue true false 
hi def link fstarBooleansAsValue Boolean
syn keyword fstarBooleansAsType True False
hi def link fstarBooleansAsType Boolean

" conditional statements
syn keyword fstarIf if then else
hi def link fstarIf Conditional
syn keyword fstarMatch match with
syn keyword fstarMatch function
hi def link fstarMatch Conditional

" modules
syn keyword fstarModule module open
hi def link fstarModule Include

" note: lower priority matches & regions should be listed first.

" general identifiers.
" note: this pattern cannot end with a \> because it matches that before it
" will match a ', cutting the highlighting off early.
" todo: i'd like to be able to differentiate a pattern from a normal
" expression.
syn match fstarIdentifier "\<[a-zA-Z_][a-zA-Z0-9_']*"
hi def link fstarIdentifier Identifier

" todo: i'd like to differentiate this from module names.
syn match fstarConstructor "\<\u[a-zA-Z0-9_']*"
hi def link fstarConstructor Identifier

syn match fstarTypeVariable "'\l[a-zA-Z0-9_]*"
hi def link fstarTypeVariable Identifier

syn match fstarInferPrefix "#"
hi def link fstarInferPrefix StorageClass

syn match fstarWildcard "\<_\>"
hi def link fstarWildcard Identifier

" operators
syn keyword fstarValueOperator not and or
syn match fstarValueOperator "<"
syn match fstarValueOperator ">"
syn match fstarValueOperator "="
syn match fstarValueOperator "*"
syn match fstarValueOperator "/"
syn match fstarValueOperator "+"
syn match fstarValueOperator "-"
syn match fstarValueOperator "<>"
syn match fstarTypeOperator "\~"
syn match fstarTypeOperator "/\\"
syn match fstarTypeOperator "\\/"
syn match fstarTypeOperator "=="
syn match fstarTypeOperator "==>"
syn match fstarTypeOperator "<==>"
hi def link fstarValueOperator Operator
hi def link fstarTypeOperator Operator

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

" Comments
syn region fstarLineComment start="//"hs=e+1  end="$" keepend contains=@Spell
syn region fstarRegionComment start="(\*"hs=e+1 end="\*)"he=s-1 contains=@Spell,fstarRegionComment,fstarTodo fold extend
hi def link fstarLineComment Comment
hi def link fstarRegionComment Comment

let b:current_syntax = "fstar"

" vim:set sts=3 sw=3 et ft=vim:
