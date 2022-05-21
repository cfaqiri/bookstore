require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: "George", last_name: "Orwell", age: 46) }
  let(:second_author) { FactoryBot.create(:author, first_name: "Harry", last_name: "Wells", age: 98) }
  
  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: "Time Machine", author: first_author)
      FactoryBot.create(:book, title: "Yo yo", author: second_author)
    end
    
    it 'returns all the books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body)).to eq(
        [
          {
            'id' => 1,
            'title' => 'Time Machine',
            'author_name' => 'George Orwell',
            'author_age' => 46
          },
          {
            'id' => 2,
            'title' => 'Yo yo',
            'author_name' => 'Harry Wells',
            'author_age' => 98
          }
        ]
      )
    end
  end

  describe 'POST /books' do
    it 'creates a new book' do
      expect {
        post '/api/v1/books', params: {
          book: {title: 'The Martian'}, 
          author: {first_name: 'Andy', last_name: 'Weir', age: '67'}}
      }.to change { Book.count }.from(0).to(1)
    
      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(JSON.parse(response.body)).to eq(
        {
          'id' => 1,
          'title' => 'The Martian',
          'author_name' => 'Andy Weir',
          'author_age' => 67
        }
      )
    end 
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: "Time Machine", author: first_author) }
    
    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end