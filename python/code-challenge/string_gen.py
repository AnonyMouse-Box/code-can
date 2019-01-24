
def add_range(n, base):
    new = []
    for b in base:
        for i in range(0,n):
            new.append(str(b) + str(i))
    return new

def start_range(n):
    if n > 8:
        print('Error: Too large! This won\'t fit in 16GB of RAM!')
        return False
    base = ('',)
    for i in range(0,n):
        base = add_range(n, base)
    return base

if __name__ == '__main__':
    out = start_range(4)
    repr(out)
