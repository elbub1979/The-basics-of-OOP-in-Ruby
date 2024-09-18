require_relative '../../../libs/station'
require_relative '../../../libs/route'
require_relative '../../../libs/trains/train'
require_relative '../../../libs/wagons/wagon'

RSpec.describe Train do
  let(:train) { described_class.new('001') }
  let(:wagon) { Wagon.new('0001') }
  let(:initial_station) { Station.new('Msk') }
  let(:final_station) { Station.new('SpB') }
  let(:intermediate_station_1) { Station.new('Tver') }
  let(:intermediate_station_2) { Station.new('Bologoe') }
  let(:route) { Route.new(initial_station, final_station) }

  describe 'after initialize' do
    context '@number' do
      it 'return train number' do
        expect(train.number).to eq('001')
      end
    end

    context '@wagons' do
      it 'return empty wagons' do
        expect(train.wagons).to eq([])
      end
    end

    context '@speed' do
      it 'train standing' do
        expect(train.speed).to eq(0)
      end
    end
  end

  describe 'wagons method' do
    context '#add_wagon' do
      it 'has add wagon' do
        train.add_wagon(wagon)

        expect(train.wagons).to eq([wagon])
      end
    end

    context '#delete_wagon' do
      before { train.add_wagon(wagon) }

      it 'has delete wagon' do
        train.delete_wagon(wagon)

        expect(train.wagons).to eq([])
      end
    end
  end

  context '#assign_route' do
    before { route.add_intermediate_station(intermediate_station_1, intermediate_station_2) }

    it 'assign route to train' do
      train.assign_route(route)

      expect(train.route).to eq(route)
    end
  end

  describe 'move train' do
    before do
      route.add_intermediate_station(intermediate_station_1, intermediate_station_2)
      train.assign_route(route)
    end
    
    context '#move_next_station' do
      it "train move 'Tver' station" do
        train.move_next_station

        expect(train.current_station).to eq(intermediate_station_1)
      end

      describe 'final station' do

        context 'arrival at final station' do
          it 'train on final station' do
            3.times { train.move_next_station }
            puts train.current_station_index
            expect(train.current_station).to eq(final_station)
          end

          it 'return standard error exception' do
            expect(train.move_next_station).to raise_error(StandardError)


          end
        end

      end

    end

  end
end
