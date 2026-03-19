def fib(n):
    fib_list = [1, 1]
    for i in range(2, n):
        fib_list.append(fib_list[i - 1] + fib_list[i - 2])
    return fib_list[n - 1]

if __name__ == "__main__":
    print(fib(3))
    print(fib(9))
