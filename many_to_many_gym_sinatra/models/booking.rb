require_relative("../db/sql_runner.rb")

class Booking

  attr_reader :id
  attr_accessor :session_id, :member_id

def initialize(options)
  @id = options["id"].to_i
  @session_id = options["session_id"].to_i
  @member_id = options["member_id"].to_i
end

# single_result

def self.hash_result(data)
  booking_hash = data[0]
  booking = Booking.new(booking_hash)
end

# map_items

def self.map_items(data)
  result = data.map{|details| Booking.new(details) }
  return result
end

# delete all()
def self.delete_all()
  sql = "DELETE FROM bookings;"
  SqlRunner.run(sql)
end


# save
def save()
  sql = "INSERT into bookings(session_id, member_id)
  VALUES($1, $2)
  RETURNING id;"

  values = [@session_id, @member_id]
  result = SqlRunner.run(sql, values)
  result_hash = result[0]
  string_id = result_hash["id"]
  @id = string_id.to_i
end



# class end
end
