# frozen_string_literal: true

module OpenHAB
  module Core
    module DSL
      module Rule

        class RuleSet
          include Logging
          extend OpenHAB::Core::DSL
        end

        def ruleset(&block)
            rule_context = RuleSet.new
            rule_context.instance_eval(&block)
        end
      end
    end
  end
end
