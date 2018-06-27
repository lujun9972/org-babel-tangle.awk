#! /usr/bin/awk -f
BEGIN{
    IGNORECASE=1;
    # LINT=1;
    org_babel_src_regexp_indent="^([ \t]*)#\\+begin_src[ \t]+";
    org_babel_src_regexp_lang="([^ \f\t\n\r\v]+)[ \t]*";
    org_babel_src_regexp_switches="([^\":]*\"[^\"*]*\"[^\":]*|[^\":]*)";
    org_babel_src_regexp_header_arguments=".*:tangle[ \t]+\"([^\"]+)\".*";
    org_babel_src_regexp_end="^[ \t]*#\\+end_src[ \t]*";
    org_babel_src_regexp=org_babel_src_regexp_indent org_babel_src_regexp_lang rg_babel_src_regexp_switches org_babel_src_regexp_header_arguments;
}

function min(n,m)
{
    if (n<m){
        return n;
    }
    return m;
}

# _ARGVEND_ 后面的参数是用来定义局部变量的，不做真正的参数用，详情请参见[[https://www.ibm.com/developerworks/cn/linux/l-cn-awkf/index.html]]
function collect_src_block(_ARGVEND_, src_block, src_lines,idx,i,min_blank_num)
{
    idx = 0;
    min_blank_num = 1000;
    getline
    while($0 !~ org_babel_src_regexp_end){
        src_lines[idx] = $0;
        idx++;
        if($0 !~ "^[[:space:]]*$"){ # 跳过全空的行
            match($0,"^ *");        # 只把空格删掉，不能把TAB删掉,否则makefile用不了
            min_blank_num = min(RLENGTH,min_blank_num);
        }
        getline;
    }

    for(i=0; i<idx; i++)
    {
        src_block = src_block substr(src_lines[i], min_blank_num+1) ORS;
    }
    return src_block;
}

function command(cmd, _ARGVEND_, output)
{
    cmd|getline output;
    close(cmd);
    return output;
}

function realpath(path)
{
    return command("realpath " path);
}

function dirname(path)
{
    return command("dirname " path);
}

function mkdir(dir)
{
    return system("mkdir -p" dir)
}

{
    if (match($0, org_babel_src_regexp, result))
    {
        file=result[3];
        codes[file]=codes[file] collect_src_block();
    }
}

END{
    for (file in codes)
    {
        absolute_path=realpath(file);
        dir=dirname(absolute_path)
        mkdir(dir)
        printf("Tangle codes into %s\n", absolute_path);
        print codes[file] >absolute_path;
    }
}
