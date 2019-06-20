Rails.application.routes.draw do

  root to: "home#index"

  namespace :api do
    namespace :v1 do

      resources :quizzes do
        resources :queries do
          member do
            post :do_query
          end
        end
        
        member do
          post :solve
          patch :update_quiz_status
        end

        resources :choices, only: [:index, :create]
      end

      resources :users do
        collection do
          get :show_mypage
        end
      end

      resources :queries

    end
  end

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy

end
