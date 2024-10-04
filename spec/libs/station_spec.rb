# frozen_string_literal: true

Dir['./libs/modules/*.rb'].each { |file| require file }
require_relative '../../libs/station'
require_relative '../../libs/trains/train'
require_relative '../../libs/trains/cargo_train'
require_relative '../../libs/trains/passenger_train'

RSpec.describe Station do
  let(:station) { described_class.new('First station') }
  let(:train) { Train.new('0001') }
  let(:cargo_train) { CargoTrain.new('0001') }
  let(:passenger_train) { PassengerTrain.new('0002') }

  context '#name' do
    it "has 'First station' name" do
      expect(station.name).to eq('First station')
    end
  end

  describe 'check trains' do
    context '#trains' do
      it 'empty trains' do
        expect(station.trains).to eq([])
      end

      describe 'move train' do
        context '#train_arrival' do
          it 'train arrival to station' do
            station.train_arrival(train)
            expect(station.trains).to eq([train])
          end

          it 'train departure from station' do
            station.train_departure(train)
            expect(station.trains).to eq([])
          end
        end
      end
    end
  end

  context '#train_types' do
    context 'empty trains' do
      it 'return notice' do
        expect { station.trains_type }.to raise_error(StandardError)
      end
    end

    context 'have trains' do
      it 'return trains type' do
        station.trains.push(*[cargo_train, passenger_train])
        expect(station.trains_type).to eq({ 'PassengerTrain' => 1, 'CargoTrain' => 1 })
      end
    end
  end
end

