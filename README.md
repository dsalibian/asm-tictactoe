# asm-tictactoe

tic-tac-toe fully written in x86-64 assembly

#### how to play
compile and run the executable<br>

user plays first as X<br>
play move simply by entering index of board to place X

board square indices:<br>
0 1 2<br>
3 4 5<br>
6 7 8<br>

note: no checks for validity of move YET (e.g. valid index)

#### compiling: 
gcc -no-pie -z noexecstack -o main src/*.s

run the executable main
