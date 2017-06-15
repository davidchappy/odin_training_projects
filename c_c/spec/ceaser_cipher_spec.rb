require './ceaser_cipher.rb'

describe CeaserCipher do

  describe ".cipher" do
    
    it "accepts text only as its input" do
      expect(CeaserCipher.cipher(2,4)).to include("not valid")
    end

    it "returns a string" do
      expect(CeaserCipher.cipher("Text",2)).to be_a(String)
    end

    it "transposes input string chars by specified shift value" do
      expect(CeaserCipher.cipher("text",1)).to eq("ufyu")
    end

    it "preserves capitalization in input string" do
      expect(CeaserCipher.cipher("Text",1)).to eq("Ufyu")
    end

    it "wraps from z/Z to a/A and vice versa" do
      expect(CeaserCipher.cipher("Zoo",1)).to eq("App")
    end

    it "accepts a negative shift value" do
      expect(CeaserCipher.cipher("Text",-1)).to eq("Sdws")
    end

  end

end