Dayable::Application.routes.draw do

  devise_for :users,
    :path => '/',
    :path_names => {
        :sign_in  => 'signin',
        :sign_out => 'signout',
        :sign_up => 'signup'
  }
  resources :users
  resources :tokens, :only => [:create, :destroy]

  resources :habits
  resources :chains
  
  root :to => 'habits#index'

  get 'about' => 'home#about'

end
