require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "post basic validations" do
    #assert true
    assert Post.new().invalid?, "post requires at least user_id and body"
    assert Post.new(:user_id=>1).invalid?, "post requires at least user_id and body"
    assert Post.new(:user_id=>1,:body=>"body of test").valid?, "post requires only user_id and body"
    
    #assert Post.new(:user_id=>1,:body=>"body of test", :is_comment=>true).invalid?
    #assert Post.new(:user_id=>1,:body=>"body of test", :post_id=>1).invalid?
    #assert Post.new(:user_id=>1,:body=>"body of test", :is_comment=>true, :post_id=>1).valid?
    
  end
  
  test "simple post creation in a correct way" do
    #assert true
    #user = User.first
    #assert p = user.posts.create!(:body=>"body of test")
  end
  
  test "simple comment creation in a correct way" do
    #assert true
    #user = User.first
    #assert p = user.posts.create!(:user_id=>1, :body=>"body of test")
    #assert p2 = p.posts.create!(:user_id=>1, :body=>"body of test", :is_comment=>true, :is_repost=>false)
    #assert p2 = p.posts.create!(:user_id=>1, :body=>"body of test", :is_comment=>true, :is_repost=>true)
    
    #assert p2 = p.create_post(:body=>"body of test", :is_comment=>true)
  end
end
