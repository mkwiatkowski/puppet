# We have to preload all command classes, so that all defined commands are
# available right away.
Dir[Rails.root.join('app', 'rules', '*.rb')].each {|f| require f}
