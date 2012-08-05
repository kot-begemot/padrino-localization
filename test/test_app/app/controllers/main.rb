TestApp.controller do
  get :index do
    t 'main.index'
  end

  get :welcome do
    t 'main.welcome'
  end
end