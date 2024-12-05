    set terminal pngcairo size 800,600 enhanced font "Verdana,10"
    set output "przestawieniaOVERn-przestawieniaOVERn^2.png"
    set datafile separator ";"
    set grid

    set title "Wykres przestawieniaOVERn, przestawieniaOVERn^2 w zależności od n"
    set xlabel "n"
    set ylabel "stosunek"

    plot         "ratios.dat" using 1:5 title "przestawieniaOVERn" with points pt 7 lc rgb "blue",         "ratios.dat" using 1:7 title "przestawieniaOVERn^2" with points pt 7 lc rgb "red"
