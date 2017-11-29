#!/usr/bin/env python3

def func1():
    if j < 0:
        return x1 << -j
    else:        
        return x1 >> j

def func2():
    if j < 0:
        return y >> -j
    else:        
        return y << j

x1 = int(input())
x0 = 0
a = 0
y = 0
n = 0
c = 0
print(hex(x1))

t = x1
while t > 0:
    t >>= 1
    n += 1
n += 16
n += n & 1

for i in range(n, -1, -2):
    j = i - 16
    a <<= 1
    y <<= 1
    if y > 65535:
        y %= 65536  # 下16ビットをとる
    y2 = (1 | y)
    c = True
    if func1() < y2:
        if x0 >> i < y2:
            c = False
    if c:
        a += 1
        y += 1
        x1 -= func2()
        x0 -= (y << i) % 65536  # 下16ビットをとる
        if x0 < 0:
            x1 -= 1
            x0 += 65536  # 下16ビットをとる
        y += 1
    print('i, c, a, y, x1, x0:', i, c, a, hex(y), hex(x1), hex(x0))

print(hex(a), ' = ', a / 256.)