class City < ActiveRecord::Base
  belongs_to :city_base
  belongs_to :city

  #validates :city_base, :associated=>true
=begin

br-goiania    find or create
goiania       find or create :city=>city

user.city = city

=end
  
end
