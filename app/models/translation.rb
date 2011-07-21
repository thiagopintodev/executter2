class Translation < ActiveRecord::Base

  validate :unique_key_per_locale
  def unique_key_per_locale
    if Translation.exists?(["locale=? AND key=? AND id<>?",locale,key,id])
      errors.add(:key, "there's already a key '#{key}' for the language '#{locale}'")
    end
  end

  class << self
    def get_all_cache
      Rails.cache.read('translations_all_attributes') || set_all_cache(all.map &:attributes)
      #Rails.cache.read('translations_all') || set_all_cached(all)
    end
    def set_all_cache(v)
      Rails.cache.write('translations_all_attributes', v) and v
    end
    def clear_cache
      Rails.cache.write('translations_all_attributes', nil)
    end
    def fill_cache
      set_all_cache(all) and true
    end
    def t(key, args={})
      #where(:locale=>I18n.locale, :key=>key).first.try :text
      l = I18n.locale.to_s
      s = nil
      fill_cache if get_all_cache.size == 0
      get_all_cache.each do |t1|
        if t1['locale'] == l and t1['key'] == key
          s = t1['text']
          break
        end
      end
      if s
        args.each { |k,v| s = s.gsub("%{#{k}}", v.to_s) }
      end
      s
      #get_all_cache.each { |t1| return t1.text if t1.locale == l and t1.key == key }
      #all.each { |t1| return t1.text if t1.locale == l and t1.key == key }
    end
    def available_locales
      select("DISTINCT(locale)").map &:locale
    end
  end

end
