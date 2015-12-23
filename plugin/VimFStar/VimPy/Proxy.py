from Log import Log

try:
    global HAS_VIM
    import vim
    HAS_VIM = True
except ImportError:
    HAS_VIM = False
    import Stubs as vim

class Proxy(object):
    """Proxy logic for Vim plugins"""

    def __init__(self, cons, **kwargs):
        log_arg = kwargs.get('log', None)
        if log_arg is None:
            self.__log = Log()
        else:
            self.__log = log_arg
        self.__target = cons(log=self.__log)
        self.__vimargs = None
        self.__error = None

    def __getattr__(self, name):
        global HAS_VIM
        attr = getattr(self.__target, name)
        if HAS_VIM:
            return self.__vimcall(attr)
        else:
            return self.__stdcall(attr)

    def __raise_if_error(self):
        if self.__error != None:
            raise RuntimeError('Unable to get attribute `%s` due to prior error state.' % name)

    def __set_error(self, e):
        if self.__error == None:
            self.__error = e
        if HAS_VIM:
            self.__log.writeline('error', lambda: 'Uncaught Python exception in `%s`: %s' % (name, e))

    def __vimcall(self, f):
        def vimcall():
            try:
                self.__raise_if_error()
                name = vim.eval('l:pycall')
                self.__vimargs = vim.eval('a:')
                args = self.__vimargs.get('000', [])
                kwargs = copy.copy(self.__vimargs)
                del kwargs['000']
                del kwargs['0']
                del kwargs['firstline']
                del kwargs['lastline']
                self.__log.writeline('trace', lambda: '%s(*args=%s, **kwargs=%s)' % (name, args, kwargs))
                result = f(*args, **kwargs)
                self.__log.writeline('trace', lambda: '%s(*args=%s, **kwargs=%s) returned %s' % (name, args, kwargs, result))
                # todo: we don't yet have a good story for return values.
                vim.command('let l:pyresult = %r' % result)
            except Exception as e:
                self.__set_error(e)
            finally:
                self.__vimargs = None
        return vimcall

    def __stdcall(self, f):
        def stdcall(*args, **kwargs):
            try:
                self.__raise_if_error()
                return f(*args, **kwargs)
            except Exception as e:
                self.__set_error(e)
                raise
        return stdcall

