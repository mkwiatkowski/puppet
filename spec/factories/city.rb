Factory.define :city do |c|
  c.name "Springfield"
  c.association :owner, :factory => :user
  c.budget 1000
  c.free_space 9
end
