#encoding: utf-8

module PollyPhone
  module Utils

  	def symbolize_keys(obj)
      case obj
      when Array
        obj.inject([]){|res, val|
          res << case val
          when Hash, Array
            symbolize_keys(val)
          else
            val
          end
          res
        }
      when Hash
        obj.inject({}){|res, (key, val)|
          nkey = case key
          when String
            key.to_sym
          else
            key
          end
          nval = case val
          when Hash, Array
            symbolize_keys(val)
          else
            val
          end
          res[nkey] = nval
          res
        }
      else
        obj
      end
    end

    # custom activesupport squish analog
    def clr_str(string)
      string.gsub(/\A[[:space:]]+/, '').gsub(/[[:space:]]+\z/, '').gsub(/[[:space:]]+/, ' ')
    end
  end
end