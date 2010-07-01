# Commands subsystem that allows to keep game rules separte from the application
# code.
# Define rules by subclassing Command and calling define_command.
# Invoke rules through Command.handle!.
class Command
  attr_reader :name, :message, :label

  @@known_commands = {}

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

    def apply(method, params)
      send(method, *params.values_at(*@args))
    end

    def preconditions
      @preconditions.map do |pre|
        if pre.is_a?(Symbol) or pre.is_a?(String)
          pre
        else
          raise ArgumentError.new("precondition should be a symbol")
        end
      end
    end
end
