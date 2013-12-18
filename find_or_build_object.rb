# You want to find a record or create it if it does not exist

Client.find_or_create_by(first_name: 'John')
# You want to find a client by John or if there is none, create one
# Returns the record

Client.find_or_initialize_by(first_name: 'John')
# Works just like find_or_create_by, but it will call new instead of create
# New model instance will be created in memory, but not saved to the database
# Would still need to do .save to save the client
