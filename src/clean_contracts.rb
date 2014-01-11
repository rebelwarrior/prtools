require 'nokogiri'
data = ""
rows = 0
Dir.glob('/Users/rr/data/contratos/*/Contratos.xls') do |path|
	puts "Processing #{path}."
	file = File.open(path)
	doc = Nokogiri::HTML(file)
	tr = doc.css("tr")
	if rows == 0
		head = tr.first.css("td").map do |item| item.text.chomp.strip end.join("\t") 
		data << head + "\n"
	end
	tr[1..tr.size].each_with_index do |row, index|
		contract = row.css('td').first
		txt = row.css('td').map do |item| item.text.chomp.strip end.join("\t")
		unless txt.empty? 
			data << txt + "\n"
			rows = rows + 1
		else
			puts "Empty row."
		end
	end
	puts "Processed #{rows} rows so far."
	w = File.open(path + ".clean.tsv", "w")
	w.write(data)
	data = ""
	w.close
end