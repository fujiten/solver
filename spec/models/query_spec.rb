require 'rails_helper'

RSpec.describe Query, type: :model do
  describe '#create' do

    it "is valid with a body, answer, revealed_point, and point(問題、回答、開示ポイント、獲得ポイントがあれば正当である)" do
      query = FactoryBot.build(:query)
      expect(query).to be_valid
    end

    it "is invalid without a body(問題無しでは不正になる)" do
      query = FactoryBot.build(:query, body: nil)
      query.valid?
      expect(query.errors[:body]).to include("を入力してください")
    end

    it "is invalid if a body is more than 40 characters(問題が40文字を超えると不正になる)" do
      query = FactoryBot.build(:query, body: Faker::String.random(41))
      query.valid?
      expect(query.errors[:body]).to include("は40文字以内で入力してください")
    end

    it "is invalid without a answer(回答無しでは不正になる)" do
      query = FactoryBot.build(:query, answer: nil)
      query.valid?
      expect(query.errors[:answer]).to include("を入力してください")
    end

    it "is invalid if a answer is more than 40 characters(回答が40文字を超えると不正になる)" do
      query = FactoryBot.build(:query, answer: Faker::String.random(41))
      query.valid?
      expect(query.errors[:answer]).to include("は40文字以内で入力してください")
    end

    it "is invalid if a revealed_point is more than 1000(開示ポイントが1000以上だと不正になる)" do
      query = FactoryBot.build(:query, revealed_point: (Random.rand * 10 ** 6).ceil)
      query.valid?
      expect(query.errors[:revealed_point]).to include("は1000より小さい値にしてください")
    end

    it "is invalid if a point is more than 100(獲得ポイントが100以上だと不正になる)" do
      query = FactoryBot.build(:query, point: (Random.rand * 10 ** 5 ).ceil)
      query.valid?
      expect(query.errors[:point]).to include("は100より小さい値にしてください")
    end

  end
end
