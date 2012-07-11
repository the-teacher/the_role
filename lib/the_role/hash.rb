# load 'the_role/hash.rb' - UPDATE, BUT NOT RELOAD
# {'a b' => 1, "x y" => {'hello' => 1, :hello => 2} }.underscorify_keys => {:a_b=>1, :x_y=>{:hello=>2}}

class Hash
  # DEEP TRANSFORM
  def deep_transform_keys(&block)
    result = {}
    each do |key, value|
      result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
    end
    result
  end

  def deep_transform_keys!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
    end
    self
  end

  # DEEP STRINGIFY
  def deep_stringify_keys
    deep_transform_keys{ |key| key.to_s }
  end

  def deep_stringify_keys!
    deep_transform_keys!{ |key| key.to_s }
  end

  # UNDERSCORIFY KEYS
  def underscorify_keys
    hash = {}
    self.each do |key, value|
      new_key       = TheRole::ParamHelper.prepare(key)
      hash[new_key] = self[key].is_a?(Hash) ? self[key].underscorify_keys : value
    end
    hash
  end

  def underscorify_keys!
    replace underscorify_keys
  end

  #DEEP RESET
  def deep_reset(default = false)
    hash = dup
    hash.each do |key, value|
      hash[key] = hash[key].is_a?(Hash) ? hash[key].deep_reset(default) : default
    end
    hash
  end

  def deep_reset!(default = false)
    replace deep_reset(default)
  end
end