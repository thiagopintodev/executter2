class City < ActiveRecord::Base
  belongs_to :city_base
  belongs_to :city
  has_many :users
  
  validates :label, :uniqueness=>true

  def label_sign
    "$#{label}"
  end

  alias :l_ :label_sign
  

  class << self
    #CUSTOM METHODS
    def create_many_from_city_base(cb)
      #ensures cb is a model
      cb = CityBase.find(cb) unless cb.is_a? CityBase

      #EXAMPLE TO UNDERSTAND METHOD: trying to create new anapolis-br, but anapolis-us already exists
      
      #first check for 'anapolis'
      city_without_country = City.where(:label=>cb.label).first
      if !city_without_country
        #if there is no 'anapolis' creates both MASTER and SLAVE
        city_without_country  = cb.cities.create!(:name=>cb.full_name, :country=>cb.country, :label=>cb.label)
        city_with_country     = cb.cities.create!(:name=>cb.full_name, :country=>cb.country, :label=>cb.label_country, :city_id=>city_without_country.id)
        return city_without_country
      else
        #if there is 'anapolis', finds or creates 'anapolis-br', without a master
        return City.where(:label=>cb.label_country).first || cb.cities.create!(:label=>cb.label, :name=>cb.full_name, :country=>cb.country)
      end
      #returns MASTER if MASTER-SLAVE, or SLAVE-only if MASTER was already taken for another country
    end
    
    def findi(param_id)
      where(:id=>param_id).first
    end
    def findl(param_label)
      where(:label => param_label.downcase.delete("$")).first
    end
  end
  def register_citizen(user)
    user.update_attribute(:city_id, self.id)
  end
  
  
end
