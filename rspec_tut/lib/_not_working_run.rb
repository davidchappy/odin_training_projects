class Run

  attr_accessor :duration, :distance, :timestamp

  def initialize(run={})
    @duration = run[:duration]
    @distance = run[:distance]
    @timestamp = run[:timestamp]
    @@runs ||= {}
  end

  def self.runs
    @@runs
  end

  def self.runs=runs
    @@runs = runs
  end

  def self.log(run)
    @@runs << run
  end

  def self.count(opts=nil)
    if opts.nil?
      self.runs.length
    else
      self.runs.select{|k,v| k = opts}
    end
  end

end

class RunningWeek

  def self.count(opts=nil)
    Run.count(opts)
  end


end