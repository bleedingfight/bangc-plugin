" Vim syntex file
" Language:  bangc
" Maintainer: bleedingfight <bleedingfight@gmail.com>
" Last Change: 2021 Dec 5
" 如果加载了高亮语法
if exists("b:current_syntax")
    finish
endif

echom "Bangc syntax highlighting code will go here."

let b:current_syntax = "mlu"
let s:ft = matchstr(&ft, '^\([^.]\)\+')
let s:cpo_save = &cpo

" 循环关键字高亮
syntax keyword bangcRepeat while for do
" 条件关键字高亮
syntax keyword bangcCondition if elsif else for do swith
" 语言特性高亮
syntax keyword bangcKeyword class return
" 函数名称高亮
" 控制流高亮
syntax keyword bangcStatement goto break return continue asm __asm__
syntax keyword bangcLabel case default
syntax keyword bangcTodo         contained TODO FIXME XXX

syntax keyword bangcFunction print join string __bang_printf

highlight link bangcKeyword Keyword
highlight link bangcFunction Function
syntax match bangcComment "\v\\.*$"
highlight link bangcComment Comment

syntax match bangcOperator "\v\*"
syntax match bangcOperator "\v/"
syntax match bangcOperator "\v\+"
syntax match bangcOperator "\v-"
syntax match bangcOperator "\v\?"
syntax match bangcOperator "\v\*\="
syntax match bangcOperator "\v/\="
syntax match bangcOperator "\v\+\="
syntax match bangcOperator "\v-\="

highlight link bangcOperator Operator

syntax region bangcString start=/\v"/ skip=/\v\\./ end=/\v"/
highlight link bangcString String

" It's easy to accidentally add a space after a backslash that was intended
" for line continuation.  Some compilers allow it, which makes it
" unpredictable and should be avoided.
syn match       bangcBadContinuation contained "\\\s\+$"

" cCommentGroup allows adding matches for special things in comments
syn cluster     bangcCommentGroup   contains=bangcTodo,bangcBadContinuation

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match       bangcSpecial        display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match     bangcSpecial        display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif

if !exists("c_no_cformat")
  " Highlight % items in strings.
  if !exists("c_no_c99") " ISO C99
    syn match   bangcFormat         display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match   bangcFormat         display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match     bangcFormat         display "%%" contained
endif

" bangcCppString: same as bangcString, but ends at end of line
let s:in_cpp_family = exists("b:filetype_in_cpp_family") 
if s:in_cpp_family && !exists("cpp_no_cpp11") && !exists("c_no_cformat")
  " ISO C++11
  syn region    bangcString         start=+\(L\|u\|u8\|U\|R\|LR\|u8R\|uR\|UR\)\="+ skip=+\\\\\|\\"+ end=+"+ contains=bangcSpecial,bangcFormat,@Spell extend
  syn region    bangcCppString      start=+\(L\|u\|u8\|U\|R\|LR\|u8R\|uR\|UR\)\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=bangcSpecial,bangcFormat,@Spell
elseif s:ft ==# "mlu" && !exists("c_no_c11") && !exists("c_no_cformat")
  " ISO C99
  syn region    bangcString         start=+\%(L\|U\|u8\)\="+ skip=+\\\\\|\\"+ end=+"+ contains=bangcSpecial,bangcFormat,@Spell extend
  syn region    bangcCppString      start=+\%(L\|U\|u8\)\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=bangcSpecial,bangcFormat,@Spell
else
  " older C or C++
  syn match     bangcFormat         display "%%" contained
  syn region    bangcString         start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=bangcSpecial,bangcFormat,@Spell extend
  syn region    bangcCppString      start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=bangcSpecial,bangcFormat,@Spell
endif

syn region      bangcCppSkip        contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=bangcSpaceError,bangcCppSkip

syn cluster     bangcStringGroup    contains=bangcCppString,bangcCppSkip

syn match       bangcCharacter      "L\='[^\\]'"
syn match       bangcCharacter      "L'[^']*'" contains=bangcSpecial
if exists("c_gnu")
  syn match     bangcSpecialError   "L\='\\[^'\"?\\abefnrtv]'"
  syn match     bangcSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match     bangcSpecialError   "L\='\\[^'\"?\\abfnrtv]'"
  syn match     bangcSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match       bangcSpecialCharacter display "L\='\\\o\{1,3}'"
syn match       bangcSpecialCharacter display "'\\x\x\{1,2}'"
syn match       bangcSpecialCharacter display "L'\\x\x\+'"

if (s:ft ==# "c" && !exists("c_no_c11")) || (s:in_cpp_family && !exists("cpp_no_cpp11"))
  " ISO C11 or ISO C++ 11
  if exists("c_no_cformat")
    syn region  bangcString         start=+\%(U\|u8\=\)"+ skip=+\\\\\|\\"+ end=+"+ contains=bangcSpecial,@Spell extend
  else
    syn region  bangcString         start=+\%(U\|u8\=\)"+ skip=+\\\\\|\\"+ end=+"+ contains=bangcSpecial,bangcFormat,@Spell extend
  endif
  syn match     bangcCharacter      "[Uu]'[^\\]'"
  syn match     bangcCharacter      "[Uu]'[^']*'" contains=bangcSpecial
  if exists("c_gnu")
    syn match   bangcSpecialError   "[Uu]'\\[^'\"?\\abefnrtv]'"
    syn match   bangcSpecialCharacter "[Uu]'\\['\"?\\abefnrtv]'"
  else
    syn match   bangcSpecialError   "[Uu]'\\[^'\"?\\abfnrtv]'"
    syn match   bangcSpecialCharacter "[Uu]'\\['\"?\\abfnrtv]'"
  endif
  syn match     bangcSpecialCharacter display "[Uu]'\\\o\{1,3}'"
  syn match     bangcSpecialCharacter display "[Uu]'\\x\x\+'"
endif

"when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match   bangcSpaceError     display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match   bangcSpaceError     display " \+\t"me=e-1
  endif
endif

" This should be before bangcErrInParen to avoid problems with #define ({ xxx })
if exists("c_curly_error")
  syn match bangcCurlyError "}"
  syn region    bangcBlock          start="{" end="}" contains=ALLBUT,bangcBadBlock,bangcCurlyError,@bangcParenGroup,bangcErrInParen,bangcCppParen,bangcErrInBracket,cCppBracket,@bangcStringGroup,@Spell fold
else
  syn region    bangcBlock          start="{" end="}" transparent fold
endif

" Catch errors caused by wrong parenthesis and brackets.
" Also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster     bangcParenGroup     contains=bangcParenError,bangcIncluded,bangcSpecial,bangcCommentSkip,bangcCommentString,bangcComment2String,@bangcCommentGroup,bangcCommentStartError,bangcUserLabel,bangcBitField,bangcOctalZero,@bangcCppOutInGroup,bangcFormat,bangcNumber,bangcFloat,bangcOctal,bangcOctalError,bangcNumbersCom
if exists("c_no_curly_error")
  if s:in_cpp_family && !exists("cpp_no_cpp11")
    syn region  bangcParen          transparent start='(' end=')' contains=ALLBUT,@bangcParenGroup,bangcCppParen,@bangcStringGroup,@Spell
    " bangcCppParen: same as bangcParen but ends at end-of-line; used in bangcDefine
    syn region  bangcCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcParen,bangcString,@Spell
    syn match   bangcParenError     display ")"
    syn matbangch   bangcErrInParen     display contained "^^<%\|^%>"
  else
    syn region  bangcParen          transparent start='(' end=')' contains=ALLBUT,bangcBlock,@bangcParenGroup,bangcCppParen,@bangcStringGroup,@Spell
    " bangcCppParen: same as bangcParen but ends at end-of-line; used in bangcDefine
    syn region  bangcCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcParen,bangcString,@Spell
    syn match   bangcParenError     display ")"
    syn match   bangcErrInParen     display contained "^[{}]\|^<%\|^%>"
  endif
elseif exists("c_no_bracket_error")
  if s:in_cpp_family && !exists("cpp_no_cpp11")
    syn region  bangcParen          transparent start='(' end=')' contains=ALLBUT,@bangcParenGroup,bangcCppParen,@bangcStringGroup,@Spell
    " cCppParen: same as bangcParen but ends at end-of-line; used in bangcDefine
    syn region  bangcCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcParen,bangcString,@Spell
    syn match   bangcParenError     display ")"
    syn match   bangcErrInParen     display contained "<%\|%>"
  else
    syn region  bangcParen          transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,bangcBlock,@bangcParenGroup,bangcCppParen,@bangcStringGroup,@Spell
    " bangcCppParen: same as bangcParen but ends at end-of-line; used in bangcDefine
    syn region  bangcCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcParen,bangcString,@Spell
    syn match   bangcParenError     display ")"
    syn match   bangcErrInParen     display contained "[{}]\|<%\|%>"
  endif
else
  if s:in_cpp_family && !exists("cpp_no_cpp11")
    syn region  bangcParen          transparent start='(' end=')' contains=ALLBUT,@bangcParenGroup,bangcCppParen,bangcErrInBracket,bangcCppBracket,@bangcStringGroup,@Spell
    " bangcCppParen: same as bangcParen but ends at end-of-line; used in bangcDefine
    syn region  bangcCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcErrInBracket,bangcParen,bangcBracket,bangcString,@Spell
    syn match   bangcParenError     display "[\])]"
    syn match   bangcErrInParen     display contained "<%\|%>"
    syn region  bangcBracket        transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@bangcParenGroup,bangcErrInParen,bangcCppParen,bangcCppBracket,@bangcStringGroup,@Spell
  else
    syn region  bangcParen          transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,bangcBlock,@bangcParenGroup,bangcCppParen,bangcErrInBracket,bangcCppBracket,@bangcStringGroup,@Spell
    " bangcCppParen: same as bangcParen but ends at end-of-line; used in bangcDefine
    syn region  bangcCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcErrInBracket,bangcParen,bangcBracket,bangcString,@Spell
    syn match   bangcParenError     display "[\])]"
    syn match   bangcErrInParen     display contained "[\]{}]\|<%\|%>"
    syn region  bangcBracket        transparent start='\[\|<::\@!' end=']\|:>' end='}'me=s-1 contains=ALLBUT,bangcBlock,@bangcParenGroup,bangcErrInParen,bangcCppParen,bangcCppBracket,@bangcStringGroup,@Spell
  endif
  " bangcCppBracket: same as bangcParen but ends at end-of-line; used in bangcDefine
  syn region    bangcCppBracket     transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@bangcParenGroup,bangcErrInParen,bangcParen,bangcBracket,bangcString,@Spell
  syn match     bangcErrInBracket   display contained "[);{}]\|<%\|%>"
endif

if s:ft ==# 'c' || exists("cpp_no_cpp11")
  syn region    bangcBadBlock       keepend start="{" end="}" contained containedin=bangcParen,bangcBracket,bangcBadBlock transparent fold
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match       bangcNumbers        display transparent "\<\d\|\.\d" contains=bangcNumber,bangcFloat,bangcOctalError,bangcOctal
" Same, but without octal error (for comments)
syn match       bangcNumbersCom     display contained transparent "\<\d\|\.\d" contains=bangcNumber,bangcFloat,bangcOctal
syn match       bangcNumber         display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match       bangcNumber         display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match       bangcOctal          display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=bangcOctalZero
syn match       bangcOctalZero      display contained "\<0"
syn match       bangcFloat          display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match       bangcFloat          display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match       bangcFloat          display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match       bangcFloat          display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match     bangcFloat          display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match     bangcFloat          display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match       bangcOctalError     display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain bangcString, bangcCharacter and bangcNumber.
  " But a "*/" inside a bangcString in a bangcComment DOES end the comment!  So we
  " need to use a special type of bangcString: bangcCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syn match     bangcCommentSkip    contained "^\s*\*\($\|\s\+\)"
  syn region bangcCommentString     contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=bangcSpecial,bangcCommentSkip
  syn region bangcComment2String    contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=bangcSpecial
  syn region  bangcCommentL start="//" skip="\\$" end="$" keepend contains=@bangcCommentGroup,bangcComment2String,bangcCharacter,bangcNumbersCom,bangcSpaceError,bangcWrongComTail,@Spell
  if exists("c_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syn region bangcComment matchgroup=bangcCommentStart start="/\*" end="\*/" contains=@bangcCommentGroup,bangcCommentStartError,bangcCommentString,bangcCharacter,bangcNumbersCom,bangcSpaceError,@Spell extend
  else
    syn region bangcComment matchgroup=bangcCommentStart start="/\*" end="\*/" contains=@bangcCommentGroup,bangcCommentStartError,bangcCommentString,bangcCharacter,bangcNumbersCom,bangcSpaceError,@Spell fold extend
  endif
else
  syn region    bangcCommentL       start="//" skip="\\$" end="$" keepend contains=@bangcCommentGroup,bangcSpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region  bangcComment        matchgroup=bangcCommentStart start="/\*" end="\*/" contains=@bangcCommentGroup,bangcCommentStartError,bangcSpaceError,@Spell extend
  else
    syn region  bangcComment        matchgroup=bangcCommentStart start="/\*" end="\*/" contains=@bangcCommentGroup,bangcCommentStartError,bangcSpaceError,@Spell fold extend
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syn match       bangcCommentError   display "\*/"
syn match       bangcCommentStartError display "/\*"me=e-1 contained
syn match       bangcWrongComTail   display "\*/"

syn keyword     bangcOperator       sizeof
if exists("c_gnu")
  syn keyword   bangcStatement      __asm__
  syn keyword   bangcOperator       typeof __real__ __imag__
endif
syn keyword     bangcType           int long short char void
syn keyword     bangcType           signed unsigned float double
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   bangcType           size_t ssize_t off_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   bangcType           clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   bangcType           mbstate_t wctrans_t wint_t wctype_t
endif
if !exists("c_no_c99") " ISO C99
  syn keyword   bangcType           _Bool bool _Complex complex _Imaginary imaginary
  syn keyword   bangcType           int8_t int16_t int32_t int64_t
  syn keyword   bangcType           uint8_t uint16_t uint32_t uint64_t
  if !exists("c_no_bsd")
    " These are BSD specific.
    syn keyword bangcType           u_int8_t u_int16_t u_int32_t u_int64_t
  endif
  syn keyword   bangcType           int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword   bangcType           uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword   bangcType           int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword   bangcType           uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword   bangcType           intptr_t uintptr_t
  syn keyword   bangcType           intmax_t uintmax_t
endif
if exists("c_gnu")
  syn keyword   bangcType           __label__ __complex__ __volatile__
endif

syn keyword     bangcTypedef        typedef
syn keyword     bangcStructure      struct union enum
syn keyword     bangcStorageClass   static register auto volatile extern const
if exists("c_gnu")
  syn keyword   bangcStorageClass   inline __attribute__
endif
if !exists("c_no_c99") && !s:in_cpp_family
  syn keyword   bangcStorageClass   inline restrict
endif
if !exists("c_no_c11")
  syn keyword   bangcStorageClass   _Alignas alignas
  syn keyword   bangcOperator       _Alignof alignof
  syn keyword   bangcStorageClass   _Atomic
  syn keyword   bangcOperator       _Generic
  syn keyword   bangcStorageClass   _Noreturn noreturn
  syn keyword   bangcOperator       _Static_assert static_assert
  syn keyword   bangcStorageClass   _Thread_local thread_local
  syn keyword   bangcType           char16_t char32_t
  " C11 atomics (take down the shield wall!)
  syn keyword   bangcType           atomic_bool atomic_char atomic_schar atomic_uchar
  syn keyword   Ctype           atomic_short atomic_ushort atomic_int atomic_uint
  syn keyword   bangcType           atomic_long atomic_ulong atomic_llong atomic_ullong
  syn keyword   bangcType           atomic_char16_t atomic_char32_t atomic_wchar_t
  syn keyword   bangcType           atomic_int_least8_t atomic_uint_least8_t
  syn keyword   bangcType           atomic_int_least16_t atomic_uint_least16_t
  syn keyword   bangcType           atomic_int_least32_t atomic_uint_least32_t
  syn keyword   bangcType           atomic_int_least64_t atomic_uint_least64_t
  syn keyword   bangcType           atomic_int_fast8_t atomic_uint_fast8_t
  syn keyword   bangcType           atomic_int_fast16_t atomic_uint_fast16_t
  syn keyword   bangcType           atomic_int_fast32_t atomic_uint_fast32_t
  syn keyword   bangcType           atomic_int_fast64_t atomic_uint_fast64_t
  syn keyword   bangcType           atomic_intptr_t atomic_uintptr_t
  syn keyword   bangcType           atomic_size_t atomic_ptrdiff_t
  syn keyword   bangcType           atomic_intmax_t atomic_uintmax_t
endif

if !exists("c_no_ansi") || exists("c_ansi_constants") || exists("c_gnu")
  if exists("c_gnu")
    syn keyword bangcConstant __GNUC__ __FUNCTION__ __PRETTY_FUNCTION__ __func__
  endif
  syn keyword bangcConstant __LINE__ __FILE__ __DATE__ __TIME__ __STDC__ __STDC_VERSION__ __STDC_HOSTED__
  syn keyword bangcConstant CHAR_BIT MB_LEN_MAX MB_CUR_MAX
  syn keyword bangcConstant UCHAR_MAX UINT_MAX ULONG_MAX USHRT_MAX
  syn keyword bangcConstant CHAR_MIN INT_MIN LONG_MIN SHRT_MIN
  syn keyword bangcConstant CHAR_MAX INT_MAX LONG_MAX SHRT_MAX
  syn keyword bangcConstant SCHAR_MIN SINT_MIN SLONG_MIN SSHRT_MIN
  syn keyword bangcConstant SCHAR_MAX SINT_MAX SLONG_MAX SSHRT_MAX
  if !exists("c_no_c99")
    syn keyword bangcConstant __func__ __VA_ARGS__
    syn keyword bangcConstant LLONG_MIN LLONG_MAX ULLONG_MAX
    syn keyword bangcConstant INT8_MIN INT16_MIN INT32_MIN INT64_MIN
    syn keyword bangcConstant INT8_MAX INT16_MAX INT32_MAX INT64_MAX
    syn keyword bangcConstant UINT8_MAX UINT16_MAX UINT32_MAX UINT64_MAX
    syn keyword bangcConstant INT_LEAST8_MIN INT_LEAST16_MIN INT_LEAST32_MIN INT_LEAST64_MIN
    syn keyword bangcConstant INT_LEAST8_MAX INT_LEAST16_MAX INT_LEAST32_MAX INT_LEAST64_MAX
    syn keyword bangcConstant UINT_LEAST8_MAX UINT_LEAST16_MAX UINT_LEAST32_MAX UINT_LEAST64_MAX
    syn keyword bangcConstant INT_FAST8_MIN INT_FAST16_MIN INT_FAST32_MIN INT_FAST64_MIN
    syn keyword bangcConstant INT_FAST8_MAX INT_FAST16_MAX INT_FAST32_MAX INT_FAST64_MAX
    syn keyword bangcConstant UINT_FAST8_MAX UINT_FAST16_MAX UINT_FAST32_MAX UINT_FAST64_MAX
    syn keyword bangcConstant INTPTR_MIN INTPTR_MAX UINTPTR_MAX
    syn keyword bangcConstant INTMAX_MIN INTMAX_MAX UINTMAX_MAX
    syn keyword bangcConstant PTRDIFF_MIN PTRDIFF_MAX SIG_ATOMIC_MIN SIG_ATOMIC_MAX
    syn keyword bangcConstant SIZE_MAX WCHAR_MIN WCHAR_MAX WINT_MIN WINT_MAX
  endif
  syn keyword bangcConstant FLT_RADIX FLT_ROUNDS FLT_DIG FLT_MANT_DIG FLT_EPSILON DBL_DIG DBL_MANT_DIG DBL_EPSILON
  syn keyword bangcConstant LDBL_DIG LDBL_MANT_DIG LDBL_EPSILON FLT_MIN FLT_MAX FLT_MIN_EXP FLT_MAX_EXP FLT_MIN_10_EXP FLT_MAX_10_EXP
  syn keyword bangcConstant DBL_MIN DBL_MAX DBL_MIN_EXP DBL_MAX_EXP DBL_MIN_10_EXP DBL_MAX_10_EXP LDBL_MIN LDBL_MAX LDBL_MIN_EXP LDBL_MAX_EXP
  syn keyword bangcConstant LDBL_MIN_10_EXP LDBL_MAX_10_EXP HUGE_VAL CLOCKS_PER_SEC NULL LC_ALL LC_COLLATE LC_CTYPE LC_MONETARY
  syn keyword bangcConstant LC_NUMERIC LC_TIME SIG_DFL SIG_ERR SIG_IGN SIGABRT SIGFPE SIGILL SIGHUP SIGINT SIGSEGV SIGTERM
  " Add POSIX signals as well...
  syn keyword bangcConstant SIGABRT SIGALRM SIGCHLD SIGCONT SIGFPE SIGHUP SIGILL SIGINT SIGKILL SIGPIPE SIGQUIT SIGSEGV
  syn keyword bangcConstant SIGSTOP SIGTERM SIGTRAP SIGTSTP SIGTTIN SIGTTOU SIGUSR1 SIGUSR2
  syn keyword bangcConstant _IOFBF _IOLBF _IONBF BUFSIZ EOF WEOF FOPEN_MAX FILENAME_MAX L_tmpnam
  syn keyword bangcConstant SEEK_CUR SEEK_END SEEK_SET TMP_MAX stderr stdin stdout EXIT_FAILURE EXIT_SUCCESS RAND_MAX
  " used in assert.h
  syn keyword bangcConstant NDEBUG
  " POSIX 2001
  syn keyword bangcConstant SIGBUS SIGPOLL SIGPROF SIGSYS SIGURG SIGVTALRM SIGXCPU SIGXFSZ
  " non-POSIX signals
  syn keyword bangcConstant SIGWINCH SIGINFO
  " Add POSIX errors as well.  List comes from:
  " http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
  syn keyword bangcConstant E2BIG EACCES EADDRINUSE EADDRNOTAVAIL EAFNOSUPPORT EAGAIN EALREADY EBADF
  syn keyword bangcConstant EBADMSG EBUSY ECANCELED ECHILD ECONNABORTED ECONNREFUSED ECONNRESET EDEADLK
  syn keyword bangcConstant EDESTADDRREQ EDOM EDQUOT EEXIST EFAULT EFBIG EHOSTUNREACH EIDRM EILSEQ
  syn keyword bangcConstant EINPROGRESS EINTR EINVAL EIO EISCONN EISDIR ELOOP EMFILE EMLINK EMSGSIZE
  syn keyword bangcConstant EMULTIHOP ENAMETOOLONG ENETDOWN ENETRESET ENETUNREACH ENFILE ENOBUFS ENODATA
  syn keyword bangcConstant ENODEV ENOENT ENOEXEC ENOLCK ENOLINK ENOMEM ENOMSG ENOPROTOOPT ENOSPC ENOSR
  syn keyword bangcConstant ENOSTR ENOSYS ENOTBLK ENOTCONN ENOTDIR ENOTEMPTY ENOTRECOVERABLE ENOTSOCK ENOTSUP
  syn keyword bangcConstant ENOTTY ENXIO EOPNOTSUPP EOVERFLOW EOWNERDEAD EPERM EPIPE EPROTO
  syn keyword bangcConstant EPROTONOSUPPORT EPROTOTYPE ERANGE EROFS ESPIPE ESRCH ESTALE ETIME ETIMEDOUT
  syn keyword bangcConstant ETXTBSY EWOULDBLOCK EXDEV
  " math.h
  syn keyword bangcConstant M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4
  syn keyword bangcConstant M_1_PI M_2_PI M_2_SQRTPI M_SQRT2 M_SQRT1_2
endif
if !exists("c_no_c99") " ISO C99
  syn keyword bangcConstant true false
endif

" Accept %: for # (C99)
syn region      bangcPreCondit      start="^\s*\zs\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" keepend contains=bangcComment,bangcCommentL,bangcCppString,bangcCharacter,bangcCppParen,bangcParenError,bangcNumbers,bangcCommentError,bangcSpaceError
syn match       bangcPreConditMatch display "^\s*\zs\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  syn cluster   bangcCppOutInGroup  contains=bangcCppInIf,bangcCppInElse,bangcCppInElse2,bangcCppOutIf,bangcCppOutIf2,bangcCppOutElse,bangcCppInSkip,bangcCppOutSkip
  syn region    bangcCppOutWrapper  start="^\s*\zs\(%:\|#\)\s*if\s\+0\+\s*\($\|//\|/\*\|&\)" end=".\@=\|$" contains=bangcCppOutIf,bangcCppOutElse,@NoSpell fold
  syn region    bangcCppOutIf       contained start="0\+" matchgroup=bangcCppOutWrapper end="^\s*\(%:\|#\)\s*endif\>" contains=bangcCppOutIf2,bangcCppOutElse
  if !exists("c_no_if0_fold")
    syn region  bangcCppOutIf2      contained matchgroup=bangcCppOutWrapper start="0\+" end="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0\+\s*\($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=bangcSpaceError,bangcCppOutSkip,@Spell fold
  else
    syn region  bangcCppOutIf2      contained matchgroup=bangcCppOutWrapper start="0\+" end="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0\+\s*\($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=bangcSpaceError,bangcCppOutSkip,@Spell
  endif
  syn region    bangcCppOutElse     contained matchgroup=bangcCppOutWrapper start="^\s*\(%:\|#\)\s*\(else\|elif\)" end="^\s*\(%:\|#\)\s*endif\>"me=s-1 contains=TOP,bangcPreCondit
  syn region    bangcCppInWrapper   start="^\s*\zs\(%:\|#\)\s*if\s\+0*[1-9]\d*\s*\($\|//\|/\*\||\)" end=".\@=\|$" contains=bangcCppInIf,bangcCppInElse fold
  syn region    bangcCppInIf        contained matchgroup=bangcCppInWrapper start="\d\+" end="^\s*\(%:\|#\)\s*endif\>" contains=TOP,bangcPreCondit
  if !exists("c_no_if0_fold")
    syn region  bangcCppInElse      contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0*[1-9]\d*\s*\($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=bangcCppInIf contains=bangcCppInElse2 fold
  else
    syn region  bangcCppInElse      contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0*[1-9]\d*\s*\($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=bangcCppInIf contains=bangcCppInElse2
  endif
  syn region    bangcCppInElse2     contained matchgroup=bangcCppInWrapper start="^\s*\(%:\|#\)\s*\(else\|elif\)\([^/]\|/[^/*]\)*" end="^\s*\(%:\|#\)\s*endif\>"me=s-1 contains=bangcSpaceError,bangcCppOutSkip,@Spell
  syn region    bangcCppOutSkip     contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=bangcSpaceError,bangcCppOutSkip
  syn region    bangcCppInSkip      contained matchgroup=bangcCppInWrapper start="^\s*\(%:\|#\)\s*\(if\s\+\(\d\+\s*\($\|//\|/\*\||\|&\)\)\@!\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" containedin=bangcCppOutElse,bangcCppInIf,bangcCppInSkip contains=TOP,bangcPreProc
endif
syn region      bangcIncluded       display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match       bangcIncluded       display contained "<[^>]*>"
syn match       bangcInclude        display "^\s*\zs\(%:\|#\)\s*include\>\s*["<]" contains=bangcIncluded
"syn match bangcLineSkip    "\\$"
syn cluster     bangcPreProcGroup   contains=bangcPreCondit,bangcIncluded,bangcInclude,bangcDefine,bangcErrInParen,bangcErrInBracket,bangcUserLabel,bangcSpecial,bangcOctalZero,bangcCppOutWrapper,bangcCppInWrapper,@bangcCppOutInGroup,bangcFormat,bangcNumber,bangcFloat,bangcOctal,bangcOctalError,bangcNumbersCom,bangcString,bangcCommentSkip,bangcCommentString,bangcComment2String,@bangcCommentGroup,bangcCommentStartError,bangcParen,bangcBracket,bangcMulti,bangcBadBlock
syn region      bangcDefine         start="^\s*\zs\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@bangcPreProcGroup,@Spell
syn region      bangcPreProc        start="^\s*\zs\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@bangcPreProcGroup,@Spell

" Optional embedded Autodoc parsing
if exists("c_autodoc")
  syn match bangcAutodocReal display contained "\%(//\|[/ \t\v]\*\|^\*\)\@2<=!.*" contains=@bangcAutodoc containedin=bangcComment,bangcCommentL
  syn cluster bangcCommentGroup add=bangcAutodocReal
  syn cluster bangcPreProcGroup add=bangcAutodocReal
endif

" be able to fold #pragma regions
syn region      bangcPragma         start="^\s*#pragma\s\+region\>" end="^\s*#pragma\s\+endregion\>" transparent keepend extend fold

" Highlight User Labels
syn cluster     bangcMultiGroup     contains=bangcIncluded,bangcSpecial,bangcCommentSkip,bangcCommentString,bangcComment2String,@bangcCommentGroup,bangcCommentStartError,bangcUserCont,bangcUserLabel,bangcBitField,bangcOctalZero,bangcCppOutWrapper,bangcCppInWrapper,@bangcCppOutInGroup,bangcFormat,bangcNumber,bangcFloat,bangcOctal,bangcOctalError,bangcNumbersCom,bangcCppParen,bangcCppBracket,bangcCppString
if s:ft ==# 'c' || exists("cpp_no_cpp11")
  syn region    bangcMulti          transparent start='?' skip='::' end=':' contains=ALLBUT,@bangcMultiGroup,@Spell,@bangcStringGroup
endif
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster     bangcLabelGroup     contains=bangcUserLabel
syn match       bangcUserCont       display "^\s*\zs\I\i*\s*:$" contains=@bangcLabelGroup
syn match       bangcUserCont       display ";\s*\zs\I\i*\s*:$" contains=@bangcLabelGroup
if s:in_cpp_family
  syn match     bangcUserCont       display "^\s*\zs\%(class\|struct\|enum\)\@!\I\i*\s*:[^:]"me=e-1 contains=@bangcLabelGroup
  syn match     bangcUserCont       display ";\s*\zs\%(class\|struct\|enum\)\@!\I\i*\s*:[^:]"me=e-1 contains=@bangcLabelGroup
else
  syn match     bangcUserCont       display "^\s*\zs\I\i*\s*:[^:]"me=e-1 contains=@bangcLabelGroup
  syn match     bangcUserCont       display ";\s*\zs\I\i*\s*:[^:]"me=e-1 contains=@bangcLabelGroup
endif

syn match       bangcUserLabel      display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match       bangcBitField       display "^\s*\zs\I\i*\s*:\s*[1-9]"me=e-1 contains=bangcType
syn match       bangcBitField       display ";\s*\zs\I\i*\s*:\s*[1-9]"me=e-1 contains=bangcType

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50       " #if 0 constructs can be long
  else
    let b:c_minlines = 15       " mostly for () constructs
  endif
endif
if exists("c_curly_error")
  syn sync fromstart
else
  exec "syn sync ccomment bangcComment minlines=" . b:c_minlines
endif

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link bangcFormat             bangcSpecial
hi def link bangcCppString          bangcString
hi def link bangcCommentL           bangcComment
hi def link bangcCommentStart       bangcComment
hi def link bangcLabel              Label
hi def link bangcUserLabel          Label
hi def link bangcConditional        Conditional
hi def link bangcRepeat             Repeat
hi def link bangcCharacter          Character
hi def link bangcSpecialCharacter   bangcSpecial
hi def link bangcNumber             Number
hi def link bangcOctal              Number
hi def link bangcOctalZero          PreProc  " link this to Error if you want
hi def link bangcFloat              Float
hi def link bangcOctalError         bangcError
hi def link bangcParenError         bangcError
hi def link bangcErrInParen         bangcError
hi def link bangcErrInBracket       bangcError
hi def link bangcCommentError       bangcError
hi def link bangcCommentStartError  bangcError
hi def link bangcSpaceError         bangcError
hi def link bangcWrongComTail       bangcError
hi def link bangcSpecialError       bangcError
hi def link bangcCurlyError         bangcError
hi def link bangcOperator           Operator
hi def link bangcStructure          Structure
hi def link bangcTypedef            Structure
hi def link bangcStorageClass       StorageClass
hi def link bangcInclude            Include
hi def link bangcPreProc            PreProc
hi def link bangcDefine             Macro
hi def link bangcIncluded           bangcString
hi def link bangcError              Error
hi def link bangcStatement          Statement
hi def link bangcCppInWrapper       bangcCppOutWrapper
hi def link bangcCppOutWrapper      bangcPreCondit
hi def link bangcPreConditMatch     bangcPreCondit
hi def link bangcPreCondit          PreCondit
hi def link bangcType               Type
hi def link bangcConstant           Constant
hi def link bangcCommentString      bangcString
hi def link bangcComment2String     bangcString
hi def link bangcCommentSkip        bangcComment
hi def link bangcString             String
hi def link bangcComment            Comment
hi def link bangcSpecial            SpecialChar
hi def link bangbangcTodo               Todo
hi def link bangcBadContinuation    Error
hi def link bangcCppOutSkip         bangcCppOutIf2
hi def link bangcCppInElse2         bangcCppOutIf2
hi def link bangcCppOutIf2          bangcCppOut
hi def link bangcCppOut             Comment

let b:current_syntax = "c"

unlet s:ft

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8
