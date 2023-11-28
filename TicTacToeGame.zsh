#!/bin/zsh

initialize() {
    board=(1 2 3 4 5 6 7 8 9)
}



print_board() { 
    echo
    echo " ${board[1]} | ${board[2]} | ${board[3]} "
    echo "---|---|---"
    echo " ${board[4]} | ${board[5]} | ${board[6]} "
    echo "---|---|---"
    echo " ${board[7]} | ${board[8]} | ${board[9]} "
    echo
}

check() {
    local winner=''

    check_match() {
        if [[ ${board[$1]} == ${board[$2]} && ${board[$2]} == ${board[$3]} ]]; then
            winner="Player ${board[$1]}"
        fi
    }

    check_match 1 2 3
    check_match 4 5 6
    check_match 7 8 9
    check_match 1 4 7
    check_match 2 5 8
    check_match 3 6 9
    check_match 1 5 9
    check_match 3 5 7

    if [[ -n $winner ]]; then
        echo "$winner wins!"
        break
    fi

    # Check for a draw
    check_draw && echo "It's a draw!"
}

make_move() {
    echo "Player '$1''s turn. Enter your move: (Press S to Save Game)"
    read -r move
    if [[ $move == 'S' ]]; then
        save_game
        return 1
    fi
    if (( move < 1 || move > 9 )); then
        echo "Invalid move. Please enter a number from 1 to 9. Try again."
        return 1
    fi
    if [[ ${board[$move]} == 'X' ]] || [[ ${board[$move]} == 'O' ]]; then
        echo "Invalid move. Cell already taken. Try again."
        return 1
    fi
    board[$move]=$1
    return 0
}

check_draw() {
    for cell in "${board[@]}"; do
        if [[ "$cell" != 'X' && "$cell" != 'O' ]]; then
            return 1
        fi
    done
    echo "It's a draw!"
    break
}

computer_turn(){
    echo "Computer's turn..."
    move=$(($RANDOM%9 + 1))
    if [[ ${board[$move]} == 'X' ]] || [[ ${board[$move]} == 'O' ]]; then
        return 1
    else
        board[$move]='O'
    fi   
}


save_game() {
  echo ${board[*]} > game_save.txt
  echo "Game has been saved."
}


load_game() {
  if [[ ! -e "game_save.txt" ]]; then
    echo "No saved game found."
  else
    board=($(< game_save.txt))
    echo "Game has been loaded."
  fi
}

game_vs_player() {
    while true; do
            print_board
            while ! make_move 'X'; do : ; done
            print_board
            check
            check_draw
            while ! make_move 'O'; do : ; done
            check
            check_draw
        done
}
game_vs_computer() {
    while true; do
            print_board
            while ! make_move 'X'; do : ; done
            print_board
            check
            check_draw
            computer_turn
        done
}
print_menu(){
    echo "----------------"
    echo "Tic Tac Toe Game"
    echo "----------------"
    echo "'1' for Player vs Player"
    echo "'2' for Player vs Computer"
    echo "'3' Load Game"
    echo "'4' Exit Game: "
    echo "----------------"
    echo "Your choise : "
    read -r choice
}

while true; do
    print_menu
    case $choice in
        1)
            initialize
            game_vs_player
            ;;
        2)
            initialize
            game_vs_computer
            ;;
        3)
            load_game
            game_vs_player
            ;;
        4)
            echo "Thank you for game"
            exit
            ;;
        *)
            echo "Invalid choice! Please try once again!"
            ;;
    esac
done