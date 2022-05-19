require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    it 'returns all the books' do
      FactoryBot.create(:book, title: "Time Machine", author: "George")
      FactoryBot.create(:book, title: "Yo yo", author: "Gorge")

      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    it 'creates a new book' do
      expect {
        post '/api/v1/books', params: {book: {title: 'The Martian', author: 'Andy Weir'}}
      }.to change { Book.count }.from(0).to(1)
    
      expect(response).to have_http_status(:created)
    end 
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: "Time Machine", author: "George") }
    
    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end