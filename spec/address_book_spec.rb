require_relative '../models/address_book'

RSpec.describe AddressBook do

  let(:book) {AddressBook.new}

  def check_entry(entry, expected_name, expected_number, expected_email)
    expect(entry.name).to eq expected_name
    expect(entry.phone_number).to eq expected_number
    expect(entry.email).to eq expected_email
  end

  describe 'attributes' do
    it 'responds to entries' do
      expect(book).to respond_to(:entries)
    end

    it 'initializes entries as an array' do
      expect(book.entries).to be_an(Array)
    end

    it 'initializes entries as empty' do
      expect(book.entries.size).to eq(0)
    end
  end

  describe "#add_entry" do
    it "adds only one entry to the address book" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      expect(book.entries.size).to eq(1)
    end

    it "adds the correct information to entries" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      new_entry = book.entries[0]

      expect(new_entry.name).to eq('Ada Lovelace')
      expect(new_entry.phone_number).to eq('010.012.1815')
      expect(new_entry.email).to eq('augusta.king@lovelace.com')
    end

    it "does not accept duplicate entries" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      expect(book.entries.size).to eq(1)
    end

    it "does not accept incomplete entries" do
      book.add_entry('Ada Lovelace', '010.012.1815', '')
      expect(book.entries.size).to eq(0)
    end
  end

  describe "#demolish" do
    it "deletes all entries" do
      book.import_from_csv("entries.csv")
      book.demolish
      expect(book.entries.size).to eq 0
    end
  end

  describe "#import_from_1st_csv" do
    it "imports the correct number of entries" do
      book.import_from_csv("entries.csv")
      expect(book.entries.size).to eq 5
    end

    it "imports the correct 3rd entry" do
      book.import_from_csv("entries.csv")
      entry_three = book.entries[2]
      check_entry(entry_three, "Joe", "555-555-3660", "joe@blocmail.com")
    end
  end

  describe "#import_from_2nd_csv" do
    it "imports the correct number of entries" do
      book.import_from_csv("entries_2.csv")
      book_size = book.entries.size
      expect(book_size).to eq 3
    end

    it "imports the correct 2nd entry" do
      book.import_from_csv("entries_2.csv")
      entry_two = book.entries[1]
      check_entry(entry_two, "Diane", "111-456-7890", "diane@hotmail.com")
    end
  end

  describe "#remove_entry" do
    it "removes only one entry from the address book" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      book.remove_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')

      expect(book.entries.size).to eq(0)
    end
  end

  describe "binary search" do
    it "searches AddressBook for a non-existent entry" do
      book.import_from_csv('entries.csv')
      entry = book.binary_search('Dan')
      expect(entry).to be_nil
    end

    it "searches AddressBook for Bob" do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Bob")
      expect(entry).to be_a Entry
      check_entry(entry, "Bob", "555-555-5415", "bob@blocmail.com")
    end
  end

  describe "iterative search" do
    it "searches AddressBook for a non-existent entry" do
      book.import_from_csv('entries.csv')
      entry = book.iterative_search('Dan')
      expect(entry).to be_nil
    end

    it "searches AddressBook for Sally" do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Sally")
      expect(entry).to be_a Entry
      check_entry(entry, "Sally", "555-555-4646", "sally@blocmail.com")
    end

    it "searches AddressBook for Billy" do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Billy")
      expect(entry).to be_nil
    end
  end
end
