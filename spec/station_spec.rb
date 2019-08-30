require 'station'

describe Station do
  subject {described_class.new(name: 'Euston', zone: 1)}

  it 'knows name' do
    expect(subject.name).to eq('Euston')
  end

  it 'knows zone' do
    expect(subject.zone).to eq(1)
  end

  end
