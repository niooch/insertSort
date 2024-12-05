#include <vector>
#include <random>
#include <algorithm>
#include <iostream>
void symulacja(int n);
int main(int argc, char** argv) {
    //wczytaj liczbe n
    if(argc!=2){
        std::cout<<"uzycie "<<argv[0]<<" n"<<std::endl;
        return 1;
    }
    int n = std::stoi(argv[1]);
    for(int i=1; i<=50; i++){
        symulacja(n);
    }
    return 0;
}
void symulacja(int n){
    //generuj tablice o dlugosci n
    std::vector<int> tab(n);
    //inicjalizuj generator liczb losowych merseene twister
    std::random_device rd;
    std::mt19937 gen(rd());
    //stworz losowa premutacje liczb od 1 do n i zapisz ja w tablicy
    for(int i=0; i<n; i++){
        tab[i] = i+1;
    }
    std::shuffle(tab.begin(), tab.end(), gen);
    //insertion sort, policz ile jest wykonanych porownan, oraz przesuniec miedzy kluczami
    long long porownania = 0;
    long long przesuniecia = 0;
    for(int i=1; i<n; i++){
        int j = i;
        while(j>0 && tab[j-1]>tab[j]){
            std::swap(tab[j-1], tab[j]);
            j--;
            porownania++;
            przesuniecia++;
        }
        porownania++;
    }
    //wypisz wynik
    std::cout<<n<<";"<<porownania<<";"<<przesuniecia<<std::endl;
}
