require 'test_helper'

class RelationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "simple following unfollowing" do
    Relation.delete_all
    u1, u2 = User.first, User.last
    assert u1.relate(u2, :follow)
    assert u1.followings(true).count == 1
    assert u2.followers(true).count == 1
    assert u1.friends(true).count == 0
    
    assert u1.relate(u2, :unfollow)
    assert u1.followings.count == 0
    assert u2.followers.count == 0
    assert u1.friends.count == 0
  end
  
  test "follow and friends" do
    Relation.delete_all
    u1, u2 = User.first, User.last
    assert u1.relate(u2, :follow)
    assert u1.followings(true).count == 1
    assert u2.followers(true).count == 1
    assert u1.friends(true).count == 0
    
    assert u2.relate(u1, :follow)
    assert u1.followings(true).count == 1
    assert u2.followers(true).count == 1
    assert u1.friends(true).count == 1
    assert u2.friends(true).count == 1
  end
  test "cant follow one self" do
    u1, u2 = User.first, User.last
    assert !u2.relate(u2, :follow)
  end
end
