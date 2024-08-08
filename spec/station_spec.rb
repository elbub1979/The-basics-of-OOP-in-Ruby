require_relative '../libs/station.rb'
require_relative '../libs/trains/train'
require_relative '../libs/trains/cargo_train'
require_relative '../libs/trains/passenger_train'

RSpec.describe Station do
  before { @station = Station.new('First station') }

  describe 'check class' do
    context 'check name' do
      it 'correct name' do
        expect(@station.name).to eq('First station')
      end

      it 'wrong name' do
        expect(@station.name).not_to eq('')
      end
    end
  end

  describe 'check trains' do
    context 'empty trains' do
      it 'empty trains' do
        expect(@station.trains).to eq([])
      end

      context 'move train' do
        before do
          @train = Train.new('0001')
        end

        it 'trains arrival' do
          @station.train_arrival(@train)
          expect(@station.trains).to eq([@train])
        end

        it 'train departure' do
          @station.train_departure(@train)
          expect(@station.trains).to eq([])
        end
      end
    end
  end
  describe 'train_types' do
    context 'empty trains' do
      it 'return notice' do
        expect(@station.trains_type).to eq('На станции нет поездов')
      end

      context 'have trains' do
        before do
          @cargo_train = CargoTrain.new('0001')
          @passenger_train = PassengerTrain.new('0002')
        end

        it 'return trains type' do
          @station.trains.push(*[@cargo_train, @passenger_train])
          expect(@station.trains_type).to eq({ 'PassengerTrain' => 1, 'CargoTrain' => 1 })
        end
      end
    end
  end
end

