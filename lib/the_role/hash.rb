class Hash
  def the_reset!(default_value = false)
    base = self
    base.each do |key, value|
      if base[key].is_a?(Hash)
        base[key] = base[key].the_reset!(default_value)
      else
        base[key] = default_value
      end
    end
  end

  def the_merge! hash
    base = self
    hash.each do |key, value|
      if base[key].is_a?(Hash) && hash[key].is_a?(Hash)
        base[key] = base[key].the_merge! hash[key]
      else
        base[key] = hash[key]
      end
    end
    base
  end
end