class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(args)
    @chainring = args[:chainring] || 40
    @cog       = args[:cog] || 18
    @wheel     = args[:wheel]
  end
  
  def ratio
    chainring/cog.to_f
  end
  
  def gear_inches
    ratio * wheel.diameter
  end
  
end

class Wheel
  attr_reader :rim, :tire
  
  def initialize(rim, tire)
    @rim  = rim
    @tire = tire
  end
  
  def circumference
    diameter * Math::PI
  end
  
  def diameter
    rim + (tire * 2)
  end
  
end

wheel = Wheel.new(26, 1.5)

puts wheel.diameter
puts wheel.circumference

puts Gear.new(52, 11).ratio
puts Gear.new(52, 11, wheel).gear_inches


