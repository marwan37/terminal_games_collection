require 'rainbow'
module Displayable
  # *************************** SYSTEM  ****************************
  # CLEAR TERMINAL, SHORTCUT METHODS FOR PROMPTS & COLOR
  def clear
    puts "amit"
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
  end

  def prompt(message)
    puts("=> #{message}")
  end

  def color_prompt(string, color=:goldenrod)
    prompt Rainbow(string).bright.color(color)
  end

  def color(string, sym=:whitesmoke)
    Rainbow(string).color(sym).bright
  end

  # ****************** GAME LOOP RELATED DISPLAYS ******************
  # SHOW RESULTS / SHOW BUSTED / DISPLAY COINBOARD AT END OF GAME
  def show_result
    result = dealer.hand.total <=> player.hand.total
    display_final_coinboard(result)
    case result
    when -1 then color_prompt("#{player.name} wins!", :lime)
    when 1 then color_prompt("#{dealer.name} wins!", :crimson)
    else color_prompt("It's a tie!", :yellow)
    end
    puts ""
  end

  def display_final_coinboard(result)
    case result
    when -1 then coinboard.player_wins
    when  1 then coinboard.dealer_wins
    else         coinboard.tie
    end
    clear
    show_cards(-1)
    sleep 1
  end

  def show_busted
    animate_player_bust if player.busted?
    animate_dealer_bust if dealer.busted?
  end

  # ****************** INTRO/OUTRO RELATED DISPLAYS ******************
  # ****** GREETING PROMPTS / MESSAGES / GOODBYE / ANIMATABLES *******
  def greet_player
    puts ""
    msg = color(dealer.name + ': ', :goldenrod)
    greetings = color("Greetings #{player.name}!")
    animate(msg + greetings, " I'll be your croupier today.")
    2.times { puts "" }
    sleep 1
    explain_betting(msg)
    display_continue_message
  end

  def explain_betting(msg)
    animate(msg, "As a welcome token, here's")
    animate_letters(color(' ＄100!', :limegreen))
    2.times { puts "" }
    sleep 1
    animate(msg, 'Bets are placed before each flop. ')
    animate_letters(color('Minimum bet is', :linen), 0.03)
    animate_letters(color(' ＄10.', :limegreen))
    sleep 1
    2.times { puts "" }
  end

  def animate_letters(str, del=0.05)
    str.each_char do |letter|
      print letter
      sleep del
    end
  end

  def animate(str1, str2, color=:linen)
    print str1
    sleep 1
    str2.each_char do |letter|
      print Rainbow(letter).color(color).bright
      sleep 0.03
    end
    sleep 0.8
  end

  def animate_intro
    clear
    word = " Welcome to Twenty-One!"
    sleep 0.5
    print("\r")
    print "🚀                            " + "\r"
    animate_letters(color("🚀 RB120:", :crimson))
    animate_letters(color(word, :linen), 0.04)
    puts ""
    sleep 0.5
  end

  def display_goodbye_message
    puts ""
    puts color("Thank you for playing Twenty-One. Goodbye!", :khaki)
  end
end
