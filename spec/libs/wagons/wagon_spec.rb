# frozen_string_literal: true

require_relative '../../../libs/wagons/wagon'

RSpec.describe Wagon do
  let(:wagon) { described_class.new(0o001) }

  context 'instance variable' do
    context '#number' do
      it 'return wagon number' do
        expect(wagon.number).to eq(0o001)
      end
    end
  end
end
