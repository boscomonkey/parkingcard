require 'nokogiri'

class ParkingCard
  class Vendor < Struct.new(
                            :name,
                            :street_address,
                            :locality,
                            :region,
                            :postal_code,
                            :map_link,
                            )
  end

  # mechanize alternative: agent.page.links_with(:text => /^next/i)
  def parse_next_uri(str)
    doc = Nokogiri::HTML(str)

    candidate = doc.css('.pagination').css('.next').css('a')
    candidate.size == 1 && candidate[0].text.strip =~ /^next/i ?
        candidate[0]['href'] :
        nil
  end

  # returns array of Vendors given HTML of parkingcard page
  def parse_page(str)
    parse_page_doc Nokogiri::HTML(str)
  end

  # returns array of Vendors given nokogiri doc of parkingcard page
  def parse_page_doc(doc)
    rows = doc.css('.views-row')
    rows.inject([]) do |memo, vendor|
      name = vendor.css('.views-field-title .field-content a')

      adr = vendor.css('.views-field-address .location .adr')
      street = adr.css('.street-address')
      locality = adr.css('.locality')
      region = adr.css('.region')
      postal_code = adr.css('.postal-code')

      map = vendor.css('.map-link').css('.location').css('a')[0]
      map_link = ('Google Maps' == map.text.strip) ? map['href'] : nil

      memo << Vendor.new(
                         name.text.strip,
                         street.text.strip,
                         locality.text,
                         region.text,
                         postal_code.text,
                         map_link,
                         )
    end
  end
end
