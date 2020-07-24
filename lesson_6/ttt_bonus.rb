# Walkthrough: Tic Tac Toe

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9]] + 
                [[1,4,7], [2,5,8], [3,6,9]] + 
                [[1,5,9], [3,5,7]]

GAME_FINISH = 5

CHOOSE_FIRST_PLAYER = 'Choose'

def prompt(msg)
  puts "=> #{msg}"
end

def ask_for_name
  answer = gets.chomp
  prompt "Welcome #{answer}!"
end

def who_goes_first?
  prompt "Choose who goes first - Player: P or Computer: C"
  loop do
    choice = gets.chomp.downcase
    if choice == 'p'
      return 'Player'
    elsif choice == 'c'
      return 'Computer'
    end
    break if choice == 'p' || choice == 'c'
    prompt "Please chooce p or c"
  end
end

def first_to_move
  if CHOOSE_FIRST_PLAYER == 'Choose'
    who_goes_first?
  elsif CHOOSE_FIRST_PLAYER == 'p'
    'Player'
  elsif CHOOSE_FIRST_PLAYER == 'c'
    'Computer'
  end
end

def alternate_player(current_player)
  current_player == 'Player' ? 'Computer' : 'Player'
end 

# rubocop: disable Metrics/MethodLength, Metrics/AbcSize
def display_board(brd)
  # system 'clear'
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |"
  puts ""
end
# rubocop: enable Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimiter = ', ', conjuction = 'or')
  if arr.size == 0
    ''
  elsif arr.size == 1
   "#{arr.first}"
  elsif arr.size == 2
    "#{arr.first} #{conjuction} #{arr.last}"
  else
    arr[-1] = "#{conjuction} #{arr.last}"
    arr.join(delimiter)
  end
end

def place_piece!(brd, current_player)
  if current_player == 'Player'
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def player_places_piece!(brd)
  square = ''
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  prompt "The game is up to #{GAME_FINISH}!"
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square) 
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2
    brd.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
  end
end

def computer_ai(brd, marker)
  square = ''

  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, marker)
    break if square
  end
  square
end

def computer_places_piece!(brd)
  offense = computer_ai(brd, COMPUTER_MARKER)
  defense = computer_ai(brd, PLAYER_MARKER)
  random_square = empty_squares(brd).sample

  square = offense || defense || random_square
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def display_current_winner(brd)
  if someone_won?(brd)
    prompt "#{detect_winner(brd)} won!"
  else
    prompt "It's a tie!"
  end
end

def revise_score(winner, score)
  if winner == 'Player'
    score['Player'] += 1
  elsif winner == 'Computer'
    score['Computer'] += 1
  end
end

def show_score(score)
  prompt "The current score is --- Player: #{score['Player']} \
   Computer: #{score['Computer']}"
 end

def active_game_done?(score)
  score['Player'] == GAME_FINISH || score['Computer'] == GAME_FINISH
end

def overall_winner(score)
  if score['Player'] == GAME_FINISH
    prompt "Player Wins!"
  else
    prompt "Computer Wins!"
  end
end

def play_again?
  choice = ''
  loop do
    prompt "Play again? (y or n)"
    choice = gets.chomp
    break if %w(yes y n no).include?(choice)
    prompt "Please enter y to play again."
  end
  choice == 'n' || choice == 'no'
end

# Step 3: The main game loop
prompt "Welcome to TIC TAC TOE!"
prompt "Please enter your name: "
user_name = ask_for_name

loop do
  score = {'Player' => 0, 'Computer' => 0}
  
  loop do

    board = initialize_board
    current_player = first_to_move

    loop do
      display_board(board)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board) 
    end

    display_board(board)

    display_current_winner(board)

    revise_score(detect_winner(board), score)

    show_score(score)

    break if active_game_done?(score)
  end

  overall_winner(score)
  break if play_again?
end

prompt "Thanks for playing Tic Tac Toe --- Goodbye!."







