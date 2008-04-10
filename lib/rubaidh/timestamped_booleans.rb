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
              value = send(attr)
              !value.blank? && value <= Time.now
            end

            define_method("#{boolean_attr}=") do |bool|
              send("#{attr}=", bool ? Time.now : nil)
              bool
            end

            # FIXME: These are not well unit tested.
            named_scope boolean_attr, :conditions => ["#{attr} IS NOT ? AND #{attr} <= ?", nil, Time.now]
            named_scope "not_#{boolean_attr}", :conditions => ["#{attr} IS ? OR #{attr} > ?", nil, Time.now]
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