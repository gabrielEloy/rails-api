class BooksRepresenter 
    def initialize(books)
        @books = books
    end

    def as_json
        books.map do |book|
            format_book(book)
        end
    end

    def format_book(book)
        return {
            id: book.id,
            title: book.title,
            name: author_name(book),
            author_age: book.author.age,
        }
    end

    private
    attr_reader :books

    def author_name(book)
       return "#{book.author.first_name} #{book.author.last_name}"
    end
end