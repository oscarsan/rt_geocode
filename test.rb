require 'geocoder'
require 'xmlsimple'

#filenames = ["TR Oulu 2017 Day 0 Prologi",
#  "TR Oulu 2017 Day 1",
#  "TR Oulu 2017 Day 2",
#  "TR Oulu 2017 Day 3",
#  "TR Oulu 2017 Day 4"]

        filenames = ["TR Oulu 2017 Day 4"]

filenames.each do |filename|
  puts "starting queryinf of #{filename}"
  hash = XmlSimple.xml_in("#{filename}.gpx")
  some = []
  hash["trk"][0]["trkseg"][0]["trkpt"].each do |x|
    street = Geocoder.address("#{x["lat"]}, #{x["lon"]}")
    some.push street if (street.to_s != '' && !street.include?("Google"))
  end

  puts "Queryinf finnished for #{filename} with #{some.size} queries"

  File.open("#{filename}.txt", 'w') do  |file|
    some.each_with_index do  |x, index|
      begin
        x.slice!(x.scan(/(\s\d*),/)[0][0])
      rescue
        puts
      end
      if index == 0
        file.puts x
      else
        file.puts x if x.split[0] != some[index-1].split[0]
      end
    end
  end

  puts "#{filename} written"
end
