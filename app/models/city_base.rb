class CityBase < ActiveRecord::Base

  has_many :cities

  def self.search(words)
    query = CityBase.limit(10).order('length(label)').select([:name, :country, :id])
    words.downcase.split(' ').each do |word|
      query = query.where("data LIKE :w", :w=>"%#{word}%")
    end
    query.map { |cb| {:name=>cb.full_name, :id=>cb.id} }
  end

  def full_name
    "#{country.upcase}, #{name}"
  end
  
  def label_country
    "#{label}-#{country}"
  end

  

  validates :data, :uniqueness=>true

  before_validation do
    self.data ||= "#{country} #{name} #{label}".downcase
  end

  def self.create_from_csv_line(line)
    return false unless line
    a = line.strip.split(',')
    #, :region_code=>self.region_code
    #Country,City,AccentCity,Region,Population,Latitude,Longitude
    #=> ["br", "10 de novembro", "10 de Novembro", "26", "", "-27.0333333", "-50.9333333"]
    b = CityBase.new  :country      => a[0],
                      :label        => a[1].downcase.gsub(/\W/,'-'),
                      :name         => a[2],
                      :region       => a[3],
                      :population   => a[4],
                      :lat          => a[5],
                      :lng          => a[6]
    b.save
  end

end
