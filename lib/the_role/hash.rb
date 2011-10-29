class Hash
  def the_reset!(default_value= false)
    base= self
    base.each do |key, v|
      if base[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].the_reset!(default_value)
      else
        base[key.to_sym]= default_value
      end
    end
  end

  def the_merge!(hash= nil, default_value= true)
    return self unless hash.is_a?(Hash)
    base= self
    hash.each do |key, v|
      if base[key.to_sym].is_a?(Hash) && hash[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].the_merge!(hash[key.to_sym], default_value)
      else
        base[key.to_sym]= default_value
      end
    end
    base.to_hash
  end
end