# load 'the_role/hash.rb' - UPDATE, BUT NOT RELOAD [for console testing]
class Hash
  # RAILS 4 methods for RAILS 3
  # DEEP TRANSFORM HELPER METHODS
  if Rails::VERSION::MAJOR == 3    
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

    puts "[TheRole] RAILS 4 method **deep_transform_keys** mixed to HASH class of Rails 3"
    
    def deep_stringify_keys
      deep_transform_keys{ |key| key.to_s }
    end

    def deep_stringify_keys!
      deep_transform_keys!{ |key| key.to_s }
    end

    puts "[TheRole] RAILS 4 method **deep_stringify_keys** mixed to HASH class of Rails 3"
  end

  # Potential compatibility problem with RAILS_VERSION > 4.0
  # But I hope nobody will create function with this name
  def underscorify_keys
    deep_transform_keys{ |key| TheRole::ParamHelper.prepare(key) }
  end

  def underscorify_keys!
    replace underscorify_keys
  end

  # DEEP RESET VALUES
  def deep_reset(default = nil)
    hash = dup
    hash.each do |key, value|
      hash[key] = hash[key].is_a?(Hash) ? hash[key].deep_reset(default) : default
    end
    hash
  end

  def deep_reset!(default = nil)
    replace deep_reset(default)
  end

  puts "[TheRole] Notification: Hash class extended: Hash#underscorify_keys, Hash#deep_reset"
end