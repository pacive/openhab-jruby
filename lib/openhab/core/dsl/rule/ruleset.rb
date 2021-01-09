# frozen_string_literal: true

require 'jruby'

module OpenHAB
  module Core
    module DSL
      module Rule
        include Logging

        class RuleSet
          include Logging
          extend OpenHAB::Core::DSL
        end

        def rule_set(name=nil, &block)
            $jruby_shared_map.put_if_absent('rule_sets', Hash.new { |hash, key| puts "Creating new RuleSet: #{key}"; hash[key]= RuleSet.new })
            rule_set_map = $jruby_shared_map.get('rule_sets')

            puts $jruby_shared_map
            puts rule_set_map
            rule_set_map.keys.each do |key| 
                puts JRuby.ref(key).getRuntime
            end

            puts "rule_set_map class #{rule_set_map.class}"

            rule_context = name ? rule_set_map[name] : RuleSet.new
            rule_context.instance_eval(&block)
        end
      end
    end
  end
end
