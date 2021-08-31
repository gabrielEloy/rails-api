module Api
  module V1
    class BooksController < ApplicationController
  
      def index
        render json: BooksRepresenter.new(Book.all).as_json()
      end
    
      def create
        author = Author.find_or_create_by!(author_params)
        book = Book.create(book_params.merge(author_id: author.id))
        formatted_book = BooksRepresenter.new(book).format_book(book)
        if book.save
          render json: formatted_book, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end
    
      def destroy 
        Book.find(params[:id]).destroy!
    
        head :no_content
      end
    
    
      def author_params
        params.require(:author).permit(:first_name, :last_name, :age)
      end
      def book_params
        params.require(:book).permit(:title, :author)
      end
    end    
  end
end

