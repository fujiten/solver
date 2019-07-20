require 'rails_helper'

RSpec.describe "Quizzes", type: :request do

  context "ログイン不要のAPI" do

    describe "問題一覧の取得（GET api/v1/quizzes）" do

      it "ステータスコード200を返す(returns 200)" do
        get api_v1_quizzes_path

        expect(response).to have_http_status(200)
      end

      it "author,avatarを含むクイズの配列を返す(returns published quizzes(include author and avatar)" do
        FactoryBot.create_list(:quiz, 10, published: 1)
        get api_v1_quizzes_path
        json = JSON.parse(response.body)

        expect(json.length).to eq(10)
        expect(json[0]["author"]).to be_truthy
        expect(json[0]["avatar"]).to be_truthy
      end

    end
    
    describe "特定の問題の取得(GET api/v1/quizzes/:id)" do
  
      it "200と特定のクイズを返す(returns 200 and a specfic quiz" do
        quiz = FactoryBot.create(:quiz)
        get api_v1_quiz_path(quiz)
        json = JSON.parse(response.body)
  
        expect(response).to have_http_status(200)
        expect(json["quiz"]["title"]).to eq(quiz.title)
      end
  
    end

  end


  context "ログインの必要なAPI" do
    
    let(:quiz_params) {
      { title:           Faker::Lorem.word,
        question:        Faker::Lorem.sentence,
        answer:          Faker::Lorem.sentence,
        image:           'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQI12NgYAAAAAMAASDVlMcAAAAASUVORK5CYII=' } }

    def sign_in(user)
      post signin_path, params: { email: user.email, password: user.password }
      csrf = JSON.parse(response.body)["csrf"]
      access_key = response.headers["Set-Cookie"]
      tokens = {csrf: csrf, access_key: access_key}
    end

    describe "新規投稿(POST api/v1/quizzes)" do
      
      it "ログイン中に正しいparamsを送れば新たなクイズを作成し、そのクイズを返す(create a new quiz and return the quiz with valid params" do
        user = FactoryBot.create(:user)
        tokens = sign_in(user)

        expect do
          post api_v1_quizzes_path, params: { quiz: quiz_params }, 
                                    headers: { "Cookie" => tokens[:access_key],
                                              "X-CSRF-TOKEN" => tokens[:csrf] }
        end.to change(Quiz, :count).by(1)

        json = JSON.parse(response.body)

        expect(response).to have_http_status(201)
        expect(json["title"]).to eq(quiz_params[:title])
      end

      it "ログイン中でも不正なparamsではクイズを作成しない(doesn't create a new quiz with invalid params" do
        user = FactoryBot.create(:user)
        tokens = sign_in(user)

        quiz_params[:title] = nil
        post api_v1_quizzes_path, params: { quiz: quiz_params }, 
                                  headers: { "Cookie" => tokens[:access_key],
                                             "X-CSRF-TOKEN" => tokens[:csrf] }

        json = JSON.parse(response.body)

        expect(response).to have_http_status(422)
      end

      it "ログイン無しではクイズを作成できない(can't create a new quiz without signing in)" do
        user = FactoryBot.create(:user)
        post api_v1_quizzes_path, params: { quiz: quiz_params }
        json = JSON.parse(response.body)

        expect(response).to have_http_status(401)
      end
    end

    describe "編集(PATCH api/v1/quizzes/:id)" do

      it "ログイン中正しいparamsを送れば、そのクイズを編集し返答する。(update a quiz and return the quiz with valid prarams)" do
        user = FactoryBot.create(:user)
        db_quiz = FactoryBot.create(:quiz, user_id: user.id)
        tokens = sign_in(user)

        expect do
          patch api_v1_quiz_path(db_quiz), params: { quiz: quiz_params }, 
                                           headers: { "Cookie" => tokens[:access_key],
                                                      "X-CSRF-TOKEN" => tokens[:csrf] }
        end.to change { Quiz.find(db_quiz.id).title }.from(db_quiz.title).to(quiz_params[:title])
        expect(response).to have_http_status(200)
      end

      it "ログイン中、不正なparamsではクイズを編集できない" do
        user = FactoryBot.create(:user)
        db_quiz = FactoryBot.create(:quiz, user_id: user.id)
        tokens = sign_in(user)
        quiz_params[:title] = nil

        patch api_v1_quiz_path(db_quiz), params: { quiz: quiz_params }, 
                                         headers: { "Cookie" => tokens[:access_key],
                                                    "X-CSRF-TOKEN" => tokens[:csrf] }
        expect(response).to have_http_status(422)

      end

      it "ログイン中、他人のクイズは編集できない" do
        user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        other_db_quiz = FactoryBot.create(:quiz, user_id: other_user.id)
        tokens = sign_in(user)

        expect do
          patch api_v1_quiz_path(other_db_quiz), params: { quiz: quiz_params }, 
          headers: { "Cookie" => tokens[:access_key],
                    "X-CSRF-TOKEN" => tokens[:csrf] }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "ログイン無しではクイズを編集できない" do
        user = FactoryBot.create(:user)
        db_quiz = FactoryBot.create(:quiz, user_id: user.id)

        patch api_v1_quiz_path(db_quiz), params: { quiz: quiz_params }

        expect(response).to have_http_status(401)
      end
    end

    describe "新規投稿(DELETE api/v1/quizzes/:id)" do

      it "ログイン中、特定のクイズを削除する。" do
        user = FactoryBot.create(:user)
        db_quiz = FactoryBot.create(:quiz, user_id: user.id)
        tokens = sign_in(user)

        expect do
          delete api_v1_quiz_path(db_quiz), headers: { "Cookie" => tokens[:access_key],
                                                       "X-CSRF-TOKEN" => tokens[:csrf] }
        end.to change(Quiz, :count).by(-1)
        expect(response).to have_http_status(200)
      end

      it "ログイン中、他人のクイズは削除できない" do
        user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        other_db_quiz = FactoryBot.create(:quiz, user_id: other_user.id)
        tokens = sign_in(user)

        expect do
          delete api_v1_quiz_path(other_db_quiz), headers: { "Cookie" => tokens[:access_key],
                                                             "X-CSRF-TOKEN" => tokens[:csrf] }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "ログイン無しではクイズを削除できない" do
        user = FactoryBot.create(:user)
        db_quiz = FactoryBot.create(:quiz, user_id: user.id)

        delete api_v1_quiz_path(db_quiz)

        expect(response).to have_http_status(401)
      end

    end
  end
end
