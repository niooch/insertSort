# Insert Sort Symulacja
![Insert Sort](https://jkogut.pl/assets/insertion_sort.jpg)

# Problem
Jaka jest charakterystyka algorytmu sortowania przez wstawianie dla losowego wejścia?
Tworzymy tablicę z losową permutacją liczb od 1 do n i sortujemy ją algorytmem sortowania przez wstawianie, przy okazji licząc ilość przesunięć i porównań.


# Jak to działa?
Odpalamy skrypt, który wszystko ogarnia:
```bash
bash run.sh $(seq 1000 1000 1000000)
```
policzy dla `n = 100, 200, ..., 10000`, ilość przesunieć i porównań w algorytnie sortowania przez wstawianie.

# Co potrzebne?
* gcc
* gnuplot
* bash
* make

# Sprawozdanie
Sprawozdanie znajduje się w pliku [sprawozdanie.pdf](sprawozdanie.pdf)
