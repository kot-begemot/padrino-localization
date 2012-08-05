class TestApp < Padrino::Application
  register Padrino::Helpers
  register Padrino::Localization::Urls

  error 404 do
    '404 Error'
  end
end