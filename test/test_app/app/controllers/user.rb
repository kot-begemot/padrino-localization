TestApp.controller :user do
  get :index do
    t 'user.index'
  end

  get :show,  :with => [:id] do
    "ID is %{id}" % { :id => params[:id]}
  end
end