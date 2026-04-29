
from queue import Queue


class Antrean:
    def __init__(self):
        self.antrean_prioritas = Queue()
        self.antrean_regular = Queue()
        self.total = 0

    def tambah_reguler(self, new_pelanggan):
        self.antrean_regular.put(f"{new_pelanggan} (Reguler)")
        self.total += 1
        return self

    def tambah_prioritas(self, new_pelanggan):
        self.antrean_prioritas.put(f"{new_pelanggan} (Prioritas)")
        self.total += 1
        return self

    def layani(self):
        if self.total < 1:
            print("Tidak ada pelanggan.")
        pelanggan = ""
        if not self.antrean_prioritas.empty():
            pelanggan = self.antrean_prioritas.get()
        elif not self.antrean_regular.empty():
            pelanggan = self.antrean_regular.get()

        print(f"{pelanggan} berhasil dilayani.")
        self.total -= 1

    def info(self):
        print(f"\nInformasi Antrean ({self.total})")
        i = 1
        for pelanggan in self.antrean_prioritas.queue:
            print(f"{i}. {pelanggan}")
            i += 1

        for pelanggan in self.antrean_regular.queue:
            print(f"{i}. {pelanggan}")
            i += 1
        print("~~~\n")


if __name__ == "__main__":
    antrean = Antrean()
    antrean.tambah_prioritas("P1")
    antrean.tambah_reguler("P2")
    antrean.info()

    antrean.tambah_prioritas("P3")
    antrean.tambah_reguler("P3")
    antrean.tambah_prioritas("P5")
    antrean.info()

    antrean.layani()
    antrean.layani()
    antrean.info()
