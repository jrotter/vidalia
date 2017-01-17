require 'minitest/autorun'
require 'test_helper'

class VidaliaTest < Minitest::Test


  def test_vidalia_set_and_use_logroutine_nohash
    @tempval = "cat"
    myroutine = lambda { |instring,opts|
      @tempval += " #{instring}"
    }
    Vidalia.set_logroutine &myroutine
    Vidalia.log "dog"
    assert @tempval == "cat dog"
  end

  def test_vidalia_set_and_use_logroutine_hash
    @tempval = nil
    myroutine = lambda { |instring,opts|
      @tempval = "#{instring} #{opts[:data]}"
    }
    Vidalia.set_logroutine &myroutine
    Vidalia.log("cat",:stuff => "hello",:things => "goodbye",:data => "hat")
    assert @tempval == "cat hat"
  end

end
