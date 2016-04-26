require "tuple"
class Fuzzy
	@@range
	attr_accessor :linguistic

	def initialize(value=0,max=1)
		if defined?(@@range) 
			@linguistic=Tuple.new(normalize(value, max))
			#normalize(value,max)
		else
			abort("SET RANGE/MAX FOR THE FUZZY SET")
		end
	end

	def normalize(value=0,max=1)
		if defined?(@@range)
			 norm=(value.to_f/max.to_f)
			 norm=norm*@@range
			 return norm.round(2)
		else 
			return false
		end
	end

	def self.range=(range)
		@@range=range
	end
end