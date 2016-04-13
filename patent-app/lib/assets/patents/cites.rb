cite = Hash.new([])
IO.foreach("cite75_99.csv"){|cit|
	a = cit.to_i
	b = cit[8..100].to_i
	cite[a] = cite[a]+[b]
}
puts "loaded"

for i in 11..69
	pats = Array.new
	File.open("pat#{i}.csv", "r") do |patFile|
		pats = patFile.readlines()
	end
	citeFile = File.new("cite#{i}.txt", "a")
	for j in 0..pats.size-1
		code = pats[j].to_i
		citeFile.puts("#{code}")
		for k in 0..cite[code].size-1
			citeFile.print("#{cite[code][k]} ")
		end
		citeFile.puts()
	end
	citeFile.close
end
