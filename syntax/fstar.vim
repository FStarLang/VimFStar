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

" OCaml is case sensitive.
syn case match

" Access to the method of an object
syn match    fstarMethod       "#"

" Script headers highlighted like comments
syn match    fstarComment   "^#!.*" contains=@Spell

" Scripting directives
syn match    fstarScript "^#\<\(quit\|labels\|warnings\|directory\|cd\|load\|use\|install_printer\|remove_printer\|require\|thread\|trace\|untrace\|untrace_all\|print_depth\|print_length\|camlp4o\)\>"

" lowercase identifier - the standard way to match
syn match    fstarLCIdentifier /\<\(\l\|_\)\(\w\|'\)*\>/

syn match    fstarKeyChar    "|"

" Errors
syn match    fstarBraceErr   "}"
syn match    fstarBrackErr   "\]"
syn match    fstarParenErr   ")"
syn match    fstarArrErr     "|]"

syn match    fstarCommentErr "\*)"

syn match    fstarCountErr   "\<downto\>"
syn match    fstarCountErr   "\<to\>"

if !exists("fstar_revised")
  syn match    fstarDoErr      "\<do\>"
endif

syn match    fstarDoneErr    "\<done\>"
syn match    fstarThenErr    "\<then\>"

" Error-highlighting of "end" without synchronization:
" as keyword or as error (default)
if exists("fstar_noend_error")
  syn match    fstarKeyword    "\<end\>"
else
  syn match    fstarEndErr     "\<end\>"
endif

" Some convenient clusters
syn cluster  fstarAllErrs contains=fstarBraceErr,fstarBrackErr,fstarParenErr,fstarCommentErr,fstarCountErr,fstarDoErr,fstarDoneErr,fstarEndErr,fstarThenErr

syn cluster  fstarAENoParen contains=fstarBraceErr,fstarBrackErr,fstarCommentErr,fstarCountErr,fstarDoErr,fstarDoneErr,fstarEndErr,fstarThenErr

syn cluster  fstarContained contains=fstarTodo,fstarPreDef,fstarModParam,fstarModParam1,fstarPreMPRestr,fstarMPRestr,fstarMPRestr1,fstarMPRestr2,fstarMPRestr3,fstarModRHS,fstarFuncWith,fstarFuncStruct,fstarModTypeRestr,fstarModTRWith,fstarWith,fstarWithRest,fstarModType,fstarFullMod,fstarVal


" Enclosing delimiters
syn region   fstarEncl transparent matchgroup=fstarKeyword start="(" matchgroup=fstarKeyword end=")" contains=ALLBUT,@fstarContained,fstarParenErr
syn region   fstarEncl transparent matchgroup=fstarKeyword start="{" matchgroup=fstarKeyword end="}"  contains=ALLBUT,@fstarContained,fstarBraceErr
syn region   fstarEncl transparent matchgroup=fstarKeyword start="\[" matchgroup=fstarKeyword end="\]" contains=ALLBUT,@fstarContained,fstarBrackErr
syn region   fstarEncl transparent matchgroup=fstarKeyword start="\[|" matchgroup=fstarKeyword end="|\]" contains=ALLBUT,@fstarContained,fstarArrErr


" Comments
syn region   fstarComment start="(\*" end="\*)" contains=@Spell,fstarComment,fstarTodo
syn match    fstarComment "//.*$" contains=fstarComment,fstarTodo,@Spell
syn keyword  fstarTodo contained TODO FIXME XXX NOTE


" Objects
syn region   fstarEnd matchgroup=fstarObject start="\<object\>" matchgroup=fstarObject end="\<end\>" contains=ALLBUT,@fstarContained,fstarEndErr


" Blocks
if !exists("fstar_revised")
  syn region   fstarEnd matchgroup=fstarKeyword start="\<begin\>" matchgroup=fstarKeyword end="\<end\>" contains=ALLBUT,@fstarContained,fstarEndErr
endif


" "for"
syn region   fstarNone matchgroup=fstarKeyword start="\<for\>" matchgroup=fstarKeyword end="\<\(to\|downto\)\>" contains=ALLBUT,@fstarContained,fstarCountErr


" "do"
if !exists("fstar_revised")
  syn region   fstarDo matchgroup=fstarKeyword start="\<do\>" matchgroup=fstarKeyword end="\<done\>" contains=ALLBUT,@fstarContained,fstarDoneErr
endif

" "if"
syn region   fstarNone matchgroup=fstarKeyword start="\<if\>" matchgroup=fstarKeyword end="\<then\>" contains=ALLBUT,@fstarContained,fstarThenErr


"" Modules

" "sig"
syn region   fstarSig matchgroup=fstarModule start="\<sig\>" matchgroup=fstarModule end="\<end\>" contains=ALLBUT,@fstarContained,fstarEndErr,fstarModule
syn region   fstarModSpec matchgroup=fstarKeyword start="\<module\>" matchgroup=fstarModule end="\<\u\(\w\|'\)*\>" contained contains=@fstarAllErrs,fstarComment skipwhite skipempty nextgroup=fstarModTRWith,fstarMPRestr

" "open"
syn region   fstarNone matchgroup=fstarKeyword start="\<open\>" matchgroup=fstarModule end="\<\u\(\w\|'\)*\( *\. *\u\(\w\|'\)*\)*\>" contains=@fstarAllErrs,fstarComment

" "include"
syn match    fstarKeyword "\<include\>" skipwhite skipempty nextgroup=fstarModParam,fstarFullMod

" "module" - somewhat complicated stuff ;-)
syn region   fstarModule matchgroup=fstarKeyword start="\<module\>" matchgroup=fstarModule end="\<\u\(\w\|'\)*\>" contains=@fstarAllErrs,fstarComment skipwhite skipempty nextgroup=fstarPreDef
syn region   fstarPreDef start="."me=e-1 matchgroup=fstarKeyword end="\l\|=\|)"me=e-1 contained contains=@fstarAllErrs,fstarComment,fstarModParam,fstarModTypeRestr,fstarModTRWith nextgroup=fstarModPreRHS
syn region   fstarModParam start="([^*]" end=")" contained contains=@fstarAENoParen,fstarModParam1,fstarVal
syn match    fstarModParam1 "\<\u\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=fstarPreMPRestr

syn region   fstarPreMPRestr start="."me=e-1 end=")"me=e-1 contained contains=@fstarAllErrs,fstarComment,fstarMPRestr,fstarModTypeRestr

syn region   fstarMPRestr start=":" end="."me=e-1 contained contains=@fstarComment skipwhite skipempty nextgroup=fstarMPRestr1,fstarMPRestr2,fstarMPRestr3
syn region   fstarMPRestr1 matchgroup=fstarModule start="\ssig\s\=" matchgroup=fstarModule end="\<end\>" contained contains=ALLBUT,@fstarContained,fstarEndErr,fstarModule
syn region   fstarMPRestr2 start="\sfunctor\(\s\|(\)\="me=e-1 matchgroup=fstarKeyword end="->" contained contains=@fstarAllErrs,fstarComment,fstarModParam skipwhite skipempty nextgroup=fstarFuncWith,fstarMPRestr2
syn match    fstarMPRestr3 "\w\(\w\|'\)*\( *\. *\w\(\w\|'\)*\)*" contained
syn match    fstarModPreRHS "=" contained skipwhite skipempty nextgroup=fstarModParam,fstarFullMod
syn keyword  fstarKeyword val
syn region   fstarVal matchgroup=fstarKeyword start="\<val\>" matchgroup=fstarLCIdentifier end="\<\l\(\w\|'\)*\>" contains=@fstarAllErrs,fstarComment,fstarFullMod skipwhite skipempty nextgroup=fstarMPRestr
syn region   fstarModRHS start="." end=". *\w\|([^*]"me=e-2 contained contains=fstarComment skipwhite skipempty nextgroup=fstarModParam,fstarFullMod
syn match    fstarFullMod "\<\u\(\w\|'\)*\( *\. *\u\(\w\|'\)*\)*" contained skipwhite skipempty nextgroup=fstarFuncWith

syn region   fstarFuncWith start="([^*]"me=e-1 end=")" contained contains=fstarComment,fstarWith,fstarFuncStruct skipwhite skipempty nextgroup=fstarFuncWith
syn region   fstarFuncStruct matchgroup=fstarModule start="[^a-zA-Z]struct\>"hs=s+1 matchgroup=fstarModule end="\<end\>" contains=ALLBUT,@fstarContained,fstarEndErr

syn match    fstarModTypeRestr "\<\w\(\w\|'\)*\( *\. *\w\(\w\|'\)*\)*\>" contained
syn region   fstarModTRWith start=":\s*("hs=s+1 end=")" contained contains=@fstarAENoParen,fstarWith
syn match    fstarWith "\<\(\u\(\w\|'\)* *\. *\)*\w\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=fstarWithRest
syn region   fstarWithRest start="[^)]" end=")"me=e-1 contained contains=ALLBUT,@fstarContained

" "struct"
syn region   fstarStruct matchgroup=fstarModule start="\<\(module\s\+\)\=struct\>" matchgroup=fstarModule end="\<end\>" contains=ALLBUT,@fstarContained,fstarEndErr

" "module type"
syn region   fstarKeyword start="\<module\>\s*\<type\>\(\s*\<of\>\)\=" matchgroup=fstarModule end="\<\w\(\w\|'\)*\>" contains=fstarComment skipwhite skipempty nextgroup=fstarMTDef
syn match    fstarMTDef "=\s*\w\(\w\|'\)*\>"hs=s+1,me=s+1 skipwhite skipempty nextgroup=fstarFullMod

syn keyword  fstarKeyword  and as assume assert
syn keyword  fstarKeyword  constraint decreases else ensures
syn keyword  fstarKeyword  exception external fun

syn keyword  fstarKeyword  in inherit initializer
syn keyword  fstarKeyword  land lazy let logic match
syn keyword  fstarKeyword  method mutable new of opaque
syn keyword  fstarKeyword  parser pattern private raise rec requires
syn keyword  fstarKeyword  try type
syn keyword  fstarKeyword  virtual when while with

syn keyword  fstarBoolean  True False
syn keyword  fstarKeyword  function
syn keyword  fstarBoolean  true false
syn match    fstarKeyChar  "!"

syn keyword  fstarType     array bool char exn float format format4
syn keyword  fstarType     nat int int32 int64 lazy_t list nativeint option
syn keyword  fstarType     string unit
syn keyword fstarType set map forall exists

syn keyword  fstarOperator asr lnot lor lsl lsr lxor mod not

syn match    fstarConstructor  "(\s*)"
syn match    fstarConstructor  "\[\s*\]"
syn match    fstarConstructor  "\[|\s*>|]"
syn match    fstarConstructor  "\[<\s*>\]"
syn match    fstarConstructor  "\u\(\w\|'\)*\>"

" Polymorphic variants
syn match    fstarConstructor  "`\w\(\w\|'\)*\>"

" Module prefix
syn match    fstarModPath      "\u\(\w\|'\)* *\."he=e-1

syn match    fstarCharacter    "'\\\d\d\d'\|'\\[\'ntbr]'\|'.'"
syn match    fstarCharacter    "'\\x\x\x'"
syn match    fstarCharErr      "'\\\d\d'\|'\\\d'"
syn match    fstarCharErr      "'\\[^\'ntbr]'"
syn region   fstarString       start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

syn match    fstarFunDef       "->"
syn match    fstarRefAssign    ":="
syn match    fstarTopStop      ";;"
syn match    fstarOperator     "\^"
syn match    fstarOperator     "::"
syn match    fstarOperator     ":"

syn match fstarOperator "\\/"
syn match fstarOperator "/\\"
syn match    fstarOperator     "&&"
syn match    fstarOperator     "<"
syn match    fstarOperator     ">"
syn match fstarOperator "\<\>"
syn match    fstarAnyVar       "\<_\>"
syn match    fstarKeyChar      "|[^\]]"me=e-1
syn match    fstarKeyChar      ";"
syn match    fstarKeyChar      "\~"
syn match    fstarKeyChar      "?"
syn match    fstarKeyChar      "\*"
syn match    fstarKeyChar      "="

if exists("fstar_revised")
  syn match    fstarErr        "<-"
else
  syn match    fstarOperator   "<-"
endif

syn match    fstarNumber        "\<-\=\d\(_\|\d\)*[l|L|n]\?\>"
syn match    fstarNumber        "\<-\=0[x|X]\(\x\|_\)\+[l|L|n]\?\>"
syn match    fstarNumber        "\<-\=0[o|O]\(\o\|_\)\+[l|L|n]\?\>"
syn match    fstarNumber        "\<-\=0[b|B]\([01]\|_\)\+[l|L|n]\?\>"
syn match    fstarFloat         "\<-\=\d\(_\|\d\)*\.\?\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"

" Labels
syn match    fstarLabel        "\~\(\l\|_\)\(\w\|'\)*"lc=1
syn match    fstarLabel        "?\(\l\|_\)\(\w\|'\)*"lc=1
syn region   fstarLabel transparent matchgroup=fstarLabel start="?(\(\l\|_\)\(\w\|'\)*"lc=2 end=")"me=e-1 contains=ALLBUT,@fstarContained,fstarParenErr


" Synchronization
syn sync minlines=50
syn sync maxlines=500

if !exists("fstar_revised")
  syn sync match fstarDoSync      grouphere  fstarDo      "\<do\>"
  syn sync match fstarDoSync      groupthere fstarDo      "\<done\>"
endif

if exists("fstar_revised")
  syn sync match fstarEndSync     grouphere  fstarEnd     "\<\(object\)\>"
else
  syn sync match fstarEndSync     grouphere  fstarEnd     "\<\(begin\|object\)\>"
endif

syn sync match fstarEndSync     groupthere fstarEnd     "\<end\>"
syn sync match fstarStructSync  grouphere  fstarStruct  "\<struct\>"
syn sync match fstarStructSync  groupthere fstarStruct  "\<end\>"
syn sync match fstarSigSync     grouphere  fstarSig     "\<sig\>"
syn sync match fstarSigSync     groupthere fstarSig     "\<end\>"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_fstar_syntax_inits")
  if version < 508
    let did_fstar_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink fstarBraceErr	   Error
  HiLink fstarBrackErr	   Error
  HiLink fstarParenErr	   Error
  HiLink fstarArrErr	   Error

  HiLink fstarCommentErr   Error

  HiLink fstarCountErr	   Error
  HiLink fstarDoErr	   Error
  HiLink fstarDoneErr	   Error
  HiLink fstarEndErr	   Error
  HiLink fstarThenErr	   Error

  HiLink fstarCharErr	   Error

  HiLink fstarErr	   Error

  HiLink fstarComment	   Comment

  HiLink fstarModPath	   Include
  HiLink fstarObject	   Include
  HiLink fstarModule	   Include
  HiLink fstarModParam1    Include
  HiLink fstarModType	   Include
  HiLink fstarMPRestr3	   Include
  HiLink fstarFullMod	   Include
  HiLink fstarModTypeRestr Include
  HiLink fstarWith	   Include
  HiLink fstarMTDef	   Include

  HiLink fstarScript	   Include

  HiLink fstarConstructor  Constant

  HiLink fstarVal          Keyword
  HiLink fstarModPreRHS    Keyword
  HiLink fstarMPRestr2	   Keyword
  HiLink fstarKeyword	   Keyword
  HiLink fstarMethod	   Include
  HiLink fstarFunDef	   Keyword
  HiLink fstarRefAssign    Keyword
  HiLink fstarKeyChar	   Keyword
  HiLink fstarAnyVar	   Keyword
  HiLink fstarTopStop	   Keyword
  HiLink fstarOperator	   Keyword

  HiLink fstarBoolean	   Boolean
  HiLink fstarCharacter    Character
  HiLink fstarNumber	   Number
  HiLink fstarFloat	   Float
  HiLink fstarString	   String

  HiLink fstarLabel	   Identifier

  HiLink fstarType	   Type

  HiLink fstarTodo	   Todo

  HiLink fstarEncl	   Keyword

  delcommand HiLink
endif

let b:current_syntax = "fstar"

" vim: ts=8
