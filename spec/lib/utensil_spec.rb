require 'spec_helper'

describe Utensil do
  describe "#render_utensil" do
    context :khan do
      let(:result) { Utensil.render_utensil type: "Khan Academy Video", videoId: 100 }
      it { result.should include("https://www.khanacademy.org/embed_video?v=100") }
    end
    context :picture do
      let(:result) { Utensil.render_utensil type: "Upload a Picture", picture_url: "image.jpg" }
      it { result.should include("src=\"image.jpg") }
    end
    context :equation do
      let(:result) { Utensil.render_utensil type: "Equation Helper", equation: "4x4=12" }
      it {result.should include("https://chart.googleapis.com/chart?cht=tx&chl=#{URI::encode('4x4=12')}") }
    end
    context :video do
      let(:result) { Utensil.render_utensil type: "Upload a Video", video_url: "video.mpg" }
      it { result.should include("<video src=\"video.mpg\" width=\"640\"") }
    end
    context :educreations do
      let(:result) { Utensil.render_utensil type: "Educreations Video", video_id: 10101}
      it { result.should include('<iframe width="640" height="360"') }
      it { result.should include('src="http://www.educreations.com/lesson/embed/10101"') }
    end
  end

  describe "#render" do
    it "parses <utensils>" do
      json = <<-eos
      {
        "type": "Upload a Picture",
        "picture_url": "https://www.filepicker.io/api/file/iYUQRuxcQcCJSiY56LEK"
      }
      eos
      html = "<utensil>#{json}</utensil>"
      Utensil.render(html).should include("https://www.filepicker.io/api/file/iYUQRuxcQcCJSiY56LEK")
    end
  end
end