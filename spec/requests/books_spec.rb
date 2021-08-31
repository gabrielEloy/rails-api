require 'rails_helper'

describe 'Books API', type: :request do
    describe 'GET /books' do
        before do 
            author = FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell')
            FactoryBot.create(:book, title: '1984', author: author)
            FactoryBot.create(:book, title: 'Animal Farm', author: author) 
        end
        
        it 'returns all books' do
            get '/api/v1/books'
    
            expect(response).to have_http_status(:success)
    
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end

    describe 'POST /books' do
        it 'creates one book and one author when the author is nonexistent' do
            expect {
                post '/api/v1/books', params: {
                    book: {
                        title: "The communist manifesto"
                    },
                    author: {
                        first_name: 'Karl', last_name: 'Marx', age: 99
                    }}
            }.to change { Book.count }.from(0).to(1)
            .and change { Author.count }.from(0).to(1)
            
            expect(response).to  have_http_status(:created)
        end

        it "creates a book, but  doesn't create an author when the author is already in the database" do
            # creating the first book, what will trigger the creation of an author
            author = {
                first_name: 'Karl', last_name: 'Marx', age: 99
            }

            expect {
                post '/api/v1/books', params: {
                    book: {
                        title: "The communist manifesto"
                    },
                    author: author
                }
            }.to change { Book.count }.from(0).to(1)
            .and change { Author.count }.from(0).to(1)
            
            
            # creating the second book, what will NOT create one author, since we are passing an existing one
            expect {
                post '/api/v1/books', params: {
                    book: {
                        title: "Das Kapital"
                    },
                    author: author
                }
            }.to change { Book.count }.from(1).to(2)

            # The author count should not change
            expect(Author.count).to eq(1)

        end
    end

    describe 'DELETE /books/:id' do 
        let!(:book) { 
            author = FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell')
            FactoryBot.create(:book, title: '1984', author: author)
        }
        
        it 'deletes a book' do
            expect {
                delete "/api/v1/books/#{book[:id]}"
            }.to change { Book.count }.from(1).to(0)

            expect(response).to have_http_status(:no_content)
        end
    end
end