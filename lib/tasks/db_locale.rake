#es.activerecord.errors.models.user.attributes.email.taken
namespace :db do
namespace :locale do

  def recursive_hash(parent_tkey, hash)
    tkey = []
    result = {}
    hash.each do |key, child|
      tkey = parent_tkey+[key]
      if child.is_a? Hash
        recursive_hash(tkey, child).each { |rk, rv| result[rk] = rv }
        #puts "\n#{s} is a hash\n"
      elsif child.is_a? String
        tkeys = tkey.join('.')
        #puts "'#{tkeys}' -> '#{child}'\n"
        result[tkeys] = child
      end
    end
    result
  end

  def create_locale(locale)
    hash = YAML::load_file('config/db_locale.yml')
    result = recursive_hash([], hash)
    result.each do |key, text|
      unless Translation.exists? :locale=>locale, :key=>key
        Translation.create :locale=>locale, :key=>key, :text=>text
        puts "[#{locale}] #{key}: '#{text}'\n"
      end
    end
    T.clear_cache
    puts "total: #{result.size}\n\n"
  end
  
  #
  
  task :delete_all => :environment do
    Translation.delete_all
    puts "all locales deleted"
  end
  
  task :check_all => :environment do
    #(Translation.available_locales || I18n.available_locales).each do |locale|
    I18n.available_locales.each do |locale|
      create_locale(locale)
      puts "all keys to locale '#{locale}' have been checked :)"
    end
      puts "all keys to all locales have been checked :)"
      T.clear_cache
  end

  #

  desc "creates a new locale (or reviews an existing) from dblocale.yml file"
  task :check, :locale, :needs => :environment do |t, args|
    locale = args[:locale] || 'en'
    create_locale(locale)
    puts "all keys to locale '#{locale}' have been checked :)"
  end

  desc "resets all languages and creates :en from dblocale.yml file"
  task :reset => [:delete_all, :check]
end
end

desc "checks all available locales"
task :'db:locale' => 'db:locale:check_all'

desc "migrates, seeds default and seeds locales"
task :'db:my' => ['db:migrate', 'db:seed', 'db:locale']
