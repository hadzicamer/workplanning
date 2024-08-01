Rails.application.routes.draw do
  resources :workers do
    resources :shifts
  end
end
