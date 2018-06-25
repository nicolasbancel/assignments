# room = "bedroom"
def clean_room(room)
    # the room is bedroom
    if room == "bedroom"
        make_bed
        vacuum(room)
    elsif room == "kitchen"
        mop_floor
    else
        puts "This room doesn't require any special processes."
    end
    dust_room(room)
    puts "The " + room + " has been cleaned!"
end

def make_bed
    puts "The bed has been maded."
end

def vacuum(room)
    puts "The #{room} has been vacuumed."
end

def dust_room(room)
    puts "The #{room} has been dusted."
end

def mop_floor
    puts "The floor has been mopped."
end

def clean_house(rooms)
    rooms.each do |x|
        clean_room(x)
    end
end

#rooms = ["bedroom", "kitchen", "bathroom", "livingroom"]

rooms = []
total = 0
count = 0

cost = {
    "bedroom" => 45,
    "kitchen" => 70,
    "bathroom" => 30,
    "livingroom" =>55
}
num_rooms = {
    "bedroom": 0,
    "kitchen": 0,
    "bathroom": 0,
    "livingroom": 0
}

puts "Hello! Welcome to Alex's robot cleaning service."
# gets how many bedrooms
print "How many bedrooms do you want cleaned? -> "
num_rooms["bedroom"] = gets.chomp.to_i #if gets.chomp.to_i.to_a?Integer
# gets how many kitchen
print "How many kitchen do you want cleaned? -> "
num_rooms["kitchen"] = gets.chomp.to_i
# gets how many bathroom
print "How many bathroom do you want cleaned? -> "
num_rooms["bathroom"] = gets.chomp.to_i
# gets how many livingroom
print "How many livingroom do you want cleaned? -> "
num_rooms["livingroom"] = gets.chomp.to_i


#push rooms into rooms list with quantity
num_rooms.each { |key, value|
    rooms.fill(key, rooms.size, value)
}

#get total
rooms.each do |type|
   total += cost[type]
end
puts "Your total is: $#{total}"

#print "Do you want to proceed?(y/n) "
#answer = gets.chomp
answer = ""
until answer.downcase == 'y' ||  answer.downcase == 'n'
    print "Do you want to proceed?(y/n) "
    answer = gets.chomp
end

if answer == 'y'
    puts "Thank you!"
    clean_house(rooms)
elsif answer == 'n'
    puts "Bye! Please come again."
else
    "Sorry, There was an error!"
end
