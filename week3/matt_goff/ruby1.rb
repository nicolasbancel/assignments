#invoice-style output

rooms = ["bedroom", "kitchen", "bathroom", "livingroom"]

def clean_house(rooms)
rooms.each do |room|
  clean_room(room)
end
  puts "The house has been cleaned! Type 'invoice(rooms)' to see your charge details (you thought this was free?!)"
end
def clean_room(room)
  if room == "bedroom"
  make_bed
  vacuum(room)
  elsif room =="kitchen"
    mop_floor
    else
      puts "This room doesn't require any special processes."
  end

  dust(room)
  puts "The " + room + " has been cleaned!"
  end

def make_bed
  puts "The beds have been made."
end
def vacuum(room)
  puts "The #{room} has been vacuumed."
end

def dust(room)
  puts "The #{room} has been dusted!"
end

def mop_floor
  puts "The floor has been mopped."
end

def invoice(rooms)
rooms.each do |room|
    charge(room)
end
  puts "Thank you for supporting working class robots."
end

def charge(room)
  if room == "bedroom"
    puts "$10 for the bedroom"
  elsif room == "bathroom"
    puts "$20 for the bathroom"
  elsif room == "kitchen"
    puts "$15 for the kitchen"
  elsif room == "livingroom"
    puts "$10 for the livingroom"
  end
end 
