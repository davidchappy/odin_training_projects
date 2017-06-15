class StringCalculator

  def self.add(input)
    if input.empty?
      0
    else
      numbers = input.split(",").map { |n| n.to_i }
      numbers.inject { |sum,num| sum + num }
    end
  end

end