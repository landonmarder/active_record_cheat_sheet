# Active Record lets you use the names of associations defined on the model as a shortcut
# for specifying JOIN clauses when using the joins method

class Category < ActiveRecord::Base
  has_many :posts,
    inverse_of: categories
end

class Post < ActiveRecord::Base
  belongs_to :category
  has_many :comments,
    inverse_of: posts

  has_many :tags,
    inverse_of: posts
end

class Comment < ActiveRecord::Base
  belongs_to :post
  has_one :guest,
    inverse_of: comments
end

class Guest < ActiveRecord::Base
  belongs_to :comment,
    inverse_of: :guests
end

class Tag < ActiveRecord::Base
  belongs_to :post,
    inverse_of: :tags
end



Category.joins(:posts) # Joins the Category and Posts (returns a Category object for all categories with posts)

Posts.joins(:category, :comments) # MULTIPLE ASSOCIATIONS: Return all posts that have a category and at least one comment (posts with multiple comments will come up multiple times)

Posts.joins(comments: :guest) # NESTED ASSOCIATIONS: Return all posts that have a comment made by a guest (guest belongs to comments, comments belongs to post)



