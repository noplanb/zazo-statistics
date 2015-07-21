require 'rails_helper'

RSpec.describe Api::V1::FetchController, type: :controller do
  describe 'GET #show' do
    subject { get :show, id: '', name: :anything }

    specify do
      subject
      expect(response).to have_http_status(:not_found)
      expect(json_response).to eq('errors' => 'Anything class not found')
    end
  end

  describe 'GET "users/:name"' do
    subject { get :show, id: '', prefix: :users, name: name }

    context 'unknown' do
      let(:name) { :unknown }

      specify do
        subject
        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq('errors' => 'Users::Unknown class not found')
      end
    end

    context 'not_verified' do
      let(:name) { :not_verified }

      specify do
        subject
        expect(response).to have_http_status(:success)
        expect(json_response).to be_a(Array)
      end
    end
  end
end