# frozen_string_literal: true

require_relative '../../libs/station'
require_relative '../../libs/route'

RSpec.describe Station do
  let(:initial_station) { Station.new('Moscow') }
  let(:final_station) { Station.new('SpB') }
  let(:route) { Route.new(initial_station, final_station) }
  let(:intermediate_station_1) { Station.new('Tver') }
  let(:intermediate_station_2) { Station.new('Bologoe') }
  let(:free_station) { Station.new('Vladivistok') }

  describe 'stations' do
    context '#extreme stations' do
      it 'return initial and final stations' do
        expect(route.stations).to eq([initial_station, final_station])
      end
    end

    context '#add_intermediate_station' do
      it 'added some intermediate station' do
        route.add_intermediate_station(intermediate_station_1)

        expect(route.stations).to eq([initial_station, intermediate_station_1, final_station])
      end
    end

    context '#delete_intermediate_station' do
      before { route.add_intermediate_station(intermediate_station_1) }
      it 'delete some intermediate station' do
        route.delete_intermediate_station(intermediate_station_1)

        expect(route.stations).to eq([initial_station, final_station])
      end
    end

    context '#stations' do
      context 'without intermediate station' do
        it 'return initial and final stations' do
          expect(route.stations).to eq([initial_station, final_station])
        end
      end

      context 'with intermediate station' do
        before { route.add_intermediate_station(intermediate_station_1, intermediate_station_2) }

        it 'return all stations' do
          expect(route.stations).to eq([initial_station, intermediate_station_1, intermediate_station_2, final_station])
        end
      end
    end

    context '#use?' do
      it 'free station' do
        expect(route.use?(free_station)).to eq(false)
      end

      it 'use in extreme stations' do
        expect(route.use?(initial_station)).to eq(true)
      end

      it 'use in intermediate stations' do
        route.add_intermediate_station(intermediate_station_1)

        expect(route.use?(intermediate_station_1)).to eq(true)
      end
    end
  end
end
