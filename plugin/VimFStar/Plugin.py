import glob
import os
import copy
import subprocess
import sys
import Queue
import threading

try:
    import vim
except ImportError:
    import VimStubs as vim

ON_POSIX = 'posix' in sys.builtin_module_names

class Plugin(object):
    """VimFStar plugin logic"""

    def __init__(self, log, **kwargs):
        self.__log = log
        self.__exe_filespec = kwargs.get('exe_filespec', 'fstar.exe')
        self.__exe = None
        self.__vimargs = None
        self.__good = False

    def invoke_from_vim(self):
        try:
            name = vim.eval('l:pycall')
            self.__vimargs = vim.eval('a:')
            args = self.__vimargs.get('000', [])
            kwargs = copy.copy(self.__vimargs)
            del kwargs['000']
            del kwargs['0']
            del kwargs['firstline']
            del kwargs['lastline']
            self.__log.Print('trace', lambda: '%s(*args=%s, **kwargs=%s)' % (name, args, kwargs))
            f = getattr(self, name)
            result = f(*args, **kwargs)
            self.__log.Print('trace', lambda: '%s(*args=%s, **kwargs=%s) returned %s' % (name, args, kwargs, result))
            vim.command('let l:pyresult = %r' % result)
        except Exception as e:
            self.__log.Print('error', lambda: 'Uncaught exception in VimFStar python module:\n%s' % e)
            self.__good = False
        finally:
            self.__vimargs = None

    def find_exe(self):
        if self.__exe != None:
            return self.__exe
        path = os.getenv('PATH', os.defpath).split(os.pathsep)
        self.__log.Print('debug', lambda: 'Searching for F* executable; search path is: %r' % path)
        for dir in path:
            matches = glob.glob(os.path.normpath(os.path.join(dir, self.__exe_filespec)))
            if len(matches) > 0:
                self.__exe = matches[0]
                self.__log.Print('verbose', lambda: 'Found F* exectuable at `%s`.' % self.__exe)
                return self.__exe
        self.__log.Print('warning', lambda: 'Unable to find F* executable; please check your search path if you need all features of VimFStar to work properly.')
        return ''

    #no waiting read as in http://stackoverflow.com/a/4896288/2598986
    def __thread_proc(self, out, queue):
        for line in iter(out.readline, b''):
            log.Print('debug', lambda: 'f* -> `%s`' % line)
            # is this threadsafe?
            queue.put(line)
        out.close()
        self.__log.Print('info', lambda: 'f* has terminated')
        self.__thread = None
        self.__proc = None
        self.__good = False

    def start(self) :
        self.find_exe()
        p = subprocess.Popen(
            [self.__exe, '--in'], 
            stdin=subprocess.PIPE, 
            stdout=subprocess.PIPE,
            bufsize=1, 
            close_fds=ON_POSIX)
        q = Queue.Queue()
        t = threading.Thread(target=self.__thread_proc, args=(p.stdout, q))
        t.daemon = True
        t.start()
        self.__thread = t
        self.__proc = p
        self.__good = True

    def write(self, s) :
        self.__log.Print('debug', lambda: "`%s` -> f*" % s)
        self.__proc.stdin.write('%s\n' % s)

