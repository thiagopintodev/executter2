require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "user registration, password too short" do
    user = User.new :first_name=>'Name1',
                    :last_name=>'Name2',
                    :username=>'aaaaa',
                    :email=>'cool@oficina7.com',
                    :password=>'a12'
    assert !user.register_valid?, "shouldn't allow save such short password"
  end
  test "user registration, unique username and email" do
    user = User.new :first_name=>'Name1',
                    :last_name=>'Name2',
                    :username=>'cool',
                    :email=>'cool@oficina7.com',
                    :password=>'aaaaa12'
    assert user.register, user.errors.to_s
    user = User.new :first_name=>'Name1',
                    :last_name=>'Name2',
                    :username=>'cool',
                    :email=>'coolaaaaa@oficina7.com',
                    :password=>'aaaaa12'
    assert !user.register_valid?, "shouldn't allow save username twice"
    user = User.new :first_name=>'Name1',
                    :last_name=>'Name2',
                    :username=>'coolaaaa',
                    :email=>'cool@oficina7.com',
                    :password=>'aaaaa12'
    assert !user.register_valid?, "shouldn't allow save email twice"
  end
end
