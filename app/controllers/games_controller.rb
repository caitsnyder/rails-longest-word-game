require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.shuffle[0, 9]
    @time_start = Time.now
  end

  def score
    test_input = params[:letters].upcase.split("")
    user_input = params[:word].upcase.split("")
    time_start = params[:time]
    time_end = Time.now
    @message_hash = get_score(test_input, user_input, time_start, time_end)
    @message_hash[:our_word] = params[:letters]
    @message_hash[:your_word] = params[:word]
  end

  def get_score(test_input, user_input, time_start, time_end)
    elapsed_time = time_end.to_i - time_start.to_i

    message_hash = {
      time: elapsed_time,
      score: 0,
      message: "Sorry! Your word was not found in the original word."
    }
    return message_hash unless word_in_grid?(user_input, test_input)

    my_url = "https://wagon-dictionary.herokuapp.com/#{user_input.join("")}"
    html_file = open(my_url).read
    result = JSON.parse(html_file)

    message_hash[:score] = 0
    message_hash[:message] = "That is not an english word."
    return message_hash unless result["error"].nil?

    message_hash[:score] = result["length"].to_i
    message_hash[:message] = "Great work!"
    return message_hash
  end

  def word_in_grid?(user_input, test_input)
    user_input.each do |letter|
      if !test_input.include?(letter.upcase)
        return false
      else
        return false if test_input.index(letter).nil?

        test_input.delete_at(test_input.index(letter))
      end
    end
    return true
  end
end
