class Limer::Timer
  getter name : String
  getter start_time : Time
  getter finish_time : Time?
  @path : String

  START_LINE  = 0
  FINISH_LINE = 1

  class MissingFile < Exception
  end

  class AlreadyStarted < Exception
  end

  class AlreadyStopped < Exception
  end

  def initialize(name : String)
    @name = name
    @path = ENV["HOME"] + "/.config/limer/" + @name
    @start_time = Time.now

    begin
      unless File.exists?(@path)
        raise MissingFile.new
      end

      contents = File.read(@path)

      if start_content = contents.lines[START_LINE]?
        @start_time = Time.parse(start_content, "%s")
      end

      if finish_content = contents.lines[FINISH_LINE]?
        @finish_time = Time.parse(finish_content, "%s")
      end
    rescue MissingFile
    end
  end

  def duration
    finish_time
      .try { |f| return f - start_time }
      .fail { return Time.now - start_time }
  end

  def start
    if File.exists?(@path) && File.read(@path).size > 0
      raise AlreadyStarted.new("#{@name} already started")
    end

    start!
  end

  def stop
    unless File.exists?(@path)
      raise MissingFile.new("#{@name} doesn't exist")
    end

    finish_time.try { raise AlreadyStopped.new("#{@name} is already stopped") }

    @finish_time = Time.now

    finish_time.try do |finish_time|
      File.open(@path, mode: "a") do |f|
        f.puts(finish_time.to_s("%s"))
      end

      puts "Stopped timer #{@name} at #{finish_time}"
    end
  end

  def start!
    File.open(@path, mode: "w") do |f|
      f.puts(start_time.to_s("%s"))
    end

    puts "Started timer #{@name} at #{start_time}"
  end

  def reset
    puts "Resetting timer #{@name}"
    start!
  end
end
