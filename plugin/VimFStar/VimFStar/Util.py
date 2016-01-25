# todo: this module really should be a part of VimPy.
def coerce_to_bool(s):
    if isinstance(s, basestring):
        return s.strip() != '0'
    else:
        return bool(s)