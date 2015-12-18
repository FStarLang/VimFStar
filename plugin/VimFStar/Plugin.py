import glob
import os
import copy

try:
    import vim
except ImportError:
    import VimStubs as vim

class Plugin(object):
    """VimFStar plugin logic"""

    def __init__(self, log, **kwargs):
        self.__log = log
        self.__exe_filespec = kwargs.get('exe_filespec', 'fstar.exe')
        self.__fstar_exe = None
        self.__vimargs = None

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
        finally:
            self.__vimargs = None

    def find_fstar_exe(self):
        if self.__fstar_exe != None:
            return self.__fstar_exe
        path = os.getenv('PATH', os.defpath).split(os.pathsep)
        self.__log.Print('debug', lambda: 'Searching for F* executable; search path is: %r' % path)
        for dir in path:
            matches = glob.glob(os.path.normpath(os.path.join(dir, self.__exe_filespec)))
            if len(matches) > 0:
                self.__fstar_exe = matches[0]
                self.__log.Print('verbose', lambda: 'Found F* exectuable at `%s`.' % self.__fstar_exe)
                return self.__fstar_exe
        self.__log.Print('warning', lambda: 'Unable to find F* executable; please check your search path if you need all features of VimFStar to work properly.')
        return ''

    def say_hai(self, to_whom):
        print "hai, %s" % to_whom
        return 1

