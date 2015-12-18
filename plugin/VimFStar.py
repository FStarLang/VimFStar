import sys
from VimFStar import *
import time

log = Log.Log(shown_tags=['trace', 'debug', 'verbose'])
cli = Cli.Cli(sys.argv, log)
plugin = Plugin.Plugin(log)
log.Print(['info', 'welcome'], lambda: "Welcome to VimFStar!")

def vimfstar_find_fstar_exe():
    result = plugin.find_fstar_exe()
    vim.command('let l:pyresult = %r' % result)

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == '--vim':
        log.Print(['debug'], lambda: "I was invoked from within a Vim environment.")
    else:
        log.Print(['debug'], lambda: "I was invoked from the command line.")
        plugin.start()
        plugin.write("assert(0 == 1)")
        plugin.write("#end")
        plugin.write("o hai")
        time.sleep(100000)


# legacy code starts here

import sys
import re
from subprocess import PIPE,Popen
from threading import Thread
from Queue import Queue, Empty

fstarpath='fstar.exe'
fstarbusy=0
fstarcurrentline=0
fstarpotentialline=0
fstarrequestline=0
fstaranswer=None
fstarupdatehi=False
fstarmatch=None
fst=None
interout=None

ON_POSIX = 'posix' in sys.builtin_module_names

def fstar_reset_hi() :
    log.Print('trace', lambda: "fstar_reset_hi()")
    global fstarmatch
    if fstarmatch != None:
        vim.command("call matchdelete("+str(fstarmatch)+")")
    fstarmatch=None
    return

def fstar_add_hi(pos) :
    log.Print('trace', lambda: "fstar_reset_hi(pos=%r)" % pos)
    global fstarmatch
    if pos >= 1 :
        fstarmatch=int(vim.eval("matchadd('FChecked','\\%<"+str(pos+1)+"l')"))
    return

def fstar_update_hi(newpos) :
    log.Print('trace', lambda: "fstar_update_hi(newpos=%r)" % newpos)
    fstar_reset_hi()
    fstar_add_hi(newpos)
    return

def fstar_update_marker(newpos) : 
    log.Print('trace', lambda: "fstar_update_marker(newpos=%r)" % newpos)
    vim.command('exe "normal! ' + str(newpos) + 'G1|mv\\<C-o>"')
    return

#no waiting read as in http://stackoverflow.com/a/4896288/2598986
def fstar_enqueue_output(out, queue):
    log.Print('trace', lambda: "fstar_enqueue_output(out=%r, queue=%r)" % (out, queue))
    for line in iter(out.readline, b''):
        queue.put(line)
    out.close()

def fstar_readinter () :
    log.Print('trace', lambda: "fstar_readinter()")
    global interout
    try : line = interout.get_nowait()
    except Empty :
        log.Print('trace', lambda: "fstar_readinter() => None")
        return None
    else :
        log.Print('trace', lambda: "fstar_readinter() => %r", line)
        return line

def fstar_writeinter (s) :
    log.Print('trace', lambda: "fstar_writeinter(s=%r)" % s)
    global fst
    fst.stdin.write(s)

def fstar_init () :
    log.Print('trace', lambda: "fstar_init()")
    global fst,interout
    fst=Popen([fstarpath,'--in'],stdin=PIPE, stdout=PIPE,bufsize=1,close_fds=ON_POSIX)
    interout=Queue()
    t=Thread(target=fstar_enqueue_output,args=(fst.stdout,interout))
    t.daemon=True
    t.start()

def fstar_reset() :
    log.Print('trace', lambda: "fstar_reset()")
    global fstarbusy,fstarcurrentline,fstarpotentialline,fstaranswer,fstarupdatehi,fstarmatch
    fstarbusy=0
    fstarcurrentline=0
    fstarpotentialline=0
    fstaranswer=None
    fstarupdatehi=False
    fstar_reset_hi()
    fstar_init()
    print 'Interaction reset'


def fstar_test_code (code,keep,quickcheck=False) :
    log.Print('trace', lambda: "fstar_test_code(code=%r, keep=%r, quickcheck=%r)" % (code, keep, quickcheck))
    global fstarbusy,fst
    if fstarbusy == 1 :
        return 'Already busy'
    fstarbusy = 1
    fstar_writeinter('#push\n')
    if quickcheck :
        fstar_writeinter('#set-options "--admit_smt_queries true"\n')
    fstar_writeinter(code) 
    fstar_writeinter('\n')
    if quickcheck : 
        fstar_writeinter('#reset-options\n')
    fstar_writeinter('#end\n')
    if not keep :
        fstar_writeinter('#pop\n')
    return '*plugh*'

def fstar_convert_answer(ans) :
    log.Print('trace', lambda: "fstar_convert_answer(ans=%r)" % ans)
    global fstarrequestline
    res = re.match(r"\<input\>\((\d+)\,(\d+)\-(\d+)\,(\d+)\)\: (.*)",ans)
    if res == None :
        return ans
    return '(%d,%s-%d,%s) : %s' % (int(res.group(1))+fstarrequestline-1,res.group(2),int(res.group(3))+fstarrequestline-1,res.group(4),res.group(5))

def fstar_gather_answer () :
    log.Print('trace', lambda: "fstar_gather_answer()")
    global fstarbusy,fst,fstaranswer,fstarpotentialline,fstarcurrentline,fstarupdatehi
    if fstarbusy == 0 :
        return 'No verification pending'
    line=fstar_readinter()
    while line != None :
        if line=='ok\n' :
            fstarbusy=0
            fstarcurrentline=fstarpotentialline
            if fstarupdatehi :
                fstar_update_hi(fstarcurrentline)
                fstar_update_marker(fstarcurrentline+1)
            return 'Verification succeeded'
        if line=='fail\n' :
            fstarbusy=0
            fstarpotentialline=fstarcurrentline
            return fstaranswer
        fstaranswer+='\n'+fstar_convert_answer(line)
        line=fstar_readinter()
    return 'Busy'

def fstar_vim_query_answer () :
    log.Print('trace', lambda: "fstar_vim_query_answer()")
    r = fstar_gather_answer()
    if r != None :
        print r

def fstar_get_range(firstl,lastl) :
    log.Print('trace', lambda: "fstar_get_range(firstl=%r, lastl=%r)" % (firstl, lastl))
    lines = vim.eval("getline(%s,%s)"%(firstl,lastl))
    lines = lines + ["\n"]
    code = "\n".join(lines)
    return code


def fstar_get_selection () :
    log.Print('trace', lambda: "fstar_get_selection()")
    firstl = int(vim.eval("getpos(\"'<\")")[1])
    endl = int(vim.eval("getpos(\"'>\")")[1])
    lines = vim.eval("getline(%d,%d)"%(firstl,endl))
    lines = lines +  ["\n"]
    code = "\n".join(lines)
    return code


def fstar_vim_test_code () :
    log.Print('trace', lambda: "fstar_vim_test_code()")
    global fstarrequestline, fstaranswer
    global fstarupdatehi
    if fstarbusy == 1 :
        print 'Already busy'
        return
    fstaranswer=''
    fstarrequestline = int(vim.eval("getpos(\"'<\")")[1])
    code = fstar_get_selection()
    fstarupdatehi=False
    fstar_test_code(code,False)
    print 'Test of selected code launched'

def fstar_vim_until_cursor (quick=False) :
    log.Print('trace', lambda: "fstar_vim_until_cursor(quick=%r)" % quick)
    global fstarcurrentline,fstarpotentialline,fstarrequestline,fstarupdatehi, fstaranswer
    if fstarbusy == 1 :
        print 'Already busy'
        return
    fstaranswer = ''
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
    fstar_test_code(code,True,quick)
    if quick :
        print 'Quick test until this point launched'
    else :
        print 'Test until this point launched'

def fstar_vim_get_answer() :
    log.Print('trace', lambda: "fstar_vim_get_answer()")
    global fstaranswer
    print fstaranswer

def fstar_get_current_line () :
    log.Print('trace', lambda: "fstar_get_current_line()")
    global fstarcurrentline
    print fstarcurrentline
