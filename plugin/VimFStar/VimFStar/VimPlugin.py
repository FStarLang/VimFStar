import glob
import os
import copy
import subprocess
import sys
import Queue
import threading

ON_POSIX = 'posix' in sys.builtin_module_names
# snippet from http://code.activestate.com/recipes/578300-python-subprocess-hide-console-on-windows/
IS_WIN32 = 'win32' in str(sys.platform).lower()

class VimPlugin(object):
    """VimFStar plugin logic"""

    def __init__(self, **kwargs):
        self.__log = kwargs.get('log')
        self.__notify_func = kwargs.get('notify_func')
        self.__stdout_thread = None
        self.__stderr_thread = None
        self.__proc = None
        self.__queue = None
        self.__stop_flag_lock = threading.Lock()
        self.__stop_flag = False

    def find_exe_path(self, filespec):
        path = os.getenv('PATH', os.defpath).split(os.pathsep)
        self.__log.writeline('debug', lambda: 'Searching for F* executable; search path is: %r' % path)
        for dir in path:
            matches = glob.glob(os.path.normpath(os.path.join(dir, filespec)))
            if len(matches) > 0:
                exe_path = matches[0]
                self.__log.writeline('verbose', lambda: 'Found F* exectuable at `%s`.' % exe_path)
                self.set_exe_path(exe_path)
        raise RuntimeError('Unable to find F* executable using filespec `%s`; please check your search path if you need all features of VimFStar to work properly.' % filespec)

    def set_exe_path(self, path):
        s = os.path.normpath(path)
        if not os.path.exists(s):
            raise RuntimeError("F* executable `%s` does not exist." % s)
        if not os.path.isfile(s) or not os.access(s, os.X_OK):
            raise RuntimeError("`%s` is not an executable file." % s)
        self.__exe_path = s

    def exe_path(self):
        return self.__exe_path

    def __poll_stop_flag(self):
        with self.__stop_flag_lock:
            return self.__stop_flag

    def __set_stop_flag(self):
        with self.__stop_flag_lock:
            self.__stop_flag = True

    #no waiting read as in http://stackoverflow.com/a/4896288/2598986
    def __thread_proc(self, name, file, queue):
        try:
            stop_flag = self.__poll_stop_flag()
            if not stop_flag:
                for line in iter(file.readline, b''):
                    self.__log.writeline('debug', lambda: 'got %r' % line)
                    queue.put((name, line))
                    self.__notify_func()
                    stop_flag = self.__poll_stop_flag()
                    if stop_flag:
                        break
            out.close()
            if stop_flag:
                self.__log.writeline('verbose', lambda: '%s thread has been asked to terminate' % name)
            else:
                self.__log.writeline('verbose', lambda: '%s thread has reached end of input' % name)
        except Exception as e:
            queue.put(('raise', e))

    def stop(self, force=False):
        if isinstance(force, basestring):
            force = force != '0'
        if self.__proc == None:
            return
        self.__proc.poll()
        if self.__proc.returncode != None:
            return
        self.__log.writeline('verbose', lambda: 'Stopping F* (force=%r)' % force)
        if force:
            self.__proc.kill()
            self.__stdout_thread = None
            self.__stderr_thread = None
            self.__proc = None
            self.__queue = None
        else:
            with self.__stop_flag_lock:
                self.__stop_flag = True

    def start(self) :
        # hide console window from user. snippet obtained from http://code.activestate.com/recipes/578300-python-subprocess-hide-console-on-windows/
        startupinfo = None
        if IS_WIN32:
            startupinfo = subprocess.STARTUPINFO()
            startupinfo.dwFlags = subprocess.CREATE_NEW_CONSOLE | subprocess.STARTF_USESHOWWINDOW
            startupinfo.wShowWindow = subprocess.SW_HIDE
        p = subprocess.Popen(
            [self.__exe_path, '--in'], 
            stdin=subprocess.PIPE, 
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            bufsize=1, 
            close_fds=ON_POSIX,
            startupinfo=startupinfo)
        q = Queue.Queue()
        t = threading.Thread(target=self.__thread_proc, args=('stdout', p.stdout, q))
        t.daemon = True
        t.start()
        self.__stdout_thread = t
        t = threading.Thread(target=self.__thread_proc, args=('stderr', p.stderr, q))
        t.daemon = True
        t.start()
        self.__stderr_thread = t
        self.__proc = p
        self.__queue = q

    def writeline(self, s) :
        self.__log.writeline('debug', lambda: "%r -> f*" % s)
        self.__proc.stdin.write('%s\n' % s)
        self.__proc.stdin.flush()

    def refresh(self):
        try:
            event = self.__queue.get_nowait()
        except Queue.Empty:
            return 0
        self.__handle_event(event)
        return 1

    def __handle_event(self, event):
        self.__log.writeline('debug', lambda: 'primary thread got event (%r, %r)' % event)
        name, arg = event
        if name == 'stdout':
            return
        if name == 'stderr':
            return
        if name == 'raise':
            raise arg
        else:
            raise RuntimeError('Unrecognized process thread event name: %r' % name)



