require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe '#create' do

    it "is valid with a title, question, answer(タイトル、問題、解説があれば正当である)" do
      quiz = FactoryBot.build(:quiz)
      expect(quiz).to be_valid
    end

    it "is invalid without a title(タイトル無しでは不正になる)" do
      quiz = FactoryBot.build(:quiz, title: nil)
      quiz.valid?
      expect(quiz.errors[:title]).to include("を入力してください")
    end

    it "is invalid if a title is more than 20 characters(タイトルが20文字を超えると不正になる)" do
      quiz = FactoryBot.build(:quiz, title: Faker::String.random(21))
      quiz.valid?
      expect(quiz.errors[:title]).to include("は20文字以内で入力してください")
    end

    it "is invalid without a question(問題無しでは不正になる)" do
      quiz = FactoryBot.build(:quiz, question: nil)
      quiz.valid?
      expect(quiz.errors[:question]).to include("を入力してください")
    end

    it "is invalid if a question is more than 400 characters(問題が400文字を超えると不正になる)" do
      quiz = FactoryBot.build(:quiz, question: Faker::String.random(401))
      quiz.valid?
      expect(quiz.errors[:question]).to include("は400文字以内で入力してください")
    end

    it "is invalid without a answer(解説無しでは不正になる)" do
      quiz = FactoryBot.build(:quiz, answer: nil)
      quiz.valid?
      expect(quiz.errors[:answer]).to include("を入力してください")
    end

    it "is invalid if a answer is more than 1000 characters(解説が1000文字を超えると不正になる)" do
      quiz = FactoryBot.build(:quiz, answer: Faker::String.random(1001))
      quiz.valid?
      expect(quiz.errors[:answer]).to include("は1000文字以内で入力してください")
    end
  end
end
