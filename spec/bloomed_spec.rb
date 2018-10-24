RSpec.describe Bloomed do
  it "has a version number" do
    expect(Bloomed::VERSION).not_to be nil
  end

  context "#filename" do
    subject { Bloomed::PW.new(top: 1E4, false_positive_probability: 0.00001) }
    it "does probability" do
      expect(File.basename(subject.filename)).to eq "pwned_top_10000_one_in_100000.msgpk"
    end
  end

  context "low precision" do
    subject { Bloomed::PW.new(top: 1E4, false_positive_probability: 0.01) }

    it "detects password123" do
      expect("password123").to be_pwned
    end

    it "does not detect password200" do
      expect("password200").not_to be_pwned
    end

    it "does not detect o9wreiour" do
      expect("o9wreiour").not_to be_pwned
    end
  end

  context "high precision" do
    subject { Bloomed::PW.new(top: 1E5, false_positive_probability: 0.001) }

    it "detects password123" do
      expect("password123").to be_pwned
    end

    it "detects password20" do
      expect("password20").to be_pwned
    end

    it "does not detect o9wreiour" do
      expect("o9wreiour").not_to be_pwned
    end
  end

  context "msgpack" do
    subject { Bloomed::PW.new(top: 1E5, false_positive_probability: 0.001) }

    it "serializes" do
      data = subject.to_msgpack
    end

    it "deserializes" do
      subject2 = Bloomed::PW.from_msgpack(subject.to_msgpack)
      expect(subject2.top).to eq subject.top
      expect(subject2.false_positive_probability).to eq subject.false_positive_probability
      expect(subject2.pwned?("password20")).to eq true
    end

    context "overriding the cache dir" do
      context "empty dir" do
        require "tempfile"
        subject { Bloomed::PW.new(top: 1E2, false_positive_probability: 0.00001, cache_dir: File.dirname(Tempfile.new)) }
        it("raises") {
          expect { subject }.to raise_error(Bloomed::MissingPasswordListError)
        }
      end

      context "non-empty dir" do
        it("loads") do
          require "tempfile"
          b = Bloomed::PW.new(top: 1E4, false_positive_probability: 0.01)
          dir = File.dirname(Tempfile.new)
          new_file = File.join(dir, File.basename(b.filename))
          FileUtils.cp(b.filename, new_file)
          b2 = Bloomed::PW.new(top: 1E4, false_positive_probability: 0.01, cache_dir: dir)
          expect(b2.filename).not_to eq b.filename
        end
      end
    end
  end
end
