Factory.define :city do |c|
  c.name "Springfield"
  c.association :owner, :factory => :user
  c.free_space 9
end
