require_relative 'entry'
require "csv"

class AddressBook
  attr_reader :entries
  
  def initialize
    @entries = []
  end
  
  def add_entry(name, phone_number, email)
    entries.each do |entry|
      if name == entry.name && phone_number == entry.phone_number && email == entry.email
        return "Entry already exists"
      end
    end
    if !name || !phone_number || !email
      puts "Invalid entry. Please enter a name, a phone number, and an email address."
    else
      insertion_index = entries.index {|entry| name < entry.name} || -1
      entries.insert(insertion_index, Entry.new(name, phone_number, email))
    end
  end
  
  def remove_entry(name, phone_number, email)
    entries.each do |entry|
      if name == entry.name && phone_number == entry.phone_number && email == entry.email
        entries.delete(entry)
      end
    end
  end
  
  def demolish
  end
  
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end
  
  def binary_search(name)
    lower = 0
    upper = entries.length - 1
    
    while lower <= upper
      mid = (lower + upper) / 2
      mid_name = entries[mid].name
      if name == mid_name
        return entries[mid]
      elsif name < mid_name
        upper = mid-1
      elsif name > mid_name
        lower = mid + 1
      end
    end
    return nil
  end
  
  def iterative_search(name)
    entries.each do |entry|
      if name == entry.name
        return entry
      end
    end
    return nil
  end
  
end
