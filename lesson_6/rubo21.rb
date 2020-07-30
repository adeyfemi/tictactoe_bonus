WINNING_TOTAL = 21
DEALER_STAYS = 17
SUITS = %w(C D H S)
VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

GAME_FINISH = 5

def prompt(msg)
  puts "=> #{msg}"
end

def display_welcome
  prompt "You are playing Twenty One!"
end

def display_game_rules
  prompt "The game is up to #{GAME_FINISH}!"
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
  values = cards_in_hand.map { |card| card[1] }
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
    sum -= 10 if sum > WINNING_TOTAL
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
  player_hand_drawn.each { |card| card[1] }
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

  if player_total > dealer_total || (dealer_total < WINNING_TOTAL)
    return "Player Wins!"
  elsif player_total > WINNING_TOTAL
    return "Player Busted!"
  elsif (dealer_total > player_total) || (dealer_total < WINNING_TOTAL)
    return "Dealer Wins!"
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

def display_current_winner(player_hand, dealer_hand)
  display_winner(player_hand, dealer_hand)
end

def revise_score(player_hand, dealer_hand, score)
  if winner?(player_hand, dealer_hand) == 'Player Wins!'
    return score['Player'] += 1
  elsif winner?(player_hand, dealer_hand) == 'Dealer Wins!'
    return score['Dealer'] += 1
  end
end

def show_score(score)
  prompt "The current score is --- Player: #{score['Player']} \
   Dealer: #{score['Dealer']}"
end

def active_game_done?(score)
  score['Player'] == GAME_FINISH || score['Dealer'] == GAME_FINISH
end

def continue_game?
  ans = ''
  loop do
    prompt "Enter C: continue or E: exit the current game."
    ans = gets.chomp.downcase
    break if %w(c e).include?(ans)
    prompt "Invalid entry. Please enter C: continue or E: exit."
  end
  ans == 'e'
end

def overall_winner(score)
  if score['Player'] == GAME_FINISH
    prompt "Player Wins!"
  else
    prompt "Dealer Wins!"
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
  score = { 'Player' => 0, 'Dealer' => 0 }

  display_game_rules
  prompt "Current Score - Player: #{score['Player']}, Dealer: #{score['Dealer']}."

  loop do

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
   
      revise_score(player_cards, dealer_cards, score)
      show_score(score)
      break if active_game_done?(score)
    end

    break if continue_game?
  end

  overall_winner(score)
  break if play_again?
end

prompt "Thanks for playing Twenty One."
