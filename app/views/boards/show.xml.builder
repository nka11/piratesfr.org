xml.instruct!
xml << "<!DOCTYPE board SYSTEM \"tp-0.1.dtd\">\n"
xml.board(:site => "http://piratesfr.org/") do
  @boards.each do |board|
    xml.post(:time => board.created_at.to_s(:timestamp), :id => board.id) do
      xml.info board.user_agent
      xml.message board.message
      xml.login board.user_name
    end
  end
end
