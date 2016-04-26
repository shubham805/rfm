class Tuple
	attr_accessor :s, :alpha
	def initialize(beta)
		delta(beta)
	end

	def delta(beta)
		@s=beta.round
		@alpha=(beta-@s).round(4)
	end

	def delta_inverse()
		return (@s+@alpha).round(4)
	end
end