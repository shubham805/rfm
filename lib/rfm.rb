require 'fuzzy'
class RFM
	@@max=[500,500,500]
	@@weight=[1,1,1]
	def self.weight=(weight)
		@@weight=weight
	end

	def self.max=(max)
		@@max=max
	end

	attr_accessor :rfm

	def initialize()
		#@rfm={"recency"=>Fuzzy.new(r,@@max["recency"]), "frequency"=>Fuzzy.new(f,@@max["frequency"]), "monetory"=>Fuzzy.new(m,@@max["monetory"])}
		@rfm=Array.new(3)
	end

	def average
			i=0
			aw=0
			sum=0
			@@weight.each  do |w|  
				aw=aw + w*@rfm[i].linguistic.delta_inverse
				sum=sum+w
				i+=1
			end
			aw=aw/sum
			return Tuple.new(aw)
	end

	def set_rfm(rfm,value=0)
		t=Fuzzy.new(value,@@max[rfm])
		#puts t.linguistic.delta_inverse
		@rfm[rfm]=t	
	end

end