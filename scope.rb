# Scopes allows you to specify commonly used queries which can be referenced as method calls

class Post < ActiveRecord::Base
  scope :published, -> { where(published: true) }
end

# Is like defining a class method self.published that does this, can now do Post.published


class Post < ActiveRecord::Base
  scope :published,               -> { where(published: true) }
  scope :published_and_commented, -> { published.where("comments_count > 0") }
end
# Scopes can be chainable


class Post < ActiveRecord::Base
  scope :created_before, ->(time) { where("created_at < ?", time) }
end

# Can pass in an argument to a scope (can do Post.created_before(Time.zone.now))

class Client < ActiveRecord::Base
  default_scope { where("removed_at IS NULL") }
end
# Set a default scope for future SQL queries

Client.unscoped.all # Removes scoping
