require './connect_four.rb'

describe Player do

  let(:game) { Game.new("David", "Kristin") }
  let(:player) { Player.new("Bob") }

  context "when initialized" do
    it "has a name" do
      expect(player.name).to eq("Bob")
    end

    it "has color set to nil" do
      expect(player.color).to be_nil
    end
  end

  describe "#choose" do

    let(:choice) { player.choose }

    it "requests user input" do 
      allow(GameIO).to receive(:give_output).with("Where will you place your token? (a - g): ", print).and_return("")
      allow(GameIO).to receive(:get_input).and_return("a")
      expect(choice).to_not be_nil
      expect(choice).to be_a(String)
    end

  end

end