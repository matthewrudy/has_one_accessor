module HasOneAccessor
  module ActsMethods
    def has_one_accessor(relation, attribs, options={})
      attribs = Array(attribs)
      
      attribs.each do |attrib|
        method_name = options[:prefix] == false ? attrib : "#{relation}_#{attrib}"
        class_eval <<-EVAL
          def #{method_name}
            #{relation} && #{relation}.#{attrib}
          end
        
          def #{method_name}=(value)
            if #{relation}
              #{relation}.#{attrib} = value
            else
              build_#{relation}(#{attrib.inspect} => value)
            end
          end
        EVAL
      end
    
      deletion_criterion = options[:allow_blank] ? :nil? : :blank?
      class_eval <<-EVAL
        def save_#{relation}
          if self.#{relation}
            if #{attribs.inspect}.map{|attrib| self.#{relation}.send(attrib)}.all?{|v| v.#{deletion_criterion}}
              self.#{relation} && self.#{relation}.destroy
              self.#{relation} = nil
            else
              self.#{relation}.save
            end
          end
        end
      EVAL
      after_save "save_#{relation}"
    end
  end
end
