Rails.application.routes.draw do

  root 'welcome#index'

  resources :students
  resources :courses
  resources :classrooms

end
