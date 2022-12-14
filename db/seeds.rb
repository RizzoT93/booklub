# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "faker"
Message.destroy_all
List.destroy_all
User.destroy_all
Book.destroy_all
user = User.new(
  email: 'banana@lewagon.com',
  password: '123456'
)
user.save!

require "json"
require "open-uri"

array = ["lordoftherings", "thetwilightsaga", "harrypotter", "mebeforeyou", "FiftyShadesofGrey", "disney",
         "The Chronicles of Narnia", "principito", "brenebrown", "maybeyoushouldtalktosomeone",
         "Art", "drama", "travel", "philosophy", "education", "fiction"]
array.each do |title|
  url = "https://www.googleapis.com/books/v1/volumes?q=search+#{title}"
  book_serialized = URI.open(url).read
  book = JSON.parse(book_serialized)

  book["items"].each do |book_hash|
    next if book_hash["volumeInfo"]["title"] == ""

    book = Book.create!(
      title: book_hash["volumeInfo"]["title"],
      description: book_hash["volumeInfo"]["description"],
      published_year: book_hash["volumeInfo"]["publishedDate"],
      num_of_pages: book_hash["volumeInfo"]["pageCount"]
    )
    # puts book.title
    if book_hash["volumeInfo"]["categories"]
      book.category = book_hash["volumeInfo"]["categories"][0]
      book.save!
    end
    if book_hash["volumeInfo"]["authors"]
      book.author = book_hash["volumeInfo"]["authors"][0]
      book.save!
    end
    if book_hash["volumeInfo"]["imageLinks"]
      book.img_book = book_hash["volumeInfo"]["imageLinks"]["smallThumbnail"]
      book.save!
    end
    Chatroom.create(name: book.title)
  end
end
puts "done"
