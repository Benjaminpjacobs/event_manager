require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

class EventManager
  
end

# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5,"0")[0..4]
# end

# def legislators_by_zipcode(zipcode)
#   Sunlight::Congress::Legislator.by_zipcode(zipcode)
# end

# def save_thank_you_letters(id,form_letter)
#   Dir.mkdir("output") unless Dir.exists?("output")

#   filename = "output/thanks_#{id}.html"

#   File.open(filename,'w') do |file|
#     file.puts form_letter
#   end
# end

# puts "EventManager initialized."

# contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

# template_letter = File.read "form_letter.erb"
# erb_template = ERB.new template_letter

# contents.each do |row|
#   id = row[0]
#   name = row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
#   phone_number = row[:phone_number]



#   legislators = legislators_by_zipcode(zipcode)

#   form_letter = erb_template.result(binding)

#   save_thank_you_letters(id,form_letter)
# end

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol


# def clean_phone_number(number)
#   number.gsub(/[^0-9]/, '')
# end

# def validate_phone_number(phone_number)
#   if phone_number.length < 10 || phone_number.length > 11
#     phone_number = "n/a"
#   elsif phone_number.length == 11 && phone_number[0] == "1"
#     phone_number = phone_number[1..-1]
#   elsif phone_number.length == 1
#     phone_number = "n/a"
#   end
#   phone_number
# end

# contents.each do |row|
#   name = row[:first_name]
#   phone_number = row[:homephone]
#   phone_number = clean_phone_number(phone_number)
#   phone_number = validate_phone_number(phone_number)
  
#   puts "#{name} #{phone_number}"
# end

###################################

# hours = contents.map do |row|
#   # name = row[:first_name]
#   registration = row[:regdate]
#   registration.gsub!("/", "-")
#   date = DateTime.strptime(registration, '%m-%d-%y %H:%M')
#   date.hour
# end

# most_common_times = hours.group_by{|hour| hours.count(hour)}.sort.max[1].sort.uniq
# most_common_times.each do |time|
#   if time > 12
#     time = (time - 12).to_s + "pm"
#   else
#     time = time.to_s
#   end
#   puts "#{time} is a common hour for registration"
# end

###################################



# days = contents.map do |row|
#   # name = row[:first_name]
#   registration = row[:regdate]
#   registration.gsub!("/", "-")
#   date = DateTime.strptime(registration, '%m-%d-%y %H:%M')
#   Date::DAYNAMES[date.wday]
# end

# most_common_days = days.group_by{|day| days.count(day)}.max[1].sort.uniq

# most_common_days.each do |day|
#   puts "#{day} is the most common day for registration"
# end
