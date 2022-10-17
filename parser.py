import sys


def strip(s):
    while len(s) > 0 and (s[0] == ' ' or s[0] == '\n'):
        s = s[1:]
    return s


def orParser(p1, p2):
    """Create a parser that accepts one of two parsers"""
    def parse(s):
        strip(s)
        (resTemp, sTemp) = p1(s)
        if resTemp is None:
            return p2(s)
        return (resTemp, sTemp)
    return parse


def takeSymb(s):
    """Just a little hack for quick analysis: we allow the symbols "subject"
    and "a", "b", "c", and "d". """
    s = strip(s)
    if len(s) >= 7 and s[0:7] == 'subject':
        return ('subject', strip(s[7:]))
    if len(s) >= 1 and (s[0] == 'a' or s[0] == 'b' or s[0] == 'c' or s[0] == 'd'):
        return (s[0], strip(s[1:]))
    return (None, s)


int_syms = '0123456789.'
def takeInt(s):
    s = strip(s)
    res = ''
    while len(s) > 0 and s[0] in int_syms:
        res += s[0]
        s = s[1:]
    if res == '':
        res = None
    else:
        res = int(res.replace('.', ''))
    return (res, s)


def takeList(s, mems_parser=None):
    s = strip(s)
    if len(s) > 0 and s[0] == '[':
        res = []
        s = s[1:]
        while True:
            (resTmp, s) = mems_parser(s)
            if resTmp is None:
                (lisRes, s) = takeList(s, mems_parser=mems_parser)
                if lisRes is None:
                    break
                res.append(lisRes)
            else:
                res.append(resTmp)
    else:
        res = None
    s = strip(s)
    if len(s) > 0 and s[0] == ']':
        s = strip(s[1:])

    return (res, s)


def associate_right(l):
    """Take a list of atoms and lists, and associate all the elements in it to the right, recursively.
    For example:
    [1 2 3 4] => [1 [2 [3 4]]]
    [[1 2] 3 4] => [[1 2] [3 4]]
    [[1 2 3] 4] => [[1 [2 3]] 4]
    """
    if not isinstance(l, list):
        return l
    if len(l) == 1:
        return l[0]
    if len(l) == 2:
        return l
    return [associate_right(l[0]), associate_right(l[1:])]


inp_file = sys.argv[1]
with open(inp_file) as f:
    inp = f.read()
leafParser = orParser(takeInt, takeSymb)
listParser = lambda x: takeList(x, mems_parser=leafParser)
(res, s) = orParser(leafParser, listParser)(inp)
if not s == '':
    print("Parse error:\nresult so far: %s\nremaining: %s" % (res, s))
res = associate_right(res)
res = str(res).replace(',', '')  # we don't use commas to separate list items in nock.
res = str(res).replace('\'', '') # remove string quotes.
print(res)
