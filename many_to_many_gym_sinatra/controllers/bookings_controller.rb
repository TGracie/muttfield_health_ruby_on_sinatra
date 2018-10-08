require("sinatra")
require("sinatra/contrib/all")
require_relative("../models/booking.rb")
require_relative("../models/session.rb")
require_relative("../models/member.rb")
also_reload("../models/*")

# SKIP INDEX for now.

# NEW  - from member - member prepopulated

# NEW - from session - session prepoulated

# SHOW - this will be a confirmation page will need to link somewhere from here?
get "/bookings/:id" do
  @booking = Booking.find(params[:id])
  erb(:"/bookings/show")
end


# CREATE - same for both new

# Edit
get "/bookings/:id/edit" do
  #@courses = Course.all()
  @sessions = Session.all()
  @members = Member.all()
  @booking = Booking.find(params[:id])
  erb(:"bookings/edit")
end

# DELETE
post "/bookings/:id/delete" do
  booking = Booking.find(params[:id])
  booking.delete()
  redirect to "/"
  # for now this redirects to home - but it does delete
end

# UPDATE
post "/bookings/:id/edit" do
  @booking = Booking.new(params)
  @booking.update()
  redirect to("/bookings/#{@booking.id}")
end
