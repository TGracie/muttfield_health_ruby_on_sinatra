require("pry")
require_relative("../models/booking.rb")
require_relative("../models/member.rb")
require_relative("../models/course.rb")
require_relative("../models/session.rb")

Member.delete_all()
Course.delete_all()
Member.delete_all()
Member.delete_all()

member1 = Member.new({"f_name" => "Jamie", "l_name" => "Gains"})

member2 = Member.new({"f_name" => "Conline", "l_name" => "Graves"})

member3 = Member.new({"f_name" => "Truffles", "l_name" => "Deutermann"})

member1.save()
member2.save()
member3.save()

member1.l_name = "Graves"
member1.update()
member2.f_name = "Caroline"
member2.update()

course1 = Course.new({"type" => "Yogurt"})
course2 = Course.new({"type" => "Swimming"})
course3 = Course.new({"type" => "Jazzercise"})

course1.save()
course2.save()
course3.save()
course1.type = "Yoga"
course1.update()

session1 = Session.new({"course_id" => course1.id, "start_time" => "10:00"})
session2 = Session.new({"course_id" => course2.id, "start_time" => "11:00"})
session3 = Session.new({"course_id" => course3.id, "start_time" => "14:00"})

session1.save()
session2.save()
session3.save()

session1.course_id = course2.id
session1.update()
session2.course_id = course1.id
session2.update()
session3.start_time = "16:00"
session3.update()

booking1 = Booking.new({"session_id" => session1.id, "member_id" => member1.id})
booking2 = Booking.new({"session_id" => session2.id, "member_id" => member2.id})
booking3 = Booking.new({"session_id" => session2.id, "member_id" => member3.id})

booking1.save()
booking2.save()
booking3.save()

binding.pry 
p "let's get physical"
