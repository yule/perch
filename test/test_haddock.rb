require "test/unit"
require "haddock"

class TestHaddock < Test::Unit::TestCase
  include Haddock

  def test_generates_password
    password = Password.generate
    assert_instance_of String, password
    assert_equal Password::DEFAULT, password.length
  end

  def test_password_format
    symbols = Password.send :class_variable_get, :@@delimiters
    symbols = "[#{Regexp.quote symbols}]"
    pattern = /^[a-z]+[0-9]+#{symbols}{1}[a-z]+/i
    assert_match(pattern, Password.generate)
  end

  def test_generates_variable_password
    assert_equal Password.generate(18).length, 18
  end

  def test_accepts_alternate_wordlist
    Password.diction = path = File.dirname(__FILE__) + "/names.txt"
    pattern = Regexp.new File.read(path).split.join("|")
    assert_match(pattern, Password.generate(14))
  ensure
    Password.diction = "/usr/share/dict/words"
  end

  def test_accepts_alternate_symbols_list
    Password.delimiters = "X"
    assert_equal "X", Password.send(:random_delimiter)
  end

  def test_fail_on_too_short
    assert_raise Password::LengthError do
      Password.generate(Password::MINIMUM - 1)
    end
  end

  def test_fail_on_too_long
    assert_raise Password::LengthError do
      Password.generate(Password::MAXIMUM + 1)
    end
  end

  def test_fail_on_invalid
    assert_raise Password::LengthError do
      Password.generate("invalid")
    end
  end

  def test_fail_on_invalid_path
    assert_raise Password::NoWordsError do
      Password.diction = "invalid/path"
    end
  end

  def test_fail_on_nil_path
    assert_raise Password::NoWordsError do
      Password.diction = nil
    end
  end

  def test_allows_non_delimiters
    Password.delimiters = "#"
    password = Password.generate(10, {:use_delimeter=>false})
    assert_no_match /\#/, password
  end

  def test_allows_non_numbers
    password = Password.generate(10, {:use_number=>false})
    assert_no_match /\d/, password
  end 

  def test_length_persists_without_numbers_or_delimeters
    password = Password.generate(10, {:use_number=>false, :use_delimeter=>false})
    assert_equal 10, password.length
  end


end
