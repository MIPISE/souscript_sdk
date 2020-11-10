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
