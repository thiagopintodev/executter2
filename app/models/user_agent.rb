class UserAgent < ActiveRecord::Base

  validates :key, :presence => true, :uniqueness => true
  
  def self.note(key)
    create(:key=>key) if update_all("count=count+1", {:key=>key}) == 0
  end

end
