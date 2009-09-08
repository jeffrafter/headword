Factory.sequence :username do |n|
  "user#{n}"
end

# We need a stub if none exists
unless Factory.factories.include?(:user)
  Factory.define :user do |user|
  end
end

Factory.define :user_with_username, :parent => :user do |user|
  user.username { Factory.next :username }
end  