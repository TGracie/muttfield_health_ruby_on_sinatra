require("sinatra")
require("sinatra/contrib/all")
require_relative("../models/course.rb")
also_reload("../models/*")


# INDEX
get "/courses" do
  @courses = Course.all()
  erb(:"courses/index")
end

# NEW
get "/courses/new" do
  erb(:"courses/new")
end

# SHOW
get "/courses/:id" do
  @course = Course.find(params[:id])
  @sessions = @course.sessions()
  erb(:"courses/show")
end

# CREATE
post "/courses/:id" do
  @course = Course.new(params)
  @course.save()
  redirect to("/courses/#{@course.id}")
end


# EDIT
get "/courses/:id/edit" do
  @course = Course.find(params[:id])
  erb(:"courses/edit")
end


# DELETE
post "/courses/:id/delete" do
  course = Course.find(params[:id])
  course.delete()
  redirect to "/courses"
end

# UPDATE
post "/courses/:id/edit" do
  @course = Course.new(params)
  @course.update()
  redirect to("/courses/#{@course.id}")
end
