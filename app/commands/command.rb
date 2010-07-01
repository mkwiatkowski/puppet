# Commands subsystem that allows to keep game rules separte from the application
# code.
# Define new commands by subclassing Command and calling define_command.
# Invoke those commands through Command.handle!.
class Command
  attr_reader :name, :message, :label

  @@known_commands = {}

  # Define a new user command with the given +name+.
  # Recognizable options:
  #   :context: List of parameters that command and each precondition takes.
  #     Client code is responsible for passing a proper set of parameters
  #     to handle!
  #   :pre: List of preconditions. Precondition may either be a method defined
  #     on the Command subclass or a Proc. A precondition should return nil
  #     if it is true or an error message (String) in other cases.
  #   :label: Description of the command that will be visible in the user interface.
  #   :message: Message to be shown to the user after a successful execution of the command.
  #   :command: Name of the method to be executed if all preconditions are true.
  def self.define_command(name, options)
    @@known_commands[name] = new(name, options)
  end

  # Tries to recognize and invoke a command with a given +name+, checking
  # its all preconditions first.
  # Eiather returns a Command instance or raises UserActionError.
  def self.handle!(name, params)
    returning(self.get(name)) { |command| command.handle!(params) }
  end

  def self.all
    @@known_commands.values.sort_by(&:name)
  end

  def initialize(name, options)
    @name = name
    @args = options[:context] || []
    @preconditions = options[:pre] || []
    @label = options[:label]
    @message = options[:message]
    @command = options[:command]
  end

  # Returns true if the command can be executed (i.e. all preconditions are true).
  def available?(params)
    unavailability_reasons(params).empty?
  end

  def unavailability_reasons(params)
    preconditions.map do |pre|
      apply(pre, params)
    end.compact
  end

  def handle!(params)
    check_preconditions!(params)
    execute!(params)
  end

  private
    # Method useful for making predicates on the fly.
    def self.define_method_once(name, &block)
      send(:define_method, name, &block) unless method_defined?(name)
    end

    def self.get(name)
      @@known_commands[name] or raise UserActionError.new("Unknown action")
    end

    def check_preconditions!(params)
      for pre in preconditions
        val = apply(pre, params)
        raise UserActionError.new(val) unless val.nil?
      end
    end

    def execute!(params)
      apply(@command, params)
    end

    # Apply a precondition to given params. A precondition can be either
    # a method name or a proc.
    def apply(pre, params)
      if pre.is_a?(Proc)
        pre.call(*params.values_at(*@args))
      else
        send(pre, *params.values_at(*@args))
      end
    end

    def preconditions
      @preconditions.map do |pre|
        if pre.is_a?(Symbol) or pre.is_a?(String) or pre.is_a?(Proc)
          pre
        else
          raise ArgumentError.new("precondition should be a symbol, string or a proc")
        end
      end
    end
end
