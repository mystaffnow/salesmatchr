Rails.application.routes.draw do
  get 'home/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :candidate_job_actions

  resources :jobs do
    member do
      post :email_match_candidates
    end
  end

  resources :educations, only: [:destroy]

  resources :experiences, only: [:destroy]

  resources :job_candidates

  devise_for :employers, :controllers => { :sessions => "employers/sessions", :registrations => "employers/registrations"}
  devise_for :candidates, :controllers => { :sessions => "candidates/sessions", :omniauth_callbacks => "candidates/omniauth_callbacks", :registrations => "candidates/registrations"}

  # Routes for candidates
  get 'candidates/account' => 'candidates#account'
  put 'candidates/account' => 'candidates#update'
  get 'candidates/archetype' => 'candidates#archetype'
  get 'candidates/archetype_result' => 'candidates#archetype_result'
  put 'candidates/archetype' => 'candidates#update_archetype'
  get 'candidates/profile/:id' => 'candidates#profile', as: 'candidates_profile'
  get 'candidates/incognito/:is_incognito' => 'candidates#incognito'
  get 'candidates/subscription' => 'candidates#subscription'

  # Routes for candidate_job_actions
  get 'candidates/jobs_saved' => 'candidate_job_actions#candidate_job_saved', as: 'candidate_job_saved'
  get 'candidates/jobs_viewed' => 'candidate_job_actions#candidate_job_viewed', as: 'candidate_job_viewed'
  get 'candidates/candidate_matches' => 'candidate_job_actions#candidate_matches', as: 'candidate_matches'
  post 'candidates/candidate_save_job/:job_id' => 'candidate_job_actions#candidate_save_job', as: 'candidate_save_job'

  # Routes for job_candidates
  get 'my_jobs' => 'job_candidates#index'
  get 'job_receipt/:id' => 'job_candidates#receipt', as: 'job_receipt'
  post 'shortlist_candidate/:job_id/:candidate_id' => 'job_candidates#shortlist_candidate', as: 'shortlist_candidate'
  post 'remove_candidate/:job_id/:candidate_id' => 'job_candidates#remove_candidate', as: 'remove_candidate'
  put 'withdraw/:id' => 'job_candidates#withdraw', as: 'withdraw_candidate'
  put 'accept_candidate/:id' => 'job_candidates#accept_candidate', as: 'accept_candidate'
  get 'job_candidates/:id/apply' => "job_candidates#apply", as: "create_job_candidates"

  # Routes for employers
  get 'employers/public/:id' => 'employers#public', as: 'employers_public'
  get 'employers/account' => 'employers#account'
  put 'employers/account' => 'employers#update'
  get 'employers/profile' => 'employers#profile'
  
  # Routes for jobs
  get 'employer_jobs' => 'jobs#employer_index', as: 'employer_jobs'
  get 'employer_jobs/archive' => 'jobs#employer_archive', as: 'employer_archive_jobs'
  get 'employer_jobs/:id' => 'jobs#employer_show', as: 'employer_show'
  get 'employer_job_actions/:id' => 'jobs#employer_show_actions', as: 'employer_show_actions'
  get 'employer_job_matches/:id' => 'jobs#employer_show_matches', as: 'employer_show_matches'
  get 'employer_job_shortlists/:id' => 'jobs#employer_show_shortlists', as: 'employer_show_shortlists'
  get 'employer_job_remove/:id' => 'jobs#employer_show_remove', as: 'employer_show_remove'
  get 'employer_job_checkout/:id' => 'jobs#employer_job_checkout', as: 'employer_job_checkout'
  put 'inactivate_job/:id' => 'jobs#inactivate_job', as: 'inactivate_job'
  get 'jobs/:id/send_candidate_intro/:candidate_id' => 'jobs#send_intro', as: 'send_job_candidate_intro'

  # Routes for pages
  root to: 'pages#index'
  get 'contact' => 'pages#contact'
  get 'about' => 'pages#about'
  get 'hustlers' => 'pages#hustlers'
  get 'hirers_faq' => 'pages#hirers_faq'
  get 'hustlers_faq' => 'pages#hustlers_faq'
  get 'privacy_policy' => 'pages#privacy_policy'
  get 'pages/index'
  get 'pages/hustlers'
  get 'pages/about'
  get 'pages/contact'
  get 'pages/hirers_faq'
  get 'pages/hustlers_faq'
  get 'pages/privacy_policy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
