class Hash
  # deep_reset!
  # deep_merge!
  def deep_reset!(default_value = false)
    base = self
    base.each do |key, value|
      base[key] = base[key].is_a?(Hash) ? base[key].deep_reset!(default_value) : default_value
    end
    base
  end
end