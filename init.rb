APP_ROOT=File.dirname(__FILE__)
$:.unshift(File.join(APP_ROOT,'lib'))
RECENCY=0
FREQUENCY=1
MONETORY=2
SCORE=3
require 'guide'
Fuzzy.range=5
guide=Guide.new("rfm.csv")
guide.launch!
#fuzzy=Fuzzy.new(49,50)
#puts "#{fuzzy.linguistic.s},#{fuzzy.linguistic.alpha}"

#RFM.weight=[5,11,9]
#RFM.max=[50,50,50]
#rfm=RFM.new
#rfm.set_rfm(RECENCY,49)
#rfm.set_rfm(FREQUENCY,4)
#rfm.set_rfm(MONETORY,38)
#puts rfm.rfm[RECENCY].linguistic.s
#puts rfm.rfm[RECENCY].linguistic.alpha
#rfm.rfm.each do |r|
#	puts "#{r.linguistic.s}, #{r.linguistic.alpha}"
#end
#puts rfm.average.delta_inverse

#puts "#{fuzzy.linguistic.s}, #{fuzzy.linguistic.alpha}"
#float=3.4
