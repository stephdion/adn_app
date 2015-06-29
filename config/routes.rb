AdnApp::Application.routes.draw do

 resources :mails do
      member do
      post 'create'
      post 'new'
      post 'download'
    end
  end
  resources :mail_users

  resources :newsletters do
    collection do
      post 'create'
    end
  end

  resources :eval_types


  resources :participations do
    collection do
      get 'edit_multiple'
      put 'update_multiple'
      get 'edit_archives'
      put 'update_archives'
    end
  end

  resources :positions


  resources :family_members


  resources :test_subcategories


  resources :exercise_subcategories


  resources :test_categories


  resources :exercise_categories


  resources :blessuretypes

  resources :bodysides

  resources :bodyparts

  resources :scat2s

  resources :blessures_bodyparts

  resources :blessure_bodyparts

  resources :comments

  resources :users do
    member do
      get  'change_password'
      patch  'update_password'
      get  'update_temporary'
      patch  'update_temporary'
      get  'update_address'
      put  'update_address'
      get  'scat2s'
      get  'ajax'
      get  'ajax_cancel'
	    get  'ajax_info_physique'
	    put  'ajax_info_physique_edit'
      patch  'ajax_info_physique_edit'
	    get  'ajax_info_general'
	    put  'ajax_info_general_edit'
      patch  'ajax_info_general_edit'
	    get  'ajax_result_team'
	    get  'ajax_result_eval'
      get  'ajax_result_blessure'
      put  'ajax_update_photo'
      patch  'ajax_update_photo'
      get  'video'
      get  'programs'
      get  'report'
    end
    collection do
      get  'addUser'
      post 'addUser_save'
      #get  'activateUser'
      #post 'activateUser'
      post 'search'
      post  'report_delete'
    end
  end
  #resources :users, :collection => ["addUser"]
  resources :vouchers
  resources :roles
  resources :organizations
  resources :sessions, only: [:new, :create, :destroy]
  resources :eval_tests  do
    collection do
      get 'edit_multiple'
      put 'update_multiple'
    end
    member do
      get 'edit_exercise_order'
      put 'update_exercise_order'
    end
  end
  resources :exercises do
    collection do
      get 'edit_multiple'
      put 'update_multiple'
    end
  end
  resources :evaluations do
    member do
      get 'edit_test_order'
      put 'update_test_order'
      get 'edit_exercise_order'
      put 'update_exercise_order'
    end
  end
  resources :programmes
  resources :equipes
  resources :equipe_types
  resources :resultats do
      post 'prise_donnees', on: :collection
      get  'index_detail', on: :collection
      get  'athlete', on: :collection
      get  'programme_corrective', on: :collection
      get  'restart_evaluation', on: :collection
      get  'confirm_delete', on: :collection
  end
  resources :organizations do
      get 'set_current', on: :member
  end
  resources :blessures do
      get 'ajax_get_equipe'
  end
  resources :eval_type


  root to: 'static_pages#home'

  get '/tos', to: 'static_pages#tos'
  get '/disclaimer', to: 'static_pages#disclaimer'
  get '/inscription',  to: 'users#new'
  get '/ouverture',  to: 'sessions#new'
  delete '/fermeture', to: 'sessions#destroy' #, via: :delete
  get '/decouvrir',    to: 'static_pages#decouvrir'
  get '/avantages',   to: 'static_pages#avantages'
  get '/ouverture', to: 'static_pages#ouverture'
  get '/user_registered', to: 'static_pages#user_registered'
  get '/dashboard', to: 'adn#dashboard'
  get '/do_login', to: 'adn#do_login'
  get '/nouveau_test', to: 'eval_tests#new'
  get '/modifier_test', to: 'eval_tests#edit'
  get '/nouvelle_exercise', to: 'exercises#new'
  get '/modifier_exercise', to: 'exercises#edit'
  get '/nouvelle_evaluation', to: 'evaluations#new'
  get '/modifier_evaluation', to: 'evaluations#edit'
  get '/nouveau_programme', to: 'programmes#new'
  get '/modifier_programme', to: 'programmes#edit'
  get '/user_registration/:token',  to: 'users#registration'
  get '/nouvelle_equipe', to: 'equipes#new'
  get '/modifier_equipe', to: 'equipes#edit'
  get '/evaluation_athlete', to: 'resultats#new_athlete'
  get '/evaluation_equipe', to: 'resultats#new_team'
  get '/modifier_resultat', to: 'resultats#edit'
  get '/nouveau_resultat', to: 'resultats#new'
  post '/ajax_team' => 'mails#ajax_team', :via => :post
  post '/ajax_prog' => 'mails#ajax_prog', :via => :post
  post '/mails/create' => 'mails#create', :via => :post
  get 'mails/:id/download/:hash' => 'mails#download', :as => 'download'
  get 'report/:id' => 'users#send_report', :as => 'report'
  #Added by Patrick Martel
  get '/ajax', to: 'ajaxs#index'
  get '/ajax/edit', to: 'ajaxs#edit'
end
