require 'oystercard'

describe Oystercard do
  let(:entry_station) {double :entry_station}
  let(:exit_station) {double :exit_station}

  # it { is_expected.to respond_to :top_up }

  it "has a balance of zero" do
    expect(subject.balance).to eq(0)
  end

  it 'increases the balance' do
    expect { subject.top_up(1) }.to change {subject.balance }.from(0).to(subject.balance+1)
  end


  it 'raises error when the limit is exceeded' do
    expect { subject.top_up(Oystercard::LIMIT + 1) }.to raise_error ("top up limit of #{Oystercard::LIMIT} reached")
  end

  # it "deducts fare amount" do
  #   subject.top_up(Oystercard::LIMIT)
  #   expect { subject.deduct(1) }.to change { subject.balance }.from(Oystercard::LIMIT).to(Oystercard::LIMIT - 1)
  # end

  # it { is_expected.to respond_to :touch_in }
  # it { is_expected.to respond_to :touch_out }

  it 'check new oyster card is not in_journey' do
    expect(subject.in_journey?).to eq false
  end

  it "raises exception on touch in if balance is below minimum" do
    expect {subject.touch_in(:entry_station)}.to raise_error ("insufficient funds")
  end

  # it 'it stores #touch_in station' do
  #   subject.top_up(20)
  #   subject.touch_in(:entry_station)
  #   expect(subject.trip_history).to include(:entry_station)
  # end

  # it 'on #touch_out entry_station is set to nil' do
  #   subject.top_up(20)
  #   subject.touch_in(:entry_station)
  #   expect(subject.touch_out(:exit_station)).to eq nil
  # end

  it 'deducts fare amount on touch out' do
    subject.top_up(Oystercard::LIMIT)
    expect{ subject.touch_out(:exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM)
  end

  it 'oystercard initial trip history is empty' do
    expect(subject.trip_history).to be_empty
  end

  it 'stores entry station to trip history during touch in' do
    subject.top_up(Oystercard::LIMIT)
    subject.touch_in(:entry_station)
    expect(subject.trip_history).to include(:entry_station)
  end

  it 'stores exit station to trip history during touch out' do
    subject.top_up(Oystercard::LIMIT)
    subject.touch_in(:entry_station)
    expect(subject.touch_out(:exit_station)).to eq (subject.trip_history[:entry_station])
  end
end
