# Create The Board
import random

board = ["-","-","-",
         "-","-","-",
         "-","-","-"]

current_player = "X"            # User is X
winner = None
game_running = True

# Game Board

def game_board(board):
    print(board[0] + " | " + board[1] + " | " + board[2])
    print("---------")
    print(board[3] + " | " + board[4] +" | " + board[5])
    print("---------")
    print(board[6] + " | " + board[7] + " | " + board[8])

# Player Input
def player_input(board):
    user_input = int(input("Enter a position number between 1 to 9: "))
    if board[user_input-1] == "-":
        board[user_input-1] = current_player
    else:
        print("Oops Player already in that position")
        switch_player()

# Check If A Win Or Tie

def check_horizonal(board):    # horizonal check
    global winner
    if board[0] == board[1] == board[2] and board[0] != "-":
        winner = board[0]
        return True
    elif board[3] == board[4] == board[5] and board[3] != "-":
        winner = board[3]
        return True
    elif board[6] == board[7] == board[8] and board[6] != "-":
        winner = board[6]
        return True

def check_row(board):         # row check
    global winner
    if board[0] == board[3] == board[6] and board[0] != "-":
        winner = board[0]
        return True
    elif board[1] == board[4] == board[7] and board[1] != "-":
        winner = board[1]
        return True
    elif board[2] == board[5] == board[8] and board[2] != "-":
        winner = board[2]
        return True

def check_diagonal(board):    # diagonal check
    global winner
    if board[0] == board[4] == board[8] and board[0] != "-":
        winner = board[0]
        return True
    elif board[2] == board[4] == board[6] and board[2] != "-":
        winner = board[2]
        return True

def check_if_win(board):     # checking for a win
    global game_running
    if check_horizonal(board):
        game_board(board)
        print(f"The winner is {winner}")
        print(f"Congratulations '{winner}' on the win!")
        game_running = False

    elif check_row(board):
        game_board(board)
        print(f"The winner is {winner}")
        print(f"Congratulations '{winner}' on the win!")
        game_running = False

    elif check_diagonal(board):
        game_board(board)
        print(f"The winner is {winner}")
        print(f"Congratulations '{winner}' on the win!")
        game_running = False

def check_if_tie(board):    # checking for a tie
    global game_running
    if "-" not in board:
        game_board(board)
        print("It is a tie!")
        game_running = False

def switch_player():       # switching the player
    global current_player
    if current_player == "X":
        current_player = "O"
    else:
        current_player = "X"

def computer(board):       # computer as the player 2
    while current_player == "O":
        position = random.randint(0,8)
        if board[position] == "-":
            board[position] = "O"
            switch_player()

while game_running:
    game_board(board)
    player_input(board)
    check_if_win(board)
    check_if_tie(board)
    switch_player()
    computer(board)
    check_if_win(board)
    check_if_tie(board)




