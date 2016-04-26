require 'customer'
class Guide

	def initialize(file_path=nil)
		Customer.file_path=file_path

		if Customer.file_exists?
			puts ">>File Found"
		elsif Customer.file_create
		else
			puts "Exiting\n\n"
			exit!
		end		

	end

	def intro
		puts 
		puts "Hello, I will guide you to find the best customers!"
		puts "---------------------------------------------------"
		puts
	end

	def conclusion
		puts "<< Goodbye! >>"
		puts
	end

	def launch!
		system("clear")
		intro
		print "(add , list, configure, compute, exit) : >"
		user_response=gets.chomp.downcase
		user_response=do_action(user_response)
		while user_response!=:quit
			print "(add, list, configure, compute, exit) : >"
			user_response=gets.chomp.downcase
			user_response=do_action(user_response)
		end
			
		
		conclusion
	end

	def do_action(action)
		case action
		when "list"
			list
		when "compute"
			system("clear")
			Customer.rfm_deploy
		when "add"
			system("clear")
			add
		when "configure"
			system("clear")
			Customer.set_config
		when "exit"
			return :quit
		else
			puts "I didn't understand"
		end
	end

	def add
		system("clear")
		puts "Add new customer".upcase
		puts "------------------"
		customer=Customer.new(true)
	end

	def list
		system("clear")
		customers=Customer.saved_customers;
		for customer in customers
			customer.put_line
		end
	end
end