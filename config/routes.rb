Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resource :session, only: :create

  resource :shopping_items
  delete 'shopping_items/clear_all' => 'shopping_items#delete_all'
  delete 'shopping_items/clear_checked_items' => 'shopping_items#delete_checked_items'

  resource :price_control_items
  delete 'price_control_items/clear_all' => 'price_control_items#delete_all'
end
