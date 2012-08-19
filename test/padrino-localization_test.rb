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

  def test_user_show_with_params
    visit "/en/user/show/10"
    assert page.has_content? "ID is 10"

    visit "/ru/user/show/10"
    assert page.has_content?("ID is 10"), "Page body was: #{page.body}"

    visit "/user/show/10"
    assert page.has_content? "ID is 10"
  end
end