class Limer::Cli
  @command : Limer::Command = Limer::Command::Help
  @name : String = ""

  def parse_command
    if command = ARGV[0]
      @command = Limer::Command.parse(command)
    end
  rescue IndexError
  rescue ArgumentError
  end

  def parse_name
    if name = ARGV[1]
      @name = name
    end
  rescue IndexError
  end

  def run
    if @command == Limer::Command::Help
      puts USAGE
      return
    end

    if @name.blank? && @command != Limer::Command::List
      puts USAGE
      return
    end

    path = ENV["HOME"] + "/.config/limer"
    unless Dir.exists?(path)
      Dir.mkdir_p(path)
    end

    if @command == Limer::Command::List
      Dir.glob(path + "/*").each do |timer_name|
        timer_name = File.basename(timer_name)
        t = Limer::Timer.new(timer_name)
        puts(sprintf("%-20s %-20s", timer_name, t.duration))
      end
    else
      timer = Limer::Timer.new(@name)

      case @command
      when .start?
        timer.start
      when .stop?
        timer.stop
        puts timer.duration
      when .reset?
        timer.reset
      when .view?
        puts timer.duration
      when .watch?
        puts "not implemented yet"
      end
    end
  rescue e : Limer::Timer::AlreadyStopped | Limer::Timer::AlreadyStarted
    puts e.message
  end
end
