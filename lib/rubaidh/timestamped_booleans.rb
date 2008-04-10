module Rubaidh
  module TimestampedBooleans
    module ClassMethods
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

    def self.included(base)
      base.extend         ClassMethods
    end
  end
end