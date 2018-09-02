RSpec.describe Bloomed do
  it 'has a version number' do
    expect(Bloomed::VERSION).not_to be nil
  end

  context 'low precision' do
    subject { Bloomed::PW.new(top: 1E4, false_positive_probability: 0.01) }

    it 'detects password123' do
      expect('password123').to be_pwned
    end

    it 'does not detect password20' do
      expect('password20').not_to be_pwned
    end

    it 'does not detect o9wreiour' do
      expect('o9wreiour').not_to be_pwned
    end
  end

  context 'high precision' do
    subject { Bloomed::PW.new(top: 1E5, false_positive_probability: 0.001) }

    it 'detects password123' do
      expect('password123').to be_pwned
    end

    it 'detects password20' do
      expect('password20').to be_pwned
    end

    it 'does not detect o9wreiour' do
      expect('o9wreiour').not_to be_pwned
    end
  end
end
