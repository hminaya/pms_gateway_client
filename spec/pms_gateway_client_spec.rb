require 'pms_gateway_client'

describe PmsGatewayClient do
  URL = "https://localhost:9393"
  subject {PmsGatewayClient.new(URL)}

  it "should set url" do
    expect(subject.gateway_url).to  equal URL
  end

  describe "#inquiry" do
    it "calls curl_get with the right values" do
      room_number = "412"
      pms_number = "PMS123"
      port = 4000
      subject.should_receive(:curl_get).with( "#{URL}/inquiry",
                                              room_number: room_number,
                                              pms_number:  pms_number,
                                              port:        port
                                              )
      subject.inquiry( room_number, pms_number, port)

    end
  end

  context "curl calls" do
    let(:stub_curl_easy) { Curl::Easy.new }
    let(:verb_url) {URL + "/inquiry"}
    let(:params) { { param1: 1, param: "2"} }
    let(:body_str) {"This is the body"}

    before :each do
      stub_curl_easy.stub(:status) {200}
      stub_curl_easy.stub(:perform) {true}
      stub_curl_easy.stub(:body_str) { body_str}

      Curl::Easy.should_receive(:new).and_return stub_curl_easy
    end

    context "#curl_get results setting" do # ths code refactored into #set_results

      before :each do
        subject.curl_get(verb_url, params)
      end

      it "sets status" do
        expect(subject.status).to eq stub_curl_easy.status
      end

      it "sets called url" do
        expect(subject.called_url).to eq "#{verb_url}?#{subject.params_as_url(params)}"
      end

      it "sets body_str" do
        expect(subject.body_str).to eq body_str
      end

    end

    context "#curl_post" do

      it "sets results" do

        stub_curl_easy.stub(:http_post)
        subject.should_receive(:set_results).with(stub_curl_easy)
        subject.curl_post(verb_url, params)
      end

      it "makes Curl::PostFields from the params" do
        fields = params.map {|key, value| Curl::PostField.content(key, value)}
        stub_curl_easy.should_receive(:http_post) do |parameter_fields|
          parameter_fields.each_with_index { |field, i|
            expect(field.name).to eq fields[i].name
            expect(field.content).to eq fields[i].content
          }

        end
        subject.curl_post(verb_url, params)
      end

    end
  end

  context "#params_as_url" do
    it "converts a single entry" do
      expect(subject.params_as_url({ foo: :bar})).to eq "foo=bar"
    end

    it "joins multiple entries with &" do
      expect(subject.params_as_url({ foo: :bar, fu: :fubar})).to eq "foo=bar&fu=fubar"
    end

    it "converts space" do
      expect(subject.params_as_url({ foo: "foo bar"})).to eq "foo=foo+bar"
    end

    it "handles numbers w/o wrapping in quotes" do
      expect(subject.params_as_url({ foo: 2001})).to eq "foo=2001"
    end

  end
end
