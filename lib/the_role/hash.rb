class Hash
  # load 'the_role/hash.rb' - UPDATE BUT NOT RELOAD

  # {'a b' => 1, "x y" => {'hello' => 1, :hello => 2} }.underscorify_keys
  # {:a_b=>1, :x_y=>{:hello=>2}}
  def underscorify_keys
    hash = {}
    self.each do |key, value|
      new_key       = key.to_s.parameterize.underscore.to_sym
      hash[new_key] = self[key].is_a?(Hash) ? self[key].underscorify_keys : value
    end
    hash
  end

  def deep_reset(default = false)
    hash = dup
    hash.each do |key, value|
      hash[key] = hash[key].is_a?(Hash) ? hash[key].deep_reset(default) : default
    end
    hash
  end

  def underscorify_keys!
    replace underscorify_keys
  end

  def deep_reset!(default = false)
    replace deep_reset(default)
  end
end