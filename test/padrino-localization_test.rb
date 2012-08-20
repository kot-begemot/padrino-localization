require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class MainControllerTest < Test::Unit::TestCase
  
  def setup
    Capybara.app = app
  end

  def test_root_without_locale
    visit "/"

    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: en.main.index"
  end

  def test_root_with_locale_1
    visit "/en"
    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: en.main.index"

    visit "/en/"
    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: en.main.index"
  end

  def test_root_with_locale_2
    visit "/ru"
    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: ru.main.index"

    visit "/ru/"
    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: ru.main.index"
  end

  def test_welcome_with_locale_1
    visit "/en/welcome"
    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: en.main.welcome"
  end

  def test_welcome_with_locale_2
    visit "/ru/welcome"
    assert_equal 200, page.status_code
    assert page.has_content? "translation missing: ru.main.welcome"
  end

  def test_wrong_page_without_locale
    visit "/test"
    assert_equal 404, page.status_code
  end

  def test_wrong_page_with_locale
    visit "/en/test"
    assert_equal 404, page.status_code
  end

  def test_user_controller_index
    visit "/en/user"
    assert page.has_content?("translation missing: en.user.index"), "Page body was: #{page.body}"

    visit "/user"
    assert page.has_content?("translation missing: en.user.index"), "Page body was: #{page.body}"

    visit "/ru/user"
    assert page.has_content? "translation missing: ru.user.index"
  end

  def test_url_test_no_locale
    assert_equal '/', TestApp.url(:index)
  end

  def test_url_test_with_locale
    assert_equal '/ru/', TestApp.url_with_locale(:index, :locale => "ru")
    assert_equal '/ru/', TestApp.url(:index, :locale => "ru")
    ::I18n.locale = :ru
    assert_equal '/ru/', TestApp.url(:index)
    assert_equal '/', TestApp.url(:index, :locale => "en")
    ::I18n.locale = ::I18n.default_locale
  end

  def test_url_is_not_registered
    assert_equal '/', TestApp.url_with_locale(:index, :locale => "sdv")
    ::I18n.locale = :ru
    assert_equal '/ru/', TestApp.url(:index, :locale => "sdfsa")
    ::I18n.locale = ::I18n.default_locale
  end
end