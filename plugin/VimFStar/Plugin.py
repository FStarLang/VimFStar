import glob
import os

class Plugin(object):
    """VimFStar plugin logic"""

    def __init__(self, log, **kwargs):
        self.__log = log
        self.__exe_filespec = kwargs.get('exe_filespec', 'fstar.exe')
        self.__fstar_exe = None

    def find_fstar_exe(self):
        if self.__fstar_exe != None:
            return self.__fstar_exe
        path = os.getenv('PATH', os.defpath).split(os.pathsep)
        self.__log.Print('debug', lambda: 'Searching for F* executable; search path is: %r' % path)
        for dir in path:
            pat = os.path.join(dir, self.__exe_filespec)
            matches = glob.glob(pat)
            if len(matches) > 0:
                self.__fstar_exe = matches[0]
                self.__log.Print('verbose', lambda: 'Found F* exectuable at `%s`.' % self.__fstar_exe)
                return self.__fstar_exe
        self.__log.Print('warning', lambda: 'Unable to find F* executable; please check your search path if you need all features of VimFStar to work properly.')


