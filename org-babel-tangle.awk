#! /usr/bin/awk -f
BEGIN{
    IGNORECASE=1;
    org_babel_src_regexp_indent="^([ \t]*)#\\+begin_src[ \t]+";
    org_babel_src_regexp_lang="([^[:space:]]+)[ \t]*";
    org_babel_src_regexp_switches="([^\":]*\"[^\"*]*\"[^\":]*|[^\":]*)";
    org_babel_src_regexp_header_arguments=".*:tangle[ \t]+\"([^\"]+)\".*";
    org_babel_src_regexp_end="^[ \t]*#\\+end_src[ \t]*";
    org_babel_src_regexp=org_babel_src_regexp_indent org_babel_src_regexp_lang rg_babel_src_regexp_switches org_babel_src_regexp_header_arguments;
}

{
    if (match($0, org_babel_src_regexp, result))
    {
        print "results=",result[3]
        file=result[3]
        getline
        while($0 !~ org_babel_src_regexp_end){
            print $0
            getline;
        }
    }
}
