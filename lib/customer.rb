require "support/number_helper"
require "rfm"
class Customer < RFM
	include NumberHelper
	@@file_path=nil
	@@customers=nil
	@@limit=20
	attr_accessor :id, :amount, :recent, :frequency , :score

	def initialize(input,id=0,amount=0,recent=0,frequency=0)
		if !input
			@id=id
			@amount=amount
			@recent=recent
			@frequency=frequency
			@score=' '
		else
			get_details
		end
		super()
	end

	def get_details
		print " Id:".ljust(15)
		@id=gets.chomp.strip
		print "Amount ($) :".ljust(15)
		@amount=gets.chomp.strip
		print "Last purchase (Days):".ljust(15)
		@recent=gets.chomp.strip
		print "Frequency :".ljust(15)
		@frequency=gets.chomp.strip
		if save
			puts "customer saved."
			return true
		else
			puts "Error saving"
			return false
		end
	end

	def self.file_path=(file_path)
		@@file_path=File.join(APP_ROOT,file_path)
	end

	def self.file_exists?
		if file_usable?
			return true
		else
			return false
		end
	end

	def self.file_usable?
		return false unless @@file_path
		return false unless File.exists?(@@file_path)
		return false unless File.readable?(@@file_path)
		return false unless File.writable?(@@file_path)
		return true
	end

	def self.file_create
		File.open(@@file_path,'w') unless file_exists?
		return file_usable?
	end

	def self.saved_customers
		customers=[]
		itr=0
		File.open(@@file_path, "r") do |file|  
			file.each_line do |line|
				if itr!=0
					customer=Customer.new(false)
					customers<<customer.import_line(line.chomp)
				end
				itr=itr+1
			end
		end
		@@customers=customers
		return customers
	end

	def save
		return false unless Customer.file_usable?
		temp="1/1/1"
		File.open(@@file_path,'a') do |file|
			file.puts "#{[@id, @amount, temp ,@frequency ,@recent,].join(",")}\n"
			end
		return true
	end

	def import_line(line)
		line_array = line.split(",")
		@id, @amount, temp, @frequency ,@recent = line_array
		return self
	end

	def self.action_header
		puts
		puts "customers (sorted by rfm score)".upcase
		puts "-"*73
		print "ID".ljust(8)
		print "Last Purchase (Days)".ljust(25)
		print "Frequency".ljust(10)
		print "Total Ammount".ljust(15)
		print "RFM score".ljust(10)
		print "\n"
		puts  "-"*(73)
	end

	def put_line()
		line=@id.ljust(8)
		line <<@recent.center(25)
		line<<@frequency.ljust(10)
		price=formatted_price
		line<<price.ljust(15)
		line<<@score.to_s.ljust(10)
		#puts "#{@id}|#{@recent}|#{frequency}|#{formatted_price}"
		puts line
	end

	def formatted_price
		return number_to_currency(@amount)
	end

	def self.sort_by(by)
		@@customers=saved_customers unless @@customers
		@@customers.sort! do |a, b|
			case by
			when 0
				a.recent.to_i <=> b.recent.to_i
			when 1
				b.frequency.to_i <=> a.frequency.to_i
			when 2   
				b.amount.to_i <=> a.amount.to_i
			when 3
				b.score <=> a.score
			end
		end
		return @@customers
	end

	def self.fuzzy_compute_rfm(rfm)
		#puts "Number of bins"
		#p=gets.chomp
		self.sort_by(rfm)
		p=@@max[rfm]
		bin=(@@customers.count/p)
		#puts bin
		#puts @@customers.count
		@@customers.each_index do |itr|  
			@@customers[itr].set_rfm(rfm, p)
			#puts @@customers[itr].rfm[rfm]
			if itr%bin==0
				p=p-1
			end
			#puts p
		end
	end

	def self.fuzzy_compute
		i=0
		3.times  do
			fuzzy_compute_rfm(i)
			i=i+1
		end
		@@customers.each_index do |itr|  
			@@customers[itr].score=@@customers[itr].average.delta_inverse
			#puts @@customers[itr].score.round(2)
		end
	end

	def self.rfm_deploy()
		fuzzy_compute
		display_config
		customers=Customer.sort_by(SCORE);
		i=0
		action_header
		for customer in customers
			customer.put_line
			i=i+1
			if i==@@limit
				break
			end
		end
		puts "-"*73
	end

	def self.set_config()
		print "Limit".ljust(30)
		print " = "
		@@limit=gets.chomp
		@@limit=@@limit.to_i

		print "Number of bins (recency)".ljust(30)
		print " = "
		p=gets.chomp
		@@max[RECENCY]=p.to_i

		print "Number of bins (frequency)".ljust(30)
		print " = "
		p=gets.chomp
		@@max[FREQUENCY]=p.to_i

		print "Number of bins (monetory)".ljust(30)
		print " = "
		p=gets.chomp
		@@max[MONETORY]=p.to_i

		print "Weight (recency)".ljust(30)
		print " = "
		p=gets.chomp
		@@weight[RECENCY]=p.to_i

		print "Weight (frequency)".ljust(30)
		print " = "
		p=gets.chomp
		@@weight[FREQUENCY]=p.to_i

		print "Weight (monetory)".ljust(30)
		print " = "
		p=gets.chomp
		@@weight[MONETORY]=p.to_i
	end

	def self.display_config
		print "Limit".ljust(30)
		print " = "
		puts @@limit

		print "Number of bins (recency)".ljust(30)
		print " = "
		puts @@max[RECENCY]

		print "Number of bins (frequency)".ljust(30)
		print " = "
		puts @@max[FREQUENCY]

		print "Number of bins (monetory)".ljust(30)
		print " = "
		puts @@max[MONETORY]

		print "Weight (recency)".ljust(30)
		print " = "
		puts @@weight[RECENCY]

		print "Weight (frequency)".ljust(30)
		print " = "
		puts @@weight[FREQUENCY]

		print "Weight (monetory)".ljust(30)
		print " = "
		puts @@weight[MONETORY]
	end
end