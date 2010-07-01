Factory.define :user do |u|
  u.sequence(:email) {|n| "homer.simpson#{n}@example.com"}
  u.password "D'oh?!"
  u.password_confirmation "D'oh?!"
end
