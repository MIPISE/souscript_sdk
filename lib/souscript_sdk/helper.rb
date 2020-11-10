module SouscriptSDK
  module Helper
    def format_hash(hash, required_keys, optional_keys)
      stringify_and_upcase_keys(
        ensure_keys(
          hash,
          required_keys,
          optional_keys
        )
      )
    end

    def underscore_hash_keys(value)
      case value
      when Array then value.map { |v| underscore_hash_keys(v) }
      when Hash
        Hash[value.map { |k, v|
          [k.to_s.underscore.to_sym, underscore_hash_keys(v)]
        }]
      else value
      end
    end

    private

    def stringify_and_upcase_keys(hash)
      output = {}
      hash.each { |key, value| output[key.to_s.upcase] = value }
      output
    end

    def ensure_keys(hash, required_keys = [], optional_keys = [])
      # Ensure there are no extra keys
      hash.assert_valid_keys(required_keys + optional_keys)

      # Ensure all required keys are present
      required_keys.each do |key|
        raise(ArgumentError, "Required key not found: #{key}") unless hash.has_key?(key)
      end

      hash
    end
  end
end
