import glob
import os
import copy
import subprocess
import sys
import Queue
import threading

ON_POSIX = 'posix' in sys.builtin_module_names

class Plugin(object):
    """VimFStar plugin logic"""

    def __init__(self, log, **kwargs):
        self.__log = log

    def initialize(self, **kwargs):
        exe_filespec = kwargs.get('exe_filespec', None)
        exe_path = kwargs.get('exe_path', None)
        if exe_path != None and exe_filespec != None:
            self.__log('warning', lambda: 'the exe_filespec option is ignored if exe_path is set.')
        if exe_path == None:
            exe_path = self.__find_exe_path(exe_filespec)
        self.__set_exe_path(exe_path)

    def __find_exe_path(self, exe_filespec):
        path = os.getenv('PATH', os.defpath).split(os.pathsep)
        self.__log.write_line('debug', lambda: 'Searching for F* executable; search path is: %r' % path)
        for dir in path:
            matches = glob.glob(os.path.normpath(os.path.join(dir, exe_filespec)))
            if len(matches) > 0:
                exe_path = matches[0]
                self.__log.write_line('verbose', lambda: 'Found F* exectuable at `%s`.' % exe_path)
                return exe_path
        raise RuntimeError('Unable to find F* executable using filespec `%s`; please check your search path if you need all features of VimFStar to work properly.' % exe_filespec)

    def __set_exe_path(self, path):
        s = os.path.normpath(path)
        if not os.path.exists(s):
            raise RuntimeError("F* executable `%s` does not exist." % s)
        if not os.path.isfile(s) or not os.access(s, os.X_OK):
            raise RuntimeError("`%s` is not an executable file." % s)
        self.__exe_path = s

    def exe_path(self):
        return self.__exe_path

    #no waiting read as in http://stackoverflow.com/a/4896288/2598986
    def __thread_proc(self, out, queue):
        for line in iter(out.readline, b''):
            self.__log.write_line('debug', lambda: 'f* -> `%s`' % line)
            # is this threadsafe?
            queue.put(line)
        out.close()
        self.__log.write_line('info', lambda: 'f* has terminated')
        self.__thread = None
        self.__proc = None
        self.__good = False

    def start(self) :
        p = subprocess.Popen(
            [self.__exe_path, '--in'], 
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

    def write_line(self, s) :
        self.__log.write_line('debug', lambda: "`%s` -> f*" % s)
        self.__proc.stdin.write('%s\n' % s)
        self.__proc.stdin.flush()

