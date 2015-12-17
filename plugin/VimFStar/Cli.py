class Cli(object):
    """Contains logic related to the command line interface of VimFStar."""

    def __init__(self, argv, log):
        if len(argv) < 1:
            raise ValueError('The CLI argument list must be longer than 1 element (%r)' % argv)
        self.__argv = argv
        self.__log = log
        #self.__options = self.__parse_options(argv)


