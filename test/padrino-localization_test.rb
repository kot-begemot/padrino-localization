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
end