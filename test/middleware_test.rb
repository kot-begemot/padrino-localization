require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class MiddlewareTest < Test::Unit::TestCase

  def setup
    @middleware = Padrino::Localization::Middleware.new nil, [:en,:ru]
  end

  def test_root_matching_without_locale
    assert_nil @middleware.send :locale_from_url, '/'
    assert_equal ::I18n.default_locale, ::I18n.locale
  end

  def test_set_correct_locale
    assert_equal 'en', @middleware.send(:locale_from_url, '/en')
    assert_equal :en, @middleware.send(:set_locale)
    assert_equal :en, ::I18n.locale

    @middleware.send(:unset_locale)
    assert_equal ::I18n.default_locale, ::I18n.locale

    assert_equal 'ru', @middleware.send(:locale_from_url, '/ru')
    assert_equal :ru, @middleware.send(:set_locale)
    assert_equal :ru, ::I18n.locale

    @middleware.send(:unset_locale)
    assert_equal ::I18n.default_locale, ::I18n.locale
  end

  def test_set_incorrect_locale
    assert_equal nil, @middleware.send(:locale_from_url, '/test')
    assert_equal nil, @middleware.send(:set_locale)
    assert_equal ::I18n.default_locale, ::I18n.locale
  end
end