# load 'the_role/hash.rb' - UPDATE, BUT NOT RELOAD [for console testing]
class Hash
  # RAILS 4 methods for RAILS 3
  # DEEP TRANSFORM HELPER METHODS
  unless {}.respond_to?(:deep_transform_keys)
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
  end

  unless {}.respond_to?(:deep_stringify_keys)
    def deep_stringify_keys
      deep_transform_keys{ |key| key.to_s }
    end

    def deep_stringify_keys!
      deep_transform_keys!{ |key| key.to_s }
    end
  end

  unless {}.respond_to?(:underscorify_keys)
    def underscorify_keys
      deep_transform_keys{ |key| TheRole::ParamHelper.prepare(key) }
    end

    def underscorify_keys!
      replace underscorify_keys
    end
  end

  unless {}.respond_to?(:deep_reset)
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
  end
end