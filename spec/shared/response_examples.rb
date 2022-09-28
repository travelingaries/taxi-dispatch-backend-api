# frozen_string_literal: true

shared_examples 'Bad Request 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(400)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'Unauthorized 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(401)
      expect(subject['message']).to eq('로그인이 필요합니다')
    end
  end
end

shared_examples 'Forbidden 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(403)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'Not Found 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(404)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'Conflict 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(409)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'OK 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(200)
    end
  end
end

shared_examples 'Created 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before do
      send request_method_name
    end

    it do
      expect(response).to have_http_status(201)
    end
  end
end
