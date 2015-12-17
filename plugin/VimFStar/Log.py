import sys

class Log(object):

    def __init__(self, **kwargs):

        self.__shown_tags = set()
        self.__out = kwargs.get('out', sys.stdout)
        self.__err = kwargs.get('err', sys.stderr)
        ignore_default = kwargs.get('ignore_default', False)
        self.__tags_for_vim = set(['vim']) if ignore_default else set(['error', 'warning', 'info', 'vim'])
        self.__shown_tags = set() if ignore_default else set(['error', 'warning', 'info', 'vim'])
        self.__shown_tags = self.__shown_tags | set(kwargs.get('shown_tags', []))

    def Print(self, t, get_msg):

        if isinstance(t, list):
            x = set(t)
        else:
            x = set([t])

        i = x & self.__shown_tags
        if len(i) > 0:
            l = list(i)
            l.sort()
            s = get_msg()
            if 'error' in i or 'warning' in i:
                # errors messages will be written to all error outputs.
                self.__err.write("%r %s\n" % (l, s))
                # if `self.__err` is not sys.stderr, then we need to also write to that.
                if self.__err != sys.stderr:
                    sys.stderr("%s\n" % s)
            else:
                self.__out.write("%r %s\n" % (l, s))
                # if `self.__err` is not sys.stderr, then we need to also write to that.
                # `vim` captures stdout, so if the 'vim' tag is specified or if the tags involved include any tags from the `self.__tags_for_vim` group, then we display the message in vim. 
                if self.__out != sys.stdout and ('vim' in l or len(i & self.__tags_for_vim) > 0):
                    print(s)

            
    
