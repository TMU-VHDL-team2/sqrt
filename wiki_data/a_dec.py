#!/usr/bin/env python3

x1 = int(input())
x0 = 0
a = 0
y = 0
n = 0
c = 0

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
    y2 = (1 | y)
    if j < 0:
        j = -j
        c1 = y2 <= x1 << j
        c2 = y2 <= x0 >> i
        c = c1 | c2
        if c:
            a += 1
            y += 1
            x1 -= y >> j
            x0 -= (y << i) % 65536  # 下16ビットをとる
            if x0 < 0:
                x1 -= 1
                x0 += 65536
    else:
        c1 = y2 <= x1 >> j
        c2 = y2 <= x0 >> i
        c = c1 | c2
        if c:
            a += 1
            y += 1
            x1 -= y << j
            x0 -= (y << i) % 65536  # 下16ビットをとる
    y += c
    print('i, c, a, y, x1, x0:', i, c, a, hex(y), hex(x1), hex(x0))

print(a)
