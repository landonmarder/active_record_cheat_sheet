# Main idea -- Active Record insulates you from the need to use SQL in most cases

# Here are the models that we are dealing with (different tables in a database, think of as different Active Record Array)
class Client < ActiveRecord::Base
  has_one :address,
    inverse_of: clients,
    dependent: :destroy

  has_many :orders,
    inverse_of: :clients,
    dependent: :destroy

    validates :orders_count, presence: true

end

# Order has the client foreign key
class Order < ActiveRecord::Base
  belongs_to :client,
   inverse_of: :orders
end


# Retrieving a Single Object

Client.find(10) # Retrieves the client with primary key of 10
Client.find(first_name: "John") # Retrieves the first client with first name John
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

# Pluck -- Unlike select, pluck directly converts a database result into a Ruby Array
Client.pluck(:id, :name) # Accepts a list of column names as arguments and returns an array of values of the specified values (this will be an array of arrays, each inside array will have id and name for each client)

# Conditions

Client.where("orders_count = ?", "10") # Retrieves all the client records
Client.where(first_name: 'John') # Retrieves all the client records with first name John
Client.where(order_id: "0123") # Retrieves all the client records where there is an order_id of 0123, joins from the Order table because of belongs_to relationship
Client.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight) # Retrieve all client records created within that time period
Client.where(orders_count: [1,3,5])  # Retrieves all the client records that include this order count
Client.where.not(first_name: "John") # Retrieves all the client records not named John
Order.where('id > 10') # Retrieves all order records that have an id greater than 10

time_range = (Time.now.midnight - 1.day)..Time.now.midnight
Client.joins(:orders).where(orders: {created_at: time_range}) # Specifying conditions on a JOIN, Client and Orders join, condition on the order table


# Ordering
Client.order(created_at: :desc) # Retrieves all the client records ordered by created at descending
Client.order(orders_count: :asc, created_at: :desc) # Retrieves all the client records ordered first by order count, then created at

# Selecting Specific Fields
Client.select(:first_name) # Retrieves all the first_names of clients
Client.select(:first_name).distinct # Retrieves all the distinct first_names of clients

# Limit and Offset
Client.limit(5) # Will return a maximum of 5 clients
Client.limit(5).offset(30) # Will return a maximum of 5 clients, starting with the 31st

# Grouping
Order.select("date(created_at) as ordered_date, sum(price) as total_price")
.group("date(created_at)") # Will give you a single order records for each date where there are orders
Order.select("date(created_at) as ordered_date, sum(price) as total_price")
.group("date(created_at").having("sum(price) > ?", 100) # Will return single order records for each day, but only those that are ordered more than $100 in a day

# Calculations
Client.count # Counts all the clients
Client.where(first_name: "John").count # Counts all the Johns
Client.average(:age)
Client.max(:age)
Client.min(:age)
Client.sum(:age) # Sum of all the records in the age field

# Overriding Conditions -- GO BACK TO

# Null Relation
Client.none # returns a chainable relation with no records (useful in scenarios where you need a chainable response to a method or scope that could return 0 results)

# Use pure SQL
Client.find_by_sql("SELECT * FROM clients
  INNER JOIN orders ON clients.id = orders.client_id
  ORDER clients.created_at desc")

# Explain
User.where(id: 1).joins(:posts).explain # Helps visualize what you are trying to do
