def guessing_game
  puts "I'm going to think of a number between 1 and 10."
  num = 1 + rand(10)
  puts "Okay, now you try to guess it: "
  guess = gets.to_i
until guess == num
  puts "Wrong! Guess again: "
  guess = gets.to_i
end
  puts "You got it!"
end
