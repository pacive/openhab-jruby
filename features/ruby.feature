Feature:  Openhab Gem Support

  Background:
    Given Clean OpenHAB with latest Ruby Libraries

  Scenario: Instance variables are available with a rule
    Given a rule
      """
      rule 'set variable' do
        on_start
        run { @foo = 'bar' }
        run { logger.info("@Foo is #{@foo}") }
      end
      """
    When I deploy the rule
    Then It should log 'Foo is bar' within 5 seconds

  Scenario: Instance variables set in file are available within rules
    Given a rule
      """
      @foo = 'bar'

      rule 'read variable' do
        on_start
        run { logger.info("@Foo is defined: #{ instance_variable_defined?("@foo") }") }
      end
      """
    When I deploy the rule
    Then It should log 'Foo is defined: true' within 5 seconds

  Scenario: local variables set in file are available within rules
    Given a rule
      """
      foo = 'bar'

      rule 'read variable' do
        on_start
        run do
         logger.info("foo is defined: #{ local_variables.include?(:foo) }")
        end
      end
      """
    When I deploy the rule
    Then It should log 'foo is defined: true' within 5 seconds


  Scenario: Instance variables are available between rules
    Given a rule
      """
      rule_set do

        rule 'set variable' do
          on_start
          run do
            @foo = 'bar'
            logger.info("@Foo set to #{ @foo }")
          end
        end

        rule 'read variable' do
          on_start
          delay 2.seconds
          run do
           logger.info("@Foo is defined: #{ instance_variable_defined?("@foo") }")
          end
        end

      end
      """
    When I deploy the rule
    Then It should log '@Foo is defined: true' within 5 seconds

  Scenario: local variables are available between rules
    Given a rule
      """
      foo = 'baz'

      rule 'set variable' do
        on_start
        run do
          foo = 'bar'
          logger.info("Foo set to #{ foo }")
        end
      end

      rule 'read variable' do
        on_start
        delay 2.seconds
        run do
         logger.info("foo is bar: #{ foo == 'bar' }")
        end
      end
      """
    When I deploy the rule
    Then It should log 'foo is bar: true' within 5 seconds


  Scenario: instance variables set in ruby blocks are available in rules
    Given a rule:
      """
      @foo = 'bar'
      rule 'read variable' do
        on_start
        run { logger.info("@Foo is defined: #{ instance_variable_defined?("@foo") }") }
      end
      """
    When I deploy the rule
    Then It should log '@Foo is defined: true' within 5 seconds


  Scenario: Instance variables are not shared between rules files
    Given a deployed rule:
      """
      rule 'set variable' do
        on_start
        run do
          @foo = 'bar'
          logger.info("@Foo set to #{  @foo  }")
        end
      end
      """
    And a rule:
      """"
      rule 'read variable' do
        on_start
        run do
         logger.info("@Foo is defined: #{ instance_variable_defined?("@foo") }")
        end
      end
      """
    When I deploy the rule
    Then It should log 'Foo is defined: false' within 5 seconds

  Scenario: Instance variables are shared between same named rule_sets
    Given a deployed rule:
      """
      rule_set 'test' do
        rule 'set variable' do
          on_start
          run do
            @foo = 'bar'
            logger.info("@Foo set to #{  @foo  }")
          end
        end
      end
      """
    And a rule:
      """"
      rule_set 'test' do
        rule 'read variable' do
          on_start
          run do
           logger.info("@Foo is defined: #{ instance_variable_defined?("@foo") }")
          end
        end
      end
      """
    When I deploy the rule
    Then It should log 'Foo is defined: true' within 5 seconds



  Scenario: Local variables are not shared between rules files
    Given a deployed rule:
      """
      foo = 'baz'

      rule 'set variable' do
        on_start
        run do
          foo = 'bar'
          logger.info("foo set to #{  foo  }")
        end
      end
      """
    And a rule:
      """"
      rule 'read variable' do
        on_start
        run do
         logger.info("foo is defined: #{ local_variables.include?(:foo) }")
        end
      end
      """
    When I deploy the rule
    Then It should log 'foo is defined: false' within 5 seconds