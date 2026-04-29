from collections import deque

dq = deque()

def print_dq():
    print("\n~~~Daftar Antrean:")
    i = 1
    for v in dq:
        print(f"{i}. {v}")
        i += 1
    print("~~~~~~~~~~~~~~~~~~\n")

def add_reguler(pelanggan):
    dq.append(f"{pelanggan} (Reguler)")

def add_priority(pelanggan):
    dq.appendleft(f"{pelanggan} (Prioritas)")

def layani():
    antrean_pertama = dq.popleft()
    print(antrean_pertama, "berhasil dilayani.")

if __name__ == "__main__":
    add_reguler("Pelanggan 1")
    add_priority("Pelanggan 2")
    print_dq()

    add_priority("Pelanggan 3")
    add_reguler("Pelanggan 4")
    add_priority("Pelanggan 5")
    print_dq()

    layani()
    layani()
    print_dq()
