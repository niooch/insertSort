#!/bin/bash

plotuj(){
    local gnuplot_skrypt="plot.gnuplot"
    local typ=$1
    local pozycjaWyniki=$2
    local pozycjaSrednie=$3
    cat > $gnuplot_skrypt << EOF
    set terminal pngcairo size 800,600 enhanced font "Verdana,10"
    set output "$typ.png"
    set datafile separator ";"
    set title "Wykres $typ w zależności od n"
    set xlabel "n"
    set ylabel "$typ"

    set grid

    plot \
        "wyniki.dat" using 1:$pozycjaWyniki title "$typ" with points pt 7 lc rgb "blue", \
        "srednie.dat" using 1:$pozycjaSrednie title "Średnia $typ" with points pt 7 lc rgb "red"
EOF
    gnuplot $gnuplot_skrypt
}

plotujRatio(){
    local gnuplot_skrypt="plot.gnuplot"
    local typ1=$1
    local pozycja1=$2
    cat > $gnuplot_skrypt << EOF
    set terminal pngcairo size 800,600 enhanced font "Verdana,10"
    set output "$typ1.png"
    set datafile separator ";"
    set grid

    set title "Wykres $typ1 w zależności od n"
    set xlabel "n"
    set ylabel "stosunek"

    plot \
        "ratios.dat" using 1:$pozycja1 title "$typ1" with points pt 7 lc rgb "blue"
EOF
    gnuplot $gnuplot_skrypt
}


#skompiluj kod
make clean
make

if [ $? -ne 0 ]; then
    echo "blad kompilacji"
    exit 1
fi

#pobierz dane: sekwencje liczb dla ktorych mamy wykonac symulacje
if [ $# -eq 0 ]; then
    echo "brak argumentow. uzycie: $0 n1 [n2 n3 ...]"
    exit 1
fi

wartosci_n=$@
#przygoruj plik z wynikami
if [ -f wyniki.dat ]; then
    rm wyniki.dat
fi

#przeprowadz symulacje
for n in $wartosci_n; do
    echo "n=$n $(date +"%T")"
    ./insertSort $n >> wyniki.dat
done

#policz srednie dla kazdego n
awk -F";" '{
    n=$1
    cmp+=$2
    swap+=$3
    n_ile+=1
    if(n!=n_old && n_old!=0){
        printf "%s;%.10f;%.10f\n", n_old, cmp/n_ile, swap/n_ile
        cmp=0
        swap=0
        n_ile=0
    }
    n_old=n
} END {
    if(n_old!=0){
        printf "%s;%.10f;%.10f\n", n_old, cmp/n_ile, swap/n_ile
    }
}' wyniki.dat | sort -n > srednie.dat
#przygotuj plik z danymi do wykresu
if [ -f dane.dat ]; then
    rm dane.dat
fi

exec 3< srednie.dat
for n in $wartosci_n; do
    read -u 3 linia
    n_=$(echo $linia | cut -d";" -f1)
    cmp=$(echo $linia | cut -d";" -f2)
    swap=$(echo $linia | cut -d";" -f3)
    cmp1=$(echo "scale=10; $cmp/$n" | bc -l)
    swap1=$(echo "scale=10; $swap/$n" | bc -l)
    cmp2=$(echo "scale=10; $cmp/($n*$n)" | bc -l)
    swap2=$(echo "scale=10; $swap/($n*$n)" | bc -l)
    echo "$n;$cmp;$swap;$cmp1;$swap1;$cmp2;$swap2" >> ratios.dat
done
exec 3<&-

#rysuj wykres

plotuj "porownania" 2 2
plotuj "przestawienia" 3 3
plotujRatio "porownaniaOVERn" 4
plotujRatio "przestawieniaOVERn" 5
plotujRatio "porownaniaOVERn2" 6
plotujRatio "przestawieniaOVERn2" 7

#przenies wykresy do odpowiedniego katalogu
mkdir -p wykresy
mv *.png wykresy
