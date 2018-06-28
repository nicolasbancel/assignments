#Delivery-only batch workflow

def batch_start
  bag_count = 1 + rand(10)
  puts "This order has #{bag_count} bags.
  Please collect all bags from the staging area and type 'start_delivery' when ready."
end

def start_delivery
  due_time = Time.now + 60 * 60
  address = "123 Main Street, Austin TX"
  puts "This delivery is due in one hour at #{due_time}.
  Please proceed to the delivery address at #{address} and type 'done' when finished."
end

def done
  shopper_name = "Matt"
  last_batch = true
    puts "Thanks #{shopper_name}!"
  if last_batch == true
    puts "Your shift is over.
    How was your shift today on a scale of 1 to 5?"
    shift_rating = gets.to_i
  end
  if shift_rating == 5
    puts "Great to hear!"
  else
    puts "Oh no! Tell us what went wrong: "
    gets
end
end
