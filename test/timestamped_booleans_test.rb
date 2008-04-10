require "#{File.dirname(__FILE__)}/../../../../test/test_helper"

class TimestampedBooleansTestARModel < ActiveRecord::Base
  attr_accessor :published_at
  timestamped_boolean :published_at
end

# Doesn't actually need to inherit from ActiveRecord::Base for most of our
# tests.
class TimestampedBooleansTestModel
  include Rubaidh::TimestampedBooleans

  attr_accessor :published_at
  timestamped_boolean :published_at
end

class Time
  class << self
    def now
      at(0)
    end
  end
end

class TimestampedBooleansTest < Test::Unit::TestCase

  def test_should_have_class_methods_on_active_record_base
    assert ActiveRecord::Base.methods.include?("timestamped_boolean")
    assert ActiveRecord::Base.methods.include?("timestamped_booleans")
  end

  def test_should_have_additional_instance_methods_on_model
    assert TimestampedBooleansTestARModel.instance_methods.include?("published?")
    assert TimestampedBooleansTestARModel.instance_methods.include?("published=")
  end

  # Just double check that my mocking is working. :-)
  def test_time_now_is_being_mocked_correctly
    assert_equal Time.at(0), Time.now
  end

  def test_published_should_initially_be_false
    model = TimestampedBooleansTestModel.new
    assert_equal false, model.published?
  end

  def test_published_can_be_set_to_true
    model = TimestampedBooleansTestModel.new
    model.published = true
    assert_equal true, model.published?
  end

  def test_setting_published_to_true_updates_published_at_to_time_now
    model = TimestampedBooleansTestModel.new
    model.published = true
    assert_equal Time.now, model.published_at
  end

  # FIXME: Can't test this unless we inherit from AR::Base and that doesn't
  # work because the table doesn't exist.
  # def test_setting_published_to_true_on_the_initializer_works_too
  # model = TimestampedBooleansTestModel.new :published => true
  # assert_equal Time.now, model.published_at
  # end

  def test_setting_published_to_false_clears_published_at
    model = TimestampedBooleansTestModel.new
    model.published = true
    assert_equal Time.now, model.published_at
    model.published = false
    assert_nil model.published_at
  end
end
