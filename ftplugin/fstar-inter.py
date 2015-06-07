import sys
import re
import vim
from subprocess import PIPE,Popen
from threading import Thread
from Queue import Queue, Empty
fstarpath='fstar.exe'
fstaridle=0
fstarcurrentline=0
fstarpotentialline=0
fstarrequestline=0
fstaranswer=None
fstarupdatehi=False
ON_POSIX = 'posix' in sys.builtin_module_names

def fstar_update_hi(newpos) :
    vim.command("syntax clear FChecked")
    if newpos >= 1 :
        vim.command("syntax region FChecked start='\\%1l' end='\\%" + str(newpos+1) + "l'")
    return

#no waiting read as in http://stackoverflow.com/a/4896288/2598986
def fstar_enqueue_output(out, queue):
    for line in iter(out.readline, b''):
        queue.put(line)
    out.close()

def fstar_readinter () :
    global interout
    try : line = interout.get_nowait()
    except Empty :
        return None
    else :
        return line

def fstar_writeinter (s) :
    global fst
    fst.stdin.write(s)

def fstar_get_config_from_buf() :
    startl = int(vim.eval('search(\'(\\*--build-config\')')) + 1
    endl = int(vim.eval('search(\'--\*)\')')) - 1
    if startl == 0 :
        return []
    configlines = vim.eval("getline(%d,%d)"%(startl,endl))
    configlines = ''.join(configlines)
    configlines = configlines.split(';')
    response=[]
    for line in configlines :
        line = line.strip(' \t\n\r')
        print line
        temp = line.split(':')
        if(temp[0] == 'options'):
            response = response + (temp[1].split(' '))
        if(temp[0] == 'other-files'):
            response = response + (temp[1].split(' '))
            
    return response


def fstar_init () :
    global fst,interout
    fst=Popen([fstarpath,'--in']+fstar_get_config_from_buf(),stdin=PIPE, stdout=PIPE,bufsize=1,close_fds=ON_POSIX)
    interout=Queue()
    t=Thread(target=fstar_enqueue_output,args=(fst.stdout,interout))
    t.daemon=True
    t.start()

def fstar_test_code (code,keep) :
    global fstaridle,fst
    if fstaridle == 1 :
        return 'Already idle'
    fstaridle = 1
    fstar_writeinter('#push\n')
    fstar_writeinter(code) 
    fstar_writeinter('#end\n')
    if not keep :
        fstar_writeinter('#pop\n')
    return ''

def fstar_convert_answer(ans) :
    global fstarrequestline
    res = re.match(r"\<input\>\((\d+)\,(\d+)\-(\d+)\,(\d+)\)\: (.*)",ans)
    if res == None :
        return ans
    return '(%d,%s-%d,%s) : %s' % (int(res.group(1))+fstarrequestline-1,res.group(2),int(res.group(3))+fstarrequestline-1,res.group(4),res.group(5))

def fstar_gather_answer () :
    global fstaridle,fst,fstaranswer,fstarpotentialline,fstarcurrentline,fstarupdatehi
    if fstaridle == 0 :
        return 'No verification pending'
    line=fstar_readinter()
    while line != None :
        if line=='ok\n' :
            fstaridle=0
            fstarcurrentline=fstarpotentialline
            if fstarupdatehi :
                fstar_update_hi(fstarcurrentline)
            return 'Verification succeeded'
        if line=='fail\n' :
            fstaridle=0
            fstarpotentialline=fstarcurrentline
            return fstaranswer
        fstaranswer=fstar_convert_answer(line)
        line=fstar_readinter()
    return None

def fstar_vim_query_answer () :
    r = fstar_gather_answer()
    if r != None :
        print r

def fstar_get_range(firstl,lastl) :
    lines = vim.eval("getline(%s,%s)"%(firstl,lastl))
    lines = lines + ["\n"]
    code = "\n".join(lines)
    return code


def fstar_get_selection () :
    firstl = int(vim.eval("getpos(\"'<\")")[1])
    endl = int(vim.eval("getpos(\"'>\")")[1])
    lines = vim.eval("getline(%d,%d)"%(firstl,endl))
    lines = lines +  ["\n"]
    code = "\n".join(lines)
    return code


def fstar_vim_test_code () :
    global fstarrequestline
    global fstarupdatehi
    if fstaridle == 1 :
        print 'Already idle'
        return
    fstarrequestline = int(vim.eval("getpos(\"'<\")")[1])
    code = fstar_get_selection()
    fstarupdatehi=False
    fstar_test_code(code,False)

def fstar_vim_until_cursor () :
    global fstarcurrentline,fstarpotentialline,fstarrequestline,fstarupdatehi
    if fstaridle == 1 :
        print 'Already idle'
        return
    vimline = int(vim.eval("getpos(\".\")")[1])
    if vimline <= fstarcurrentline :
        print 'Already checked'
        return
    firstl = fstarcurrentline+1
    fstarrequestline=firstl
    endl = vimline
    code = fstar_get_range(firstl,endl)
    fstarpotentialline=endl
    fstarupdatehi=True
    fstar_test_code(code,True)
    print 'Test until this point launched'

def fstar_get_current_line () :
    global fstarcurrentline
    print fstarcurrentline
