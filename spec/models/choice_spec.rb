require 'rails_helper'

RSpec.describe Choice, type: :model do
  describe '#create' do
    
    it "is valid with a body, a correctness(問題と正解か不正解化があれば正当である)" do
      choice = FactoryBot.build(:choice)
      expect(choice).to be_valid
    end

    it "is invalid without a body(問題無しでは不正になる)" do
      choice = FactoryBot.build(:choice, body: nil)
      choice.valid?
      expect(choice.errors[:body]).to include("を入力してください")
    end

    it "is invalid if a body is more than 60 characters(問題が60文字以上ならば不正になる)" do
      choice = FactoryBot.build(:choice, body: Faker::String.random(61))
      choice.valid?
      expect(choice.errors[:body]).to include("は60文字以内で入力してください")
    end

    it "is invalid if a correctness is not true or false(コレクトネスがtrueかfalse以外では不正になる)" do
      choice = FactoryBot.build(:choice, correctness: nil)
      choice.valid?
      expect(choice.errors[:correctness]).to include("は一覧にありません")
    end

  end
end
