module Rubaidh # :nodoc:
  module TimestampedBooleans # :nodoc:
    module ClassMethods

      #
      # Set up particular attributes as being timestamped booleans.  It takes
      # a list of one or more attributes that are datetime fields.  It assumes
      # that the datetime attributes are named with the Rails convention of
      # ending in +_at+ or +_on+.
      #
      def timestamped_booleans(*attrs)
        attrs.each do |attr|
          boolean_attr = attr.to_s.gsub /_(at|on)$/, ''
          class_eval do
            define_method("#{boolean_attr}?") do
              !send(attr).blank?
            end

            define_method("#{boolean_attr}=") do |bool|
              send("#{attr}=", bool ? Time.now : nil)
              bool
            end
          end
        end
      end
      alias_method :timestamped_boolean, :timestamped_booleans
    end

    def self.included(base) # :nodoc:
      base.extend         ClassMethods
    end
  end
end