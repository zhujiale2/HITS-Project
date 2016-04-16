class HitsController < ApplicationController
  def ranking
  	subCat = params[:subCat]
  	mat = makeMatrix(rawCiteInfo)
  end

private

	def makeMatrix(rawCiteInfo) # turn citeXX.txt into Hash as hits method's input

	end

	def hits(mat)  
	# mat is a Hash: (Interger)patent ID number => (Array)cited ID numbers
	# res is a Hash: (Integer)patent ID => (Array)hub value & authority value
		res = Hash.new
	# initialize each patent's hub & authority value as random float between 0~1
		mat.each { |citingID,_|
			res[citingID]{:hub => rand(), :auth => rand()}
		}

	# iteration peocedure
		for iteration in 1..100
			tmp = res
			biggestHub = 0
			biggestAuth = 0
			mat.each { |citingID,citedIDArray| 
				res[citingID][:hub] = 0
				res[citingID][:auth] = 0
				for citedIDArray.each { |citedID|
					res[citingID][:hub] = res[citingID][:hub]+tmp[citedID][:auth]
					res[citedID][:auth] = res[citedID][:auth]+tmp[citingID][:hub]
					biggestAuth = res[citingID][:auth] if res[citingID][:auth]>biggestAuth
				}
				biggestHub = res[citingID][:hub] if res[citingID][:hub]>biggestHub
			}
			# normalization
			mat.each { |citingID,_| 
				res[citingID][:hub] = res[citingID][:hub]/biggestHub
				res[citingID][:auth] = res[citingID][:auth]/biggestAuth
			}
		end # end of iteration procedure

		return res
	end # end of hits(mat)

end
