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


# update

def update()
  sql = "UPDATE bookings
    SET(session_id, member_id)
    = ($1, $2)
    WHERE id = $3;"

  values = [@session_id, @member_id, @id]
  SqlRunner.run(sql,values)
end

# find_all

def self.all()
  sql = "SELECT * FROM bookings;"

  result = SqlRunner.run(sql)
  Booking.map_items(result)
end

# find(id)

def self.find(id)
  sql = "Select * FROM bookings
    WHERE ID = $1;"

  values = [id]
  data = SqlRunner.run(sql,values)
  Booking.hash_result(data)
end

# delete(id)
def delete()
  sql = "DELETE FROM bookings
    WHERE ID = $1;"

  values = [id]
  SqlRunner.run(sql,values)
end

# member

def member()
  sql = "Select * from members
    WHERE id = $1
    ORDER BY f_name;"

  values = [@member_id]
  data = SqlRunner.run(sql,values)
  Member.hash_result(data)
end

# session
def session()
  sql = "SELECT * from sessions
    WHERE id = $1;"

  values = [@session_id]
  data = SqlRunner.run(sql, values)
  Session.hash_result(data)
end



# class end
end
