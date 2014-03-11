require 'spec_helper'

describe MicropostsHelper do

  describe " parse id reply from content " do
    it " should eq" do
      content = "@1-hieu-dang content"
      expect(get_reply_id_from(content)).to eq 1

      content = "@20-hieu-dang content"
      expect(get_reply_id_from(content)).to eq 20

      content = "@1-hieu-dang @content"
      expect(get_reply_id_from(content)).to eq 1

      content = "@10-hieu-dang @content"
      expect(get_reply_id_from(content)).to eq 10

      content = "10-hieu-dang @content"
      expect(get_reply_id_from(content)).to eq nil

      content = "#10-hieu-dang @content"
      expect(get_reply_id_from(content)).to eq nil
    end
  end
end