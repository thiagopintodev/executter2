class Translation < ActiveRecord::Base

  validate :unique_key_per_locale
  def unique_key_per_locale
    if Translation.exists?(["locale=? AND key=? AND id<>?",locale,key,id])
      errors.add(:key, "there's already a key '#{key}' for the language '#{locale}'")
    end
  end

  class << self
    def get_all_cache
      Rails.cache.fetch('translations_all_attributes') { all.map &:attributes }
    end
    def clear_cache
      Rails.cache.delete('translations_all_attributes')
    end
    def t(key, args={})
      l = I18n.locale.to_s
      s = nil
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
    end
    def available_locales
      select("DISTINCT(locale)").map &:locale
    end
  end

end
