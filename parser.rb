require 'nokogiri'
require_relative './medium.rb'

class Parser
    def media_list media_html
        doc = Nokogiri::HTML(media_html)
        media_list = []
        doc.xpath("//form[@name='medkl']/table/tr").each do |row|
            media_list.push(
            Medium.new({
                :id => row.elements[4].text.strip,
                :date => row.elements[3].text.strip,
                :renewal => row.elements[6].text.strip,
                :title => row.elements[8].text.strip
            })) if row.elements.count > 8
        end
        media_list
    end
end
