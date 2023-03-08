import sys


def strip(s):
    while len(s) > 0 and (s[0] == ' ' or s[0] == '\n'):
        s = s[1:]
    return s


def or_parser(p1, p2):
    """Create a parser that accepts one of two parsers"""
    def parse(s):
        strip(s)
        (res_temp, s_temp) = p1(s)
        if res_temp is None:
            return p2(s)
        return (res_temp, s_temp)
    return parse


def take_symb(s):
    """Just a little hack for quick analysis: we allow the symbols "subject"
    and "a", "b", "c", and "d". """
    s = strip(s)
    if len(s) >= 7 and s[0:7] == 'subject':
        return ('subject', strip(s[7:]))
    if len(s) >= 1 and (s[0] == 'a' or s[0] == 'b' or s[0] == 'c' or s[0] == 'd'):
        return (s[0], strip(s[1:]))
    return (None, s)


int_syms = '0123456789.'
def take_int(s):
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


def take_list_of(mems_parser):
    def take_list(s):
        s = strip(s)
        if len(s) > 0 and s[0] == '[':
            res = []
            s = s[1:]
            while True:
                (tes_tmp, s) = mems_parser(s)
                if tes_tmp is None:
                    (lis_res, s) = take_list(s)
                    if lis_res is None:
                        break
                    res.append(lis_res)
                else:
                    res.append(tes_tmp)
        else:
            res = None
        s = strip(s)
        if len(s) > 0 and s[0] == ']':
            s = strip(s[1:])

        return (res, s)
    return take_list


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
        return associate_right(l[0])
    return [associate_right(l[0]), associate_right(l[1:])]


inp_file = sys.argv[1]
with open(inp_file) as f:
    inp = f.read()
leaf_parser = or_parser(take_int, take_symb)
list_parser = take_list_of(leaf_parser)
(res, s) = or_parser(leaf_parser, list_parser)(inp)
if not s == '':
    print('Parse error:\nresult so far: %s\nremaining: %s' % (res, s))
res = associate_right(res)
res = str(res).replace(',', '')  # we don't use commas to separate list items in nock.
res = str(res).replace("'", '') # remove string quotes.
print(res)
