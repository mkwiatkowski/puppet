require 'spec_helper'

describe Command do
  def remove_command(name)
    Command.class_eval("@@known_commands.delete('#{name}')")
  end

  describe "after defining new_command" do
    before do
      @command = Command.define_command("new_command", {})
    end
    after { remove_command('new_command') }

    it "should be able to handle it" do
      Command.handle!("new_command", {}).should == @command
    end

    it "should list it in all" do
      Command.all.should include(@command)
    end
  end

  describe "after defining command with symbol precondition" do
    before do
      $called = false
      class CommandWithPre < Command
        def condition
          $called = true
          nil
        end
        define_command("with_pre", :pre => [:condition])
      end
    end
    after { remove_command('with_pre') }

    it "should accept symbols as preconditions, interpret them as method names and call them" do
      lambda {
        CommandWithPre.handle!("with_pre", {})
      }.should change { $called }.from(false).to(true)
    end
  end

  describe "after defining command with Proc precondition" do
    before do
      $called = false
      class CommandWithProcPre < Command
        define_command("with_proc_pre", :pre => [lambda{$called = true; nil}])
      end
    end
    after { remove_command('with_proc_pre') }

    it "should accept symbols as preconditions, interpret them as method names and call them" do
      lambda {
        CommandWithPre.handle!("with_proc_pre", {})
      }.should change { $called }.from(false).to(true)
    end
  end

  describe "after defining command with failing precondition" do
    before do
      class CommandWithFailingPre < Command
        def never
          "error"
        end
        define_command("with_failing_pre", :pre => [:never])
      end
    end
    after { remove_command('with_failing_pre') }

    it "should report them during handle! as UserActionErrors" do
      lambda {
        CommandWithFailingPre.handle!("with_failing_pre", {})
      }.should raise_error(UserActionError, "error")
    end
  end
end
