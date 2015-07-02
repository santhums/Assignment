class Slot
  attr_accessor :slot_no, :reg_no, :color, :created_at

  def initialize(slot_no)
  	@slot_no = slot_no
    @reg_no = nil
    @color = nil
    @created_at = nil
  end

  def create(reg_no, color)
  	self.reg_no = reg_no
  	self.color = color
  	self.created_at = Time.now
  end

  def clear
  	self.reg_no = nil
  	self.color = nil
  	self.created_at = nil
  end
end

class ParkingLot
	SLOTS = Array.new

	def create_parking_lot(args)
		no = args[0].to_i
		no.times{|i| SLOTS << Slot.new(i+1)}
		"Created a parking lot with #{no} slots\n\n"
	end

	def park(args)
		if slot = find_vaccant
			slot.create(args[0], args[1])
			"Allocated slot number: #{slot.slot_no}\n\n"
		else
			"Sorry, parking lot is full\n\n"
		end
	end

	def leave(args)
		no = args[0].to_i
		slot = SLOTS.find{|s| s.slot_no==no}
		slot.clear
		"Slot number #{no} is free\n\n"
	end

	def status(args)
		puts "Slot No\tRegistration No Color\n\n"
		slots = SLOTS.select{|s| s.created_at}
		arr = []
		slots.each do |slot|
			arr << "#{slot.slot_no}\t#{slot.reg_no}\t#{slot.color}\n\n"
		end
		arr
	end

	def registration_numbers_for_cars_with_colour(args)
		color = args[0]
		if slots = find_by_color(color)
			reg_numbers = slots.map(&:reg_no).join(', ')
			"#{reg_numbers}\n\n"
		end
	end

	def slot_numbers_for_cars_with_colour(args)
		color = args[0]
		if slots = find_by_color(color)
			slot_numbers = slots.map(&:slot_no).join(', ')
			"#{slot_numbers}\n\n"
		end
	end

	def slot_number_for_registration_number(args)
		no = args[0]
		slot = SLOTS.find{|s| s.reg_no==no}
		if slot
			"#{slot.slot_no}\n\n"
		else
			"Not found\n\n"
		end
	end

	private
	def find_vaccant
		SLOTS.find{|s| s.created_at.nil?}
	end

	def find_by_color(color)
		slots = SLOTS.select{|s| s.color==color}
		if slots.empty?
			puts "Not found\n\n"
			return
		else
			slots
		end
	end
end

class Parking

	def main
		@parking_lot = ParkingLot.new
		methods = ['create_parking_lot', 'park', 'leave', 'status', 'registration_numbers_for_cars_with_colour', 'slot_numbers_for_cars_with_colour', 'slot_number_for_registration_number']
		if ARGV[0]
			File.open(ARGV[0]).each_line do |line|
				args = line.delete("\n").split(' ')
				command = args.delete_at(0)
				puts @parking_lot.public_send(command, args)
			end
		else
			loop do
				input = gets.chomp
				break if input == 'exit'
				args = input.split(' ')
				command = args.delete_at(0)
				unless methods.include?(command)
					puts "Invalid Command"
					next
				end
				puts @parking_lot.public_send(command, args)
			end	
		end
	end
end

Parking.new.main