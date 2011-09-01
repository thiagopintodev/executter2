class City < ActiveRecord::Base
  belongs_to :city_base
  belongs_to :city
  
  has_many :living_users, :class_name => "User", :foreign_key => 'living_city_id'
  has_many :born_users,   :class_name => "User", :foreign_key => 'born_city_id'
  
  validates :label, :uniqueness=>true
  LABEL_REGEX = /[a-z-]{2,}/i

  def label_sign
    "$#{label}"
  end

  alias :l_ :label_sign
  
  def image_url
    'http://roadtickle.com/img/environment/6-amazing-future-city-concepts/regatta-jakarta.jpg'
  end

  class << self
    #CUSTOM METHODS
    def create_many_from_city_base(cb)
      #ensures cb is a model
      cb = CityBase.find(cb) unless cb.is_a? CityBase

      #EXAMPLE TO UNDERSTAND METHOD: trying to create new anapolis-br, but anapolis-us already exists
      
      #first check for 'anapolis'
      city_without_country = City.where(:label=>cb.label).first
      if city_without_country.nil?
        #if there is no 'anapolis' creates both MASTER and SLAVE
        #anapolis
        city_without_country  = cb.cities.create!(:name=>cb.full_name, :country=>cb.country, :label=>cb.label)
        #anapolis-br
        cb.cities.create!(:name=>cb.full_name, :country=>cb.country, :label=>cb.label_country, :city_id=>city_without_country.id)
        #anapolis
        return city_without_country
      else
        #if there is 'anapolis', finds or creates 'anapolis-br', without a master
        return city_without_country if cb.country == city_without_country.country
        #anapolis-br
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
    
    def search(words)
      query = City.where('city_id IS NULL').limit(10).order('length(label)').select([:name, :id])
      words.downcase.split(' ').each do |word|
        query = query.where("label LIKE :w", :w=>"%#{word}%")
      end
      query.map { |c| {:name=>c.name, :id=>c.id} }
    end
  end
  def register_citizen(user)
    user.update_attributes :born_city_id   => self.id,
                           :living_city_id => self.id
  end
  
  
end
