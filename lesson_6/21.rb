# Twenty One
#Rules:
# => 52-card deck consists of: 4 suits [c,d,h,s] & 13 values [2-10,j,q,k,a]
# => goal: <= 21, as close as possible
# => two players: dealer or player -> initially dealt 2 cards each
# card values: 2-10 - face values, j,q,k - 10, ace - 11 or 1
# => player turn: Hit or Stay -> keep hitting until stay or bust
# => computer turn: Hit or Stay -> keep hitting until total at least 17
# => deal busts, then player wins
# => compare cards: when both player and dealer stays 
# => see who has highest value of cards 

# Implementation Steps:
# Initialize deck
# Deal cards to player and dealer
# Player turn: hit or stay
# loop to 1
# repeat until bust or ‘stay’
# keep looping
# 4. If player bust, dealer wins
# 5. Dealer turn: hit or stay
# repeat until total >= 17
# 6. If dealer bust, Player wins
# 7. Compare cards and declare winner

# methods that need to be defined
# => general prompt
# => input name / verify information and eliminate spaces
# => initialize the deck / but do not show the player or computer the deck state
# => calculating aces (11 or 1)
# => player turn
# => exit only when player stays or busted 
# => create busted? method
# => computer turn
# => exit only when computer stays or busted
# => create computer busted? method
# => calculate who won
# => show cards of player and computer
# => ask to play again

WINNING_TOTAL = 21
DEALER_STAYS = 17
SUITS = %w(C D H S)
VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

def prompt(msg)
  puts "=> #{msg}"
end

def display_welcome
  prompt "You are playing Twenty One!"
end

def user_name
  name = ''
  loop do
    prompt "Please enter your name."
    name = gets.chomp
    if name.empty?
      prompt "Enter your name to continue."
    else
      break
    end
  end
  name
end

def display_user_name(user_name)
  prompt " Hello #{user_name}!"
end

def initialize_deck(card_deck)
  SUITS.product(VALUES).map { |card| card_deck << [card[0]] + [card[1]] }
  card_deck
end

def total_value(cards_in_hand)
  values = cards_in_hand.map {|card| card[1]}
  sum = 0

  values.each do |card|
    if card == 'A'
      sum += 11
    elsif card.to_i == 0
      sum += 10
    else
      sum += card.to_i
    end
  end

    values.select { |card| card == 'A' }.count.times do
      sum -=10 if sum > WINNING_TOTAL
    end

  sum
end

def shuffle_and_deal(card_deck, player_hand)
  card_drawn = card_deck.sample
  card_deck.delete(card_drawn)
  player_hand << card_drawn
end

def first_deal_player(card_deck, player_hand)
  shuffle_and_deal(card_deck, player_hand)
  shuffle_and_deal(card_deck, player_hand)
end

def first_deal_dealer(card_deck, dealer_hand)
  shuffle_and_deal(card_deck, dealer_hand)
  shuffle_and_deal(card_deck, dealer_hand)
end

def show(player_hand_drawn)
  player_hand_drawn.each { |card| card[1]}
end

def busted?(player_hand)
  total_value(player_hand) > WINNING_TOTAL
end

def player_choice(card_deck, player_hand)
  loop do
    ans = ''
    prompt "Choose H: Hits or S: Stays."
    
    loop do
      ans = gets.chomp.downcase
      break if ['h', 's'].include?(ans)
    end

    if ans == 'h'
      prompt "You chose to Hit!"
      shuffle_and_deal(card_deck, player_hand)
      prompt "Your current hand is: #{show(player_hand)}."
      prompt "Your current hand total is: #{total_value(player_hand)}."
    end

    break if ans == 's' || busted?(player_hand)
  end 
end

def busted_prompt_player(player_hand)
  if busted?(player_hand)
    prompt "You busted with a total of: #{total_value(player_hand)}."
  else
    prompt "You stayed with total of: #{total_value(player_hand)}."
  end
end

def dealer_choice(card_deck, dealer_hand)
  loop do
    break if total_value(dealer_hand) >= DEALER_STAYS
    prompt "Dealer Hits!"
    shuffle_and_deal(card_deck, dealer_hand)
    prompt "The dealer total hand is: #{total_value(dealer_hand)}"
  end
end
  
def busted_prompt_dealer(dealer_hand)
  if busted?(dealer_hand)
    prompt "Dealer busted with a total of: #{total_value(dealer_hand)}."
  else
    prompt "Dealer stayed with total of: #{total_value(dealer_hand)}."
  end
end

def winner?(player_hand, dealer_hand)
  player_total = total_value(player_hand)
  dealer_total = total_value(dealer_hand)

  if player_total > dealer_total
    return "Player Wins!"
  elsif player_total > WINNING_TOTAL
    return "Player Busted!"
  elsif dealer_total > player_total
   return  "Dealer Wins!"
  elsif dealer_total > WINNING_TOTAL
    return "Dealer Busted!"
  else
    return "It is a tie"
  end

end

def display_winner(player_hand, dealer_hand)
  winner = winner?(player_hand, dealer_hand)

  if winner == "Player Wins!"
    prompt "Player Won!"
  elsif winner == "Player Busted!"
    prompt "Player Busted, Dealer Won!"
  elsif winner == "Dealer Wins!"
    prompt "Dealer Won!"
  elsif winner == "Dealer Busted!"
    prompt "Dealer Busted, Player Won!"
  else
    prompt "It is a tie!"
  end
end

def play_again?
  choice = ''

  loop do
    prompt "Play again? (y or n)"
    choice = gets.chomp
    break if %w(yes y n no).include?(choice)
    prompt "Please enter yes or no to play again."
  end

  choice == 'n' || choice == 'no'
end

display_welcome
display_user_name(user_name)

loop do
  card_deck = []
  dealer_cards = []
  player_cards = []

  initialize_deck(card_deck)

  first_deal_player(card_deck, player_cards)
  first_deal_dealer(card_deck, dealer_cards)

  prompt "Player: #{show(player_cards)[0]}, #{show(player_cards[1])}" 
  prompt "Dealer: #{show(dealer_cards[0])} and unknown card."

  prompt "Your current hand total is: #{total_value(player_cards)}."

  player_choice(card_deck, player_cards)
  busted?(player_cards)
  busted_prompt_player(player_cards)

  prompt "It is now the Dealer's turn!..."

  dealer_choice(card_deck, dealer_cards)
  busted?(dealer_cards)
  busted_prompt_dealer(dealer_cards)

  display_winner(player_cards, dealer_cards)
  prompt "Player: #{show(player_cards)}." 
  prompt "Dealer: #{show(dealer_cards)}."

  break if play_again?
end
