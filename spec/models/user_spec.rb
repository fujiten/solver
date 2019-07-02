require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
  
    it "is valid with a name, email, and pasword(名前、メールアドレス、パスワードがあれば正当)" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  
    it "is invalid without a name(名前無しでは不正になる)" do
      user = FactoryBot.build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end
  
    it "is invalid without an email address(メールアドレス無しでは不正になる)" do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "is invalid with INVALID MAIL ADDRESS(不正なメールアドレスでは不正になる)" do
      user1 = FactoryBot.build(:user, email: "123@123")
      user2 = FactoryBot.build(:user, email: "example.com")
      user3 = FactoryBot.build(:user, email: "example@com")

      invalid_users = [user1, user2, user3]
      invalid_users.each do |user| 
        user.valid?
        expect(user.errors[:email]).to include("が不正な値です")
      end
    end
  
    it "is invalid with a duplicate email address(既に登録済みのメールアドレスでは不正になる)" do
      user = FactoryBot.create(:user)
      another_user = FactoryBot.build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end
  
    it "is invalid without a password(パスワード無しでは不正になる)" do
      user = FactoryBot.build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "is invalid if password is less than 5 characters(パスワードが5文字以下だと不正になる)" do
      user = FactoryBot.build(:user, password: "12345")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "is invalid if password is more than 30 characters(パスワードが30文字以上だと不正になる)" do
      user = FactoryBot.build(:user, password: "abcdefghijklmnopqustuvwxyzABCDEFGHIJK")
      user.valid?
      expect(user.errors[:password]).to include("は30文字以内で入力してください")
    end
  end
end
