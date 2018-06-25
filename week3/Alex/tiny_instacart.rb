require 'byebug'

@customers = {
    "ron"=> {
        "phone_number"=> "4151234567",
        "address"=> "123 st.",
        "city"=> "San Francisco, CA",
        "id"=> 1
    },
    "bob"=> {
        "phone_number"=> "5101234567",
        "address"=> "456 st.",
        "city"=> "Oakland, CA",
        "id"=> 2
    },
    "mel"=> {
        "phone_number"=> "6501234567",
        "address"=> "789 st.",
        "city"=> "San Jose, CA",
        "id"=> 3
    }

}

@stores = {
    "kroger"=> ["banana", "apple", "popcorn"],
    "costco"=> ["water", "hot dog", "churro"],
    "earth fare"=> ["trail mix", "almonds", "oranges"]
}

@drivers = {
    "kyle"=> {
        "location"=> "San Francisco, CA"
    },
    "brad"=> {
        "location"=> "Oakland, CA"
    },
    "jessica"=> {
        "location"=> "San Jose, CA"
    },
}

@orders = {}
@order_id = 0
@customer_id = ""
@shopper = ""
#@item_list = []

# batch order to driver
# fulfil order steps
# inform the customer is complete

def get_id
    # get info
    print "Welcome to Tiny Instacart! What is your name?-> "
    name = ""
    until @customers.keys.include? name
        name = gets.chomp.downcase
        if @customers.keys.include? name
            puts "Thank you!"
        else
            print "Account not found! Please enter your name: "
        end
    end
    @customer_id = @customers[name]["id"]
end

def take_order
    # take order add to orders
    print "Which store would you like to shop from? Please enter the name of the store. For a list of stores, type 'Help'.-> "
    store = ""
    until @stores.keys.include? store #|| store == "earthfare"
        store = gets.chomp.downcase
        if @stores.keys.include? store #|| store == "earthfare"
            next
        elsif store == "help"
            puts @stores.keys
            print "Please enter a store.-> "
        else
            print "Store not found! Please enter a store or 'Help' for a list of stores.-> "
        end
    end

    #byebug
    item_list = []
    item = ""
    response = ""
    # add items to list
    until item == "done"
        print "What would you like to buy? Please enter a product. For a list of available products, type 'products'. When finished type 'Done'.-> "
        item = gets.chomp.downcase
        if item == "products"
            puts @stores[store]
        elsif @stores[store].include? item
            # ask for quantity
            item_count = 0
            until item_count > 0
                print "How many would you like?-> "
                item_count = 0
                item_count = gets.chomp.to_i
                item_list = []
                #byebug
                item_list.fill(item, item_list.size, item_count)
                puts "#{item_count} #{item}(s) were added to cart!"
                @order_id += 1
                # put order in orders hash
                #byebug
                @orders[@order_id] = item_list
                #byebug
            end
        # type done when finished
        elsif item == "done"
            puts "Finished!"
        else
            puts "Error! Please put the correct item!"
        end
    end
end

def get_items
    # batch order to driver
    match = @customers.select{ |key, value| value["id"] == @customer_id}
    match = match.keys[0]
    @shopper = @drivers.select{ |key, value| value["location"] == @customers[match]["city"]}
    puts "Your shopper is #{@shopper.keys[0]}!"
    @orders.each { |key, value|
        value.each { |ordered_item|
            puts "A #{ordered_item} has been found!"
        }

    }
    puts "Your order is finished! The order is now on it's way!"
    sleep 5
    puts "The delivery sucessful!!!"
    @orders.clear
end

# def place_order
#     response = ""
#     get_id()
#     until response == "n"
#         response = ""
#         take_order()
#         #byebug
#         get_items()
#         print "Do you want to place another order?(y/n)-> "
#         response = gets.chomp
#         if response == "y"
#             next
#         elsif response == "n"
#             puts "Thanks for using Tiny Instacart!!!!!"
#         else
#             puts "Please enter 'y' or 'n'!"
#         end
#     end
# end

#byebug
place_order()
