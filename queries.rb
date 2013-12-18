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

