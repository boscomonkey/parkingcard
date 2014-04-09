require 'parking_card'
require 'spec_helper'

describe ParkingCard do
  let(:parking) { ParkingCard.new }
  let(:page1) { File.read(File.join 'spec', 'fixtures', 'cards20.html') }
  let(:vendors) { parking.parse_page(page1) }
  let(:vend) { vendors.first }

  context '#parse_page' do
    it 'returns array of vendors' do
      expect(vendors.size).to eq(12)
    end

    it 'returns first vendor name as "33 Mart"' do
      expect(vend.name).to eq('33 Mart')
    end

    it 'returns first vendor street address as "1905 Clement Street"' do
      expect(vend.street_address).to eq('1905 Clement Street')
    end

    it 'returns first vendor locality as "San Francisco"' do
      expect(vend.locality).to eq('San Francisco')
    end

    it 'returns first vendor region as "CA"' do
      expect(vend.region).to eq('CA')
    end

    it 'returns first vendor postal code as "94121"' do
      expect(vend.postal_code).to eq('94121')
    end

    it 'returns first vendor map link as "94121"' do
      expected_url = 'http://maps.google.com?q=37.782020+-122.479753+%281905+Clement+Street%2C+San+Francisco%2C+CA%2C+94121%2C+us%29'
      expect(vend.map_link).to eq(expected_url)
    end
  end

  context '#parse_next_uri' do
    let(:next_uri) { parking.parse_next_uri(page1) }

    it 'returns uri of "next" pagination link' do
      expect(next_uri).to eq('/getting-around/transit/fares-passes/where-to-buy/20-parking-card?page=1')
    end
  end
end
