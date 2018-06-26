#! /usr/bin/env bash

org_babel_src_regexp_indent='^([ \t]*)#\+begin_src[ \t]+' # indentation
org_babel_src_regexp_lang='([^[:space:]]+)[ \t]*'
org_babel_src_regexp_switches='([^":]*"[^"*]*"[^":]*|[^":]*)'
org_babel_src_regexp_header_arguments='.*:tangle[ \t]+"([^"]+)".*'
org_babel_src_regexp_body='([^ ]*?\n)??[ \t]*#\+end_src'
org_babel_src_regexp_end='^[ \t]*#\+end_src[ \t]*'
# org_babel_src_regexp_indent='^([ \t]*)#\+BEGIN_SRC[ \t]+' # indentation
# org_babel_src_regexp_lang='([^ \f\t\n\r\v]+)[ \t]*'
# org_babel_src_regexp_switches='([^":\n]*"[^"\n*]*"[^":\n]*\|[^":\n]*)'
# org_babel_src_regexp_header_arguments='([^\n]*)\n'
# org_babel_src_regexp_body='([^ ]*?\n)??[ \t]*#\+end_src'
org_babel_src_regexp=${org_babel_src_regexp_indent}${org_babel_src_regexp_lang}${rg_babel_src_regexp_switches}${org_babel_src_regexp_header_arguments}$

awk "BEGIN{IGNORECASE=1}
{
  if (match(\$0, /${org_babel_src_regexp}/, result))
  {
      print \"results=\",result[3]
      file=result[3]
      getline
      while(\$0 !~ /${org_babel_src_regexp_end}/){
       print \$0 >>file
       getline;
      }
  }
}
" $1
