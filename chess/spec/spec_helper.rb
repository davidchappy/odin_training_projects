require './chess.rb'

describe "Chess Game" do

  before(:all) do
    allow(GameIO).to receive(:give_output).with("Please include 'start' like this: 'ruby chess.rb start'", "puts", StringIO.new).and_return(nil)
  end
  
end


