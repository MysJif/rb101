VALID_CHOICES = %w(rock paper scissors lizard spock)
VALID_ALIAS = %w(r p sc l sp)

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  (first == 'scissors' && second == 'paper') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'rock' && second == 'lizard') ||
    (first == 'lizard' && second == 'spock') ||
    (first == 'spock' && second == 'scissors') ||
    (first == 'scissors' && second == 'lizard') ||
    (first == 'lizard' && second == 'paper') ||
    (first == 'paper' && second == 'spock') ||
    (first == 'spock' && second == 'rock') ||
    (first == 'rock' && second == 'scissors')
end

def display_results(player, computer)
  if win?(player, computer)
    prompt "You won!"
  elsif win?(computer, player)
    prompt "Computer won!"
  else
    prompt "It's a tie!"
  end
end

def complete_choice(choice)
  case choice
  when 'r'
    'rock'
  when 'p'
    'paper'
  when 'sc'
    'scissors'
  when 'l'
    'lizard'
  else
    'spock'
  end
end

def display_score(player, computer)
  prompt "Player: #{player}"
  prompt "Computer: #{computer}"
end

loop do
  player_score = 0
  computer_score = 0

  loop do
    choice = ''
    loop do
      prompt "Choose one: #{VALID_CHOICES.join(', ')}"
      choice = gets.chomp

      if VALID_CHOICES.include?(choice)
        break
      elsif VALID_ALIAS.include?(choice)
        choice = complete_choice(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.sample

    prompt "You chose: #{choice};  Computer chose: #{computer_choice}."

    if win?(choice, computer_choice)
      player_score += 1
    elsif win?(computer_choice, choice)
      computer_score += 1
    end

    display_results(choice, computer_choice)
    display_score(player_score, computer_score)

    break if player_score == 5 || computer_score == 5
  end

  if player_score > computer_score
    prompt("You are the Grand Winner!")
  else
    prompt("Computer is the Grand Winner")
  end

  prompt "Do you want to play again?"
  again = gets.chomp
  break unless again.downcase.start_with?('y')
end

prompt "Thank you for playing. Good bye!"
