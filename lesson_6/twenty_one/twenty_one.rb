def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Layout/LineLength
# Returns a fresh deck
def init_deck
  [['C', 'A'], ['C', '2'], ['C', '3'], ['C', '4'], ['C', '5'], ['C', '6'], ['C', '7'], ['C', '8'], ['C', '9'], ['C', '10'], ['C', 'J'], ['C', 'Q'], ['C', 'K'],
   ['D', 'A'], ['D', '2'], ['D', '3'], ['D', '4'], ['D', '5'], ['D', '6'], ['D', '7'], ['D', '8'], ['D', '9'], ['D', '10'], ['D', 'J'], ['D', 'Q'], ['D', 'K'],
   ['H', 'A'], ['H', '2'], ['H', '3'], ['H', '4'], ['H', '5'], ['H', '6'], ['H', '7'], ['H', '8'], ['H', '9'], ['H', '10'], ['H', 'J'], ['H', 'Q'], ['H', 'K'],
   ['S', 'A'], ['S', '2'], ['S', '3'], ['S', '4'], ['S', '5'], ['S', '6'], ['S', '7'], ['S', '8'], ['S', '9'], ['S', '10'], ['S', 'J'], ['S', 'Q'], ['S', 'K']]
end
# rubocop:enable Layout/LineLength

# Mutates both hand and deck
def deal_cards!(hand, deck)
  card = nil
  if hand.empty?
    2.times do
      card = deck.sample
      deck.delete(card)
      hand << card
    end
  else
    card = deck.sample
    deck.delete(card)
    hand << card
  end
end

# Returns an integer value of a hand
def hand_value(hand)
  value = 0
  hand.each do |card|
    if card[1] == 'A'
      value += 11
    elsif card[1].to_i == 0
      value += 10
    else
      value += card[1].to_i
    end
  end

  hand.select { |card| card[1] == 'A' }.count.times do
    value -= 10 if value > 21
  end

  value
end

# Returns a boolean
def busted?(hand)
  hand_value(hand) > 21
end

# Returns a string interpreation of card array
def parse(card)
  suit = ''
  value = ''
  case card[0]
  when 'C' then suit = 'Clubs'
  when 'D' then suit = 'Diamonds'
  when 'H' then suit = 'Hearts'
  when 'S' then suit = 'Spades'
  end

  case card[1]
  when 'K' then value = 'King'
  when 'Q' then value = 'Queen'
  when 'J' then value = 'Jack'
  when 'A' then value = 'Ace'
  else value = card[1]
  end
  
  "#{value} of #{suit}"
end

# Displays a provided hand
def display_hand(hand, player)
  prompt "#{player} hand is: (#{hand_value(hand)})"
  hand.each do |card|
    puts parse(card)
  end
end

# Player hit / stand loop
def player(hand, deck)
  answer = nil
  loop do
    prompt 'Would you like to hit or stand?'
    answer = gets.chomp
    break if answer.downcase.start_with?('s')
    deal_cards!(hand, deck)
    display_hand(hand, 'Player')
    break if busted?(hand)
  end

  if busted?(hand)
    prompt "You busted! Dealer wins."
  else
    prompt 'You chose to stand.'
  end
end

# Dealer loop
def dealer(hand, deck)
  loop do
    break if hand_value(hand) >= 17 || busted?(hand)
    deal_cards!(hand, deck)
  end

  if busted?(hand)
    prompt "Dealer busted. You win!"
  end
end

# Main game
def game
  deck = init_deck
  player_hand = []
  dealer_hand = []

  deal_cards!(player_hand, deck)
  deal_cards!(dealer_hand, deck)

  prompt "Dealer's face-up card is: (#{hand_value(dealer_hand[-1..-1])})"
  puts parse(dealer_hand[-1])

  puts ''

  display_hand(player_hand, 'Player')

  player(player_hand, deck)
  return if busted?(player_hand)
  dealer(dealer_hand, deck)
  return if busted?(dealer_hand)

  system 'clear'

  display_hand(dealer_hand, 'Dealer')
  puts ''
  display_hand(player_hand, 'Player')
  puts ''

  if hand_value(dealer_hand) > hand_value(player_hand)
    prompt "Dealer wins with a #{hand_value(dealer_hand)}!"
  elsif hand_value(dealer_hand) == hand_value(player_hand)
    prompt "Draw! Both you and the dealer have #{hand_value(player_hand)}!"
  else
    prompt "You win with a #{hand_value(player_hand)}!"
  end
end

loop do
  system 'clear'
  game
  prompt "Would you like to play again?"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing!"
