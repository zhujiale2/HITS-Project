class HitsController < ApplicationController

	ITERTIMES = 5

  def ranking
  	# read data
  	subCat = params[:subCat]
  	patFile = File.new("lib/assets/patents/cite#{subCat}.txt", "r")
  	rawCiteInfo = patFile.readlines()

  	# convert raw data
  	mat = makeMatrix(rawCiteInfo)

  	# processing
  	ratings = hits(mat)

  	# ranking & filtering
  	topN = extract(ratings, params[:n])

  	render json: {authRank: topN[:authRank], hubRank: topN[:hubRank]}
  end

private

	def makeMatrix (rawCiteInfo) # turn string Array into Hash as hits method's input
		mat = Hash.new
		for i in 0..rawCiteInfo.size-1
			if i%2==0
				citingID = rawCiteInfo[i].to_i
			else
				citedIDArray = rawCiteInfo[i].split
				for j in 0..citedIDArray.size-1
					citedIDArray[j] = citedIDArray[j].to_i
				end
				mat[citingID] = citedIDArray
			end
		end
		return mat
	end

	def hits (mat) # HITS algorithm
	# mat is a Hash: (Interger)patent ID number => (Array)cited ID numbers
	# ratings is a Hash: (Integer)patent ID => (Array)hub value & authority value
	ratings = Hash.new
	# idList is all involved patent ID
		idList = Hash.new
		mat.each { |citingID,citedIDArray|
			idList[citingID] = 1
			if !citedIDArray.nil?
					citedIDArray.each { |citedID|	idList[citedID] = 1}
			end
		}
	
	# initialize each patent's hub & authority value as random float between 0~1
		idList.each { |patID,_|	ratings[patID] = {hub: rand(), auth: rand()} }
		
	# iteration peocedure
		for iteration in 1..ITERTIMES

			tmp = Marshal.load(Marshal.dump(ratings))
			biggestHub = 0
			biggestAuth = 0
			
			# initial ratings as zero
			idList.each { |patID,_|	ratings[patID] = {hub: 0, auth: 0} }
			
			# calculate hub & authority
			mat.each { |citingID,citedIDArray|
				if !citedIDArray.nil?
					citedIDArray.each { |citedID|
						ratings[citingID][:hub] += tmp[citedID][:auth] if !tmp[citedID].nil?
						ratings[citedID][:auth] += tmp[citingID][:hub] if !tmp[citingID].nil?
					}
				end
			}
#=begin
			# normalization
			idList.each { |patID,_|
				biggestAuth = ratings[patID][:auth] if ratings[patID][:auth]>biggestAuth
				biggestHub = ratings[patID][:hub] if ratings[patID][:hub]>biggestHub
			}
			idList.each { |patID,_|	
				ratings[patID][:hub] /= biggestHub if biggestHub!=0
				ratings[patID][:auth] /= biggestAuth if biggestAuth!=0
			}
#=end
		end # end of iteration procedure

		return ratings
	end # end of hits(mat)

	def extract (ratings, n) # ranking by authority & hub and filter
		topAuthArray = []
		topHubArray  = []
		ratings.each { |patID, hash|
			topAuthArray.push([patID,hash[:auth]])
			topHubArray.push([patID,hash[:hub]])
		}
		puts topAuthArray[0]
		puts topHubArray[0]
		topAuthArray.sort_by!{|patID,auth| -auth}
		topHubArray.sort_by!{|patID,hub| -hub}
		topN = Hash.new
		topN[:authRank] = topAuthArray[0..9]
		topN[:hubRank] = topHubArray[0..9]
		return topN
	end

end
