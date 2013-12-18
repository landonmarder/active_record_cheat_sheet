# Main idea -- Active Record insulates you from the need to use SQL in most cases

# Here are the models that we are dealing with (different tables in a database)
class Client < ActiveRecord::Base
  has_one :address,
    inverse_of: clients,
    dependent: :destroy

  has_many :orders,
    inverse_of: :clients,
    dependent: :destroy

  has_and_belongs_to_many :roles
end

# Address has the client foreign key
class Address < ActiveRecord::Base
  belongs_to :client
end

# Order has the client foreign key
class Order < ActiveRecord::Base
  belongs_to :client, counter_cache: true
end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :clients
end

# Retrieving a Single Object

Client.find(10) # Retrieves the client with primary key of 10
Client.take # Retrieves a client record
Client.first # Retrieves the first client record
Client.last # Retrieves the last client record
Client.find_by first_name: 'John' # Retrieves the first client with the first name John

# Retrieving Multiple Objects

Client.find([1,10]) # Retrieves the clients with primary key 1 and 10
Client.take(2) # Retrieves the first two clients
Client.first(2) # Retrieves the first two clients
Client.last(2) # Retrieves the last two clients
Client.find_each(start: 2000, batch_size: 5000) do |client|   # Preferred way of iterating over instead of Client.all.each (does a batch of records at a time, so less wear and tear on memory)
  NewsLetter.weekly_deliver(client)                           # start refers to what primary key to start at, batch is the batch size
end

# Conditions


