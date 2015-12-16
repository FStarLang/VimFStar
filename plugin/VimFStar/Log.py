import sys

class Log:

    def __init__(self, **kwargs):

        self.__tags = set()
        self.__out = kwargs.get('out', sys.stdout)
        self.__err = kwargs.get('err', sys.stderr)
        self.__tags = set(kwargs.get('tags', ['error', 'warning', 'info', 'trace']))

    def Print(self, t, s):

        if isinstance(t, list):
            x = set(t)
        else:
            x = set([t])

        i = x & self.__tags
        if len(i) > 0:
            l = list(i)
            l.sort()
            if 'error' in i:
                self.__err.write("%r %s\n" % (l, s()))
            else:
                self.__out.write("%r %s\n" % (l, s()))
            
    
