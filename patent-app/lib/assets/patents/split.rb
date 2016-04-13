pat63_99 = Array.new
File.open("pat63_99.csv", "r") do |pat63_99_csv|
	pat63_99 = pat63_99_csv.readlines()
end

def getSubCat(pat)
	count = 0
	i = 0
	for i in 0..pat.length-1
		count = count+1 if pat[i]==','
		break if count==11
	end
	return pat[i+1..i+2].to_i
end

files = Array.new
for i in 11..69
	files[i] = File.new("pat#{i}.csv", "a")
end

for i in 1..pat63_99.length-1
	pat = pat63_99[i]
	files[getSubCat(pat)].puts(pat)
end