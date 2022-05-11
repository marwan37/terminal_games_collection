module DisplayableParticipant
  # *********************** PLAYER *************************
  # ********** PROMPTS RELATING TO PLAYER STATUS ***********

  def player_decides_to_stay?
    prompt "Would you like to #{color('(h)')}it or #{color('(s)')}tay?"
    answer = nil
    loop do
      answer = gets.chomp.strip
      break if %w(h hit s stay).include?(answer.downcase)
      prompt 'Please enter a valid input (h to hit, s to stay)'
    end
    puts ""
    answer.downcase == 's'
  end

  def animate_player_bust
    coinboard.dealer_wins
    clear
    show_cards(-1)
    player_bust = "=> " + color("Busted!", :red)
    animate(player_bust, " #{dealer.name} wins!", :red)
    sleep 1
    2.times { puts "" }
  end

  def display_game_number
    color_prompt("Twenty-One!", :goldenrod)
    puts ""
    sleep 1
    display_continue_message
  end

  def display_final_player_status
    return show_busted if player.busted?
    return display_game_number if player.game_number?
    show_player_cards_only(0)
    puts color("#{player.name}: #{color('Stay!')}", :aqua)
    sleep 2
  end

  # *** prompt at end fo each game loop - continue or 'quit' ***
  def play_again?
    color_prompt("Press any key to continue! ", :seashell)
    puts Rainbow("=> (you can also type 'quit' to cash out)").dimgray
    answer = gets.chomp
    answer.strip.downcase != 'quit'
  end

  def show_out_of_coins
    sleep 1
    msg = "=> " + color("You ran out of coins...", :crimson)
    animate(msg, " :(", :crimson)
    sleep 1
    2.times { puts "" }
  end

  # called if player is out of coins or ::play_again? == 'quit'
  def start_over?
    answer = nil
    color_prompt("Would you like to reset and start over? (y/n)", :seashell)
    loop do
      answer = gets.chomp.downcase.strip
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def display_continue_message
    color_prompt("Press any key to continue...", :khaki)
    gets
    clear
  end

  # *********************** DEALER *************************
  # ***** PROMPTS/MESSAGES RELATING TO DEALER/COMPUTER *****

  def display_showing_dealer
    color_prompt("Showing #{dealer.name}'s hand...", :goldenrod)
    sleep 2
    clear
  end

  def dealer_stays
    msg1 = color(dealer.name + ': ', :goldenrod)
    animate(msg1, 'Stay!', :linen)
    sleep 1
    2.times { puts "" }
  end

  def animate_dealer_bust
    coinboard.player_wins
    clear
    show_cards(-1)
    dealer_bust = "=> " + color("Busted!", :crimson)
    animate(dealer_bust, " #{player.name} wins!", :lime)
    sleep 1
    2.times { puts "" }
  end

  def display_dealer_hits
    sleep 1
    header = color(dealer.name + ': ', :goldenrod)
    animate(header, 'Hit!', :linen)
    sleep 1
    clear
  end

  def display_dealer_stays
    sleep 1
    msg1 = color(dealer.name + ': ', :goldenrod)
    animate(msg1, 'Stay!', :linen)
    sleep 1
  end
end
