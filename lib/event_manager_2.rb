require 'csv'
require 'erb'
require 'date'
require 'sunlight/congress'

class EventManager

  Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

  def csv_with_headers(file_name)
    CSV.open file_name, headers: true, header_converters: :symbol
  end
  
  def save_thank_you_letters(id, form_letter)
    Dir.mkdir("output") unless Dir.exists? "output"
    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
    end
  end
  
  def generate_form_letter(contents, form_letter)
    template_letter = File.read form_letter
    erb_template = ERB.new template_letter
    write_and_save(contents, form_letter, erb_template)
  end

  def write_and_save(contents, form_letter, erb_template)
    contents.each do |row|
      id = row[0]
      name = row[:first_name]
      zipcode = clean_zip(row[:zipcode])
      legislators = legislators_by_zipcode(zipcode)
      form_letter = erb_template.result(binding)
      save_thank_you_letters(id, form_letter)
    end
  end

  def cell_phone_numbers(contents)
    contents.each do |row|
      name = row[:first_name]
      phone_number = clean_phone_number(row[:homephone])
      phone_number = format_number(phone_number)
      puts "#{name} #{phone_number}"
    end
  end

  def most_common_registration_time(contents)
    reg_times = collect_date_time_objects(contents)
    reg_times = collect_hours(reg_times)
    reg_times = sort_registration_times(reg_times)
    puts add_time_readability(reg_times)
  end

  def most_common_registration_day(contents)
    reg_times = collect_date_time_objects(contents)
    reg_times = collect_days(reg_times)
    reg_times = reg_times.group_by{|day| reg_times.count(day)}.max[1].uniq
    p add_day_readability(reg_times)
  end
  
private

  def clean_zip(zipcode)
    zipcode.to_s.rjust(5, "0")[0..4]
  end
  
  def legislators_by_zipcode(zipcode)
    Sunlight::Congress::Legislator.by_zipcode(zipcode)
  end

  def clean_phone_number(number)
    number.gsub(/[^0-9]/, '')
  end

  def format_number(number)
    if number.length == 11 && number[0] == "1"
      number[1..-1].insert(3, '.').insert(7, '.')
    elsif number.length != 10
      "n/a"
    else
      number.insert(3, '.').insert(7, '.')
    end
  end

  def add_day_readability(reg_times)
    reg_times.map do |day|
      if day == reg_times.last
        day + " is/are the most commmon registration day(s)"
      else
        day + " and "
      end
    end.join
  end

  def collect_days(reg_times)
    reg_times.collect do |date|
      Date::DAYNAMES[date.wday]
    end
  end

  def add_time_readability(reg_times)
    reg_times.map do |time|
      if time == reg_times.last
        format_time(time) + " is/are the most commmon registration time(s)"
      else
        format_time(time) + " and "
      end
    end.join
  end

  def collect_date_time_objects(contents)
    contents.collect do |row|
      time = row[:regdate]
      DateTime.strptime(time, "%m/%d/%y %H:%M")
    end
  end

  def collect_hours(reg_times)
    reg_times.collect do |time|
      time.hour
    end
  end

  def sort_registration_times(reg_times)
    reg_times.group_by{|time| reg_times.count(time)}.max[1].uniq!
  end
  
  def format_time(time)
    if time < 12
      time.to_s + "am"
    else
      (time-12).to_s + "pm"
    end
  end
end

###############


em = EventManager.new
contents = em.csv_with_headers("event_attendees.csv")
em.generate_form_letter(contents, "form_letter.erb")
# em.cell_phone_numbers(contents)
# em.most_common_registration_time(contents)
# em.most_common_registration_day(contents)