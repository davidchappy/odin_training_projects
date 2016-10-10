require './chess.rb'

describe GameIO do
    before(:each) do
      @input = StringIO.new("test info\n")
      @output = StringIO.new
      @input_received = GameIO.get_input(@input)
      GameIO.give_output("test message", "puts", @output)
    end
    it "should output a message for the user" do
      expect(@output.string).to eq("test message\n") 
    end
    it "should return the user's input" do
      expect(@input_received).to eq("test info") 
    end
end