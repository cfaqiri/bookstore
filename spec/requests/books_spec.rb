require 'rails_helper'

describe 'Books API', type: :request do
  it 'returns all the books' do
    FactoryBot.create(:book, title: "Time Machine", author: "George")
    FactoryBot.create(:book, title: "Yo yo", author: "Gorge")

    get '/api/v1/books'

    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).size).to eq(2)
  end
end