require './chess.rb'

describe Game do

  let(:game) { Game.new }

  before(:each) do
    allow(game).to receive(:puts)
    allow(game).to receive(:gets)
  end

  

end