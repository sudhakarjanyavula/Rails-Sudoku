Rails.application.routes.draw do
  namespace :api do
    post 'sudoku', to: 'sudoku#create'
  end
end
