# Hook the timestamped booleans functionality into ActiveRecord.
ActiveRecord::Base.send :include, Rubaidh::TimestampedBooleans