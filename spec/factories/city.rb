Factory.define :city do |c|
  c.name "Springfield"
  c.association :owner, :factory => :user
end
