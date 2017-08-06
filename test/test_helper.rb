$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'media_renamer'

require 'minitest/autorun'
require 'active_support/test_case'
require 'mocha/mini_test'


#ActiveSupport::TestCase.test_order = :random

class ActiveSupport::TestCase

  FILE_PATH = File.expand_path('./../files', __FILE__)

 # test_order = :random

  def load_file(file)
    File.join(FILE_PATH, file)
  end

end

