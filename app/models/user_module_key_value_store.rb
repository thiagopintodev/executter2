module UserModuleKeyValueStore

  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      after_save :kv_save
    end
  end
  
  module ClassMethods
    def kv_find(id_key)
      return kv_find_id(id_key) unless id_key.is_a? Array
      id_key.map { |id| kv_find_id(id) }
    end

    def kv_find_id(id)
      return nil unless id
      #puts "****** USER '#{id}' from KEY VALUE STORE"
      Rails.cache.read([:model, :user_kv, id]) || (x = find(id) and x.try(:kv_save) and x)
      find(id)
    end
    
  end
  
  def kv_save
    #Marshal throws error when recounting posts
    Rails.cache.write([:model, :user_kv, self.id], self) rescue true
    #puts "****** USER '#{self.id}' saved in KEY VALUE STORE"
    true
  end
  
end
