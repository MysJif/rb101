require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
FIRST = 'choose'

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd, player_score, computer_score)
  system 'clear'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "Player: #{player_score}. Computer: #{computer_score}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_choice!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

# rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
def computer_choice!(brd)
  square = nil

  WINNING_LINES.each do |line|
    square = find_risky_square(line, brd, COMPUTER_MARKER)
    break if square
  end

  if !square
    WINNING_LINES.each do |line|
      square = find_risky_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end

  if !square && empty_squares(brd).include?(5)
    square = 5
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end
# rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

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

def joinor(list, joiner=', ', final='or')
  last = list.pop
  "#{list.join(joiner)} #{final} #{last}"
end

def find_risky_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

player_score = 0
computer_score = 0

loop do
  board = initialize_board
  case FIRST
  when 'player'
    loop do
      display_board(board, player_score, computer_score)

      player_choice!(board)
      break if someone_won?(board) || board_full?(board)

      computer_choice!(board)
      break if someone_won?(board) || board_full?(board)
    end
  when 'computer'
    loop do
      computer_choice!(board)
      break if someone_won?(board) || board_full?(board)
      display_board(board, player_score, computer_score)

      player_choice!(board)
      break if someone_won?(board) || board_full?(board)
    end
  else
    prompt "Who goes first? (Player or Computer)"
    FIRST = gets.chomp.downcase
  end
  display_board(board, player_score, computer_score)

  if someone_won?(board)
    case detect_winner(board)
    when 'Player' then player_score += 1
    when 'Computer' then computer_score += 1
    end
    display_board(board, player_score, computer_score)
    prompt "#{detect_winner(board)} won!"
  else
    display_board(board, player_score, computer_score)
    prompt "It's a tie!"
  end

  next unless player_score >= 5 || computer_score >= 5

  prompt "Play again?"
  answer = gets.chomp
  if answer.downcase.start_with?('y')
    player_score = 0
    computer_score = 0
  else
    break
  end
end

prompt "Thanks for playing Tic Tac Toe! Goodbye!"
