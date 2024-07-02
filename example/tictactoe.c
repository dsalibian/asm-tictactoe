#include <stdio.h>
#include <stdlib.h>

const int X_WIN = 1;
const int O_WIN = -1;
const int DRAW = 0;
const int NOT_GAMEOVER = 2;

const int COL_MASK = 0b100100100;
const int ROW_MASK = 0b111000000;
const int DIAG0_MASK = 0b100010001;
const int DIAG1_MASK = 0b001010100;
const int FULL_BOARD = 0b111111111;

#define min(a, b) ( (a) < (b) ? (a) : (b)  )
#define max(a, b) ( (a) > (b) ? (a) : (b)  )

int x_bitboard = 0;
int o_bitboard = 0;
int to_move = 1;

int result_masks[8];
void init_result_masks() {
    for(int i = 0; i < 3; i++) {
        result_masks[i]   = COL_MASK >> i;
        result_masks[3+i] = ROW_MASK >> (3*i);
    }
    result_masks[6] = DIAG0_MASK;
    result_masks[7] = DIAG1_MASK;
}

void print_game() {
    for(int i = 0; i < 9; i++) {
        if( i % 3 == 0 ) printf("\n");

        if( ( x_bitboard >> i ) & 1 ) printf("X");
        else if( ( o_bitboard >> i ) & 1 ) printf("O");
        else printf(".");
    }
    printf("\n");
}

int empty(int pos) {
    return !( ( ( x_bitboard | o_bitboard ) >> pos ) & 1 );
}

void make_move(int pos) {
    if( to_move ) x_bitboard |= 1 << pos;
    else o_bitboard |= 1 << pos;

    to_move = !to_move;
}

int eval_now() {
    for(int i = 0; i < 8; i++) {
        int m = result_masks[i];
        if( ( x_bitboard & m ) == m ) return X_WIN;
        if( ( o_bitboard & m ) == m ) return O_WIN;
    }

    return ( FULL_BOARD ^ x_bitboard ^ o_bitboard ) ? NOT_GAMEOVER : DRAW;
}

int minimax() {
    int eval = eval_now();
    if( eval != NOT_GAMEOVER ) return eval;

    int eval_best = to_move ? O_WIN : X_WIN;
    for(int i = 0; i < 9; i++) {
        if( !empty(i) ) continue;

        int t0 = x_bitboard; 
        int t1 = o_bitboard;

        make_move(i);
        eval = minimax();

        x_bitboard = t0;
        o_bitboard = t1;
        to_move = !to_move;

        eval_best = to_move ? max(eval_best, eval) : min(eval_best, eval);
    }
    return eval_best;
}

int best_move() {
    int eval_best = to_move ? O_WIN : X_WIN;
    int best_move = 0;

    for(int i = 0; i < 9; i++) {
        if( !empty(i) ) continue;

        int t0 = x_bitboard;
        int t1 = o_bitboard;

        make_move(i);
        int eval = minimax();

        x_bitboard = t0;
        o_bitboard = t1;
        to_move = !to_move;

        if( to_move ? eval > eval_best : eval < eval_best ) {
            eval_best = eval;
            best_move = i;
        }
    }
    return best_move;
}

int user_move() {
    print_game();
    int x, y, pos;
    scanf("%d %d", &x, &y);
    pos = x + 3 * y;

    if( abs(x-1) > 1 || abs(y-1) > 1 || !empty(pos) ) {
        printf("bad move\n");
        return user_move();
    }
    return pos;
}

void play() {
    while( eval_now() == NOT_GAMEOVER ) 
        make_move( to_move ? user_move() : best_move() );

    print_game();

    int eval = eval_now();
    if( eval == X_WIN ) printf("\n X WINS\n");
    else if( eval == O_WIN ) printf("\n O WINS\n");
    else printf("\n DRAW\n");
}

int main() {
    init_result_masks();
    play();

    return 0;
}
