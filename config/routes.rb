Dayable::Application.routes.draw do

  devise_for :users,
    :path => '/',
    :path_names => {
        :sign_in  => 'signin',
        :sign_out => 'signout',
        :sign_up => 'signup'
  }
  resources :users

  resources :habits
  root :to => 'habits#index'
  

end
