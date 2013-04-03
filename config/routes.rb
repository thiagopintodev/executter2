Ex2::Application.routes.draw do

  get 'n' => "site#test"

  get "w/:text" => "google_search#search"

  get 'm' => 'mobile#index_posts', :as=>:mobile_root
  scope 'm', :as=>'mobile' do
    get "mentions"  => 'mobile#index_mentions'
    get 'posts'     => 'mobile#index_posts'
    #
    post 'new_post' => 'mobile#index_new_post'
    #authentication
    get  "login" => 'mobile#login'
    post "login" => 'mobile#post_login'
    #get "posts" => 'mobile#index_posts'
    #get "new" => 'mobile#index_post_new'
    #user
    get "u/:username" => 'mobile#user', :as=>:user
    #scope "u/:username" do
    #  get 'posts' => 'mobile#user_posts', :as=>:user_posts
    #end
    #post
    get "p/:id"            => 'mobile#post', :as=>:post
    post 'p/comment_create' => 'mobile#post_comment_create', :as=>:post_comment_create
    #city
    get "c/:label"  => 'mobile#city'
    #scope "c/:label" do
    #  get 'posts' => 'mobile#city_posts'
    #end
  end

  get 'c/:label' => 'cities#show', :as=>:city_label
  resources :cities, :only=>[:show] do
    collection do
      get 'base_search'
    end
  end


  scope 'a' do
    resources :smiles
    resources :user_agents, :only=>:index
    get 'user_sessions' => "user_sessions#index", :as=>'xxx'
    resources :translations, :path=>'t', :only=>[:index, :edit, :update] do
      collection do
        put   '' => 'translations#edit_multiple'
        post  '' => 'translations#update_multiple'
      end
    end
  end

  get 's/who_we_are' => 'site#who_we_are', :as => :s_who
  get 's/suggest' => 'suggestions#new', :as => :s_suggest
  

  resources :suggestions, :except => [:edit, :update]
  resources :user_sessions, :except => [:index, :edit, :update]
  
  get "u/out"    => "user_sessions#destroy",         :as => :out
  get "u/in"     => "user_sessions#new",             :as => :in
  get "u/new"    => redirect("r/new")
  
  get "u/send_password/:base64_key" => "user_sessions#send_password", :as =>:send_password
  get "u/new_password/:username/:token" => "user_sessions#new_password", :as =>:new_password
  post "u/create_password" => "user_sessions#create_password", :as =>:create_password

  get   "r/new"       => "registration#new"
  get   "r/new"       => "registration#new",          :as => :new
  post  "r/new"       => "registration#new_post"
  get   "r/captcha"   => "registration#captcha"
  post  "r/captcha"   => "registration#captcha_post"
  
  get "r/after_register"           => "registration#after_register"
=begin
  get "registration/new_by_profile"
  get "registration/new_by_invitation"
  get "registration/new_by_profile_post"
  get "registration/new_by_invitation_post"
  get "registration/confirm_email"
  get "registration/new_password"
  get "registration/new_password_post"

  #get "/u/new" => "registration#new",       :as => :new
=end
  get  "e/basic"    => "edit#basic"
  put  "e/basic"    => "edit#basic_put"
  get  "e/cities"   => "edit#cities"
  put  "e/cities"   => "edit#cities_put"
  get  "e/username" => "edit#username"
  put  "e/username" => "edit#username_put"
  get  "e/email"    => "edit#email"
  put  "e/email"    => "edit#email_put"
  get  "e/password" => "edit#password"
  put  "e/password" => "edit#password_put"
  
  get  "e/photo" => "edit#photo"
  post "e/photo" => "edit#photo_post"
  
  get  "e/theme" => "edit#theme"
  post "e/theme" => "edit#theme_post"
=begin
  constraints :subdomain => "m" do
    get "s(/:text)"                 => "site#mobile_search"
    get "s/posts/:post_type/:text"  => "site#mobile_posts"
    root :to                        => "home#mobile_index"
  end
=end
  root :to => "home#index"


=begin
#  get 's' => "home#search"
#  get 's/:text' => "home#search"
  get "search/paginated"
  get "search/async_holder"
  get "search/async_ajax"
=end

  get "s(/:text)" => "search#async", :as => :s
  get "s/posts/:post_type/:text" => "search#posts", :as => :search_posts
  get "z(/:text)" => "search#paginated"
  #get "l/:locale" => "site#locale", :as => :l
  get "h/posts_followings_all_latest" => "home#posts_followings_all_latest"
  get "h/posts_followings_all"    => "home#posts_followings_all"
  get "h/posts_followings_status" => "home#posts_followings_status",  :filter => Post::CATEGORY_STATUS
  get "h/posts_followings_image"  => "home#posts_followings_image",   :filter => Post::CATEGORY_IMAGE
  get "h/posts_followings_audio"  => "home#posts_followings_audio",   :filter => Post::CATEGORY_AUDIO
  get "h/posts_followings_other"  => "home#posts_followings_other",   :filter => Post::CATEGORY_OTHER
  get "h/posts_followers"         => "home#posts_followers"
  #get "h/posts_mention"           => "home#posts_mention"
  get 'h/ajax_notifications'           => "home#ajax_notifications"
  get 'h/ajax_news_button'        => "home#ajax_news_button"
  post 'h/invite'           => "home#invite"
  post 'h/mark_notifications_as_read'           => "home#mark_notifications_as_read"
  get 'h/ajax_suggestions_sidebar'  => 'users#ajax_suggestions_sidebar', :as=> :user_ajax_suggestions_sidebar
  
  #get '_/:user_validation_token/post_news/subscribe/:post_id'   => "post_news#subscribe",   :as => "_pn_subs"
  #get '_/:user_validation_token/post_news/unsubscribe/:post_id' => "post_news#unsubscribe", :as => "_pn_unsubs"
  #get 'l/:locale' => "home#change_locale", :as => :set_locale

  #resources :relations
  #resources :likes

  resources :posts, :path => "p", :only => [:show, :destroy] do
    get "ajax_likes"
    post "like"
    get "ajax_comments"
    collection do
      get "generate_notifications"
      post "create_status"
      post "create_image"
      post "create_comment"
      get "ajax_search"
    end
  end
=begin
  devise_for :users do
    get "/u/out" => "devise/sessions#destroy",  :as => :out
    get "/u/new" => "devise/registrations#new", :as => :new
    get "/u/in"  => "devise/sessions#new",      :as => :in
  end
=end
  #match "p" => "users#redirect"
  
  resources :users, :path => "u" do#, :only =>[:show, :index] do #, :index, :update do
    get :ajax_posts_all
    get :ajax_posts_status,  :filter => :status
    get :ajax_posts_image,   :filter => :image


    get :ajax_relations_following,  :filter => :following
    get :ajax_relations_follower,   :filter => :follower
    get :ajax_relations_friend,     :filter => :friend
    
    get :ajax_relations_sidebar_friend,     :filter => :friend
    
    get :likes
    get :ajax_relate_panel
    put :ajax_relate
  end
  get ":username" => "users#show", :as => "profile", :constraints => { :username => User::USERNAME_REGEX }
  scope ":username", :constraints => { :username => User::USERNAME_REGEX } do
    get 'followings'  => "relations#followings",  :as => :username_followings
    get 'followers'   => "relations#followers",   :as => :username_followers
    get 'friends'     => "relations#friends",     :as => :username_friends
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # S of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
