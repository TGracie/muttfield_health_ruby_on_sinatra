require_relative("../db/sql_runner.rb")

class Session

attr_reader :id
attr_accessor :course_id, :start_time, :capacity

def initialize(options)
  @id = options["id"].to_i
  @course_id = options["course_id"].to_i
  @start_time = options["start_time"]
  @capacity = options["capacity"].to_i
end

# single_result

def self.hash_result(data)
  session_hash = data[0]
  session = Session.new(session_hash)
end

# map_items

def self.map_items(data)
  result = data.map{|details| Session.new(details) }
  return result
end


# delete all
def self.delete_all()
  sql = "DELETE FROM sessions;"
  SqlRunner.run(sql)
end

# save
def save()
  sql = "INSERT into sessions(course_id, start_time, capacity)
    VALUES($1, $2, $3)
    RETURNING id;"

  values = [@course_id, @start_time, @capacity]
  result = SqlRunner.run(sql, values)
  result_hash = result[0]
  string_id = result_hash["id"]
  @id = string_id.to_i
end

# update

def update()
  sql = "UPDATE sessions
    SET(course_id, start_time, capacity)
    = ($1, $2, $3)
    WHERE id = $4;"

  values = [@course_id, @start_time, @capacity, @id]
  SqlRunner.run(sql,values)
end

# find_all

def self.all()
  sql = "SELECT * FROM sessions;"

  result = SqlRunner.run(sql)
  Session.map_items(result)
end

# find(id)

def self.find(id)
  sql = "Select * FROM sessions
  WHERE ID = $1;"

  values = [id]
  data = SqlRunner.run(sql,values)
  Session.hash_result(data)
end

# delete(id)

def delete()
  sql = "DELETE FROM sessions
  WHERE ID = $1;"

  values = [id]
  SqlRunner.run(sql,values)
end

def members()
  # we want the members for this session SO! we don't NEED the session table, just the session ID - we will be calling this on a session - the ID will be there, take session id to booking table to get the member id take that to member table to pull the members' data.
  sql = "SELECT members.* FROM members
    INNER JOIN bookings
    ON members.id = bookings.member_id
    WHERE session_id = $1
    ORDER BY f_name;"

  result = SqlRunner.run(sql, [@id])
  Member.map_items(result)
end

# count members in the session - calling it on a session so session.members.count

def count()
  members().count()
end

# vacancies - this will subtract count from capacity.
def vacancies()
  registered = count()
  number = @capacity
  vacancies = number -= registered
  if vacancies <= 0
    return 0
  else
    return vacancies
  end
end

# members in the session
def on_list()
  sql = "SELECT members.* FROM members
    INNER JOIN bookings
    ON members.id = bookings.member_id
    WHERE session_id = $1
    ORDER BY bookings.id
    LIMIT $2;"

    values = [@id, @capacity]

  result = SqlRunner.run(sql, values)
  Member.map_items(result)
end

# waitlist members
def waitlist()
  sql = "SELECT members.* FROM members
    INNER JOIN bookings
    ON members.id = bookings.member_id
    WHERE session_id = $1
    ORDER BY bookings.id
    OFFSET $2;"

    values = [@id, @capacity]

  result = SqlRunner.run(sql, values)
  Member.map_items(result)
end


# return course name/type
def course()
  #get the course for the course_id in the session
  sql ="SELECT * from courses
    WHERE id = $1;"

  values = [@course_id]
  data = SqlRunner.run(sql,values)
  Course.hash_result(data)
end

def booking()
  sql = "SELECT * from bookings
  WHERE session_id = $1;"

  values = [@id]
  data = SqlRunner.run(sql,values)
  Booking.hash_result(data)
end

# array of member ids already in this session
def exclude_members()
  members_booked = members()
  array = []
  for member in members_booked
    array << member.id
  end
  array
end

def available_members(exclude_members)
  members = Member.all()
  data = members.reject{|member| exclude_members.include?(member.id)}
end


#handy: sessions sorted by start time
def self.sorted_start_times()
  sessions = Session.all()
  sorted = sessions.sort_by {|session| session.start_time}
end

def self.sorted_by_course()
  sessions = Session.all()
  sorted = sessions.sort_by {|session| [session.course.type, session.start_time]}
end


def self.sort_sessions(sessions)
  sessions.sort_by {|session| [session.course.type, session.start_time]}
end

def sort_sesh(array)
  array.sort_by {|session| [session.course.type, session.start_time]}
end

#class end
end
