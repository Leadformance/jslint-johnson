require File.expand_path('helper', File.dirname(__FILE__))
require 'erb'

class TestCli < Test::Unit::TestCase
  Executable = File.expand_path("../bin/jslint-johnson", File.dirname(__FILE__))
  
  def test_executable_exists
    assert File.exist?(Executable)
  end

  def test_empty_args
    result = `#{Executable}`

    assert_equal "usage: jslint-johnson FILES\n", result
    assert_equal false, $?.success?
  end

  def test_valid
    result = %x{#{Executable} "#{js_filename "valid"}"}

    assert $?.success?
    assert_equal erb_fixture("cli-valid-expected-output"), result
  end

  def test_invalid
    result = %x{#{Executable} "#{js_filename "invalid"}"}

    assert_equal false, $?.success?
    assert_equal erb_fixture("cli-invalid-expected-output"), result
  end

  def test_suite
    defined_globals = js_filename("defined-globals")
    defined_options = js_filename("defined-options")
    invalid = js_filename("invalid")
    valid = js_filename("valid")

    result = %x{#{Executable} "#{defined_globals}" "#{defined_options}" "#{invalid}" "#{valid}"}

    assert_equal false, $?.success?
    assert_equal erb_fixture("cli-suite-expected-output"), result
  end

end