module Inch
  module Evaluation
    # Role objects are assigned to evaluations of code objects. They describe
    # the object they are attached to.
    module Role
      # @abstract
      class Base
        attr_reader :object

        class << self
          def applicable_if(symbol = nil, &block)
            @applicable_procs ||= {}
            @applicable_procs[to_s] = block || symbol.to_proc
          end

          def applicable_unless(symbol = nil, &block)
            @applicable_procs ||= {}
            @applicable_procs[to_s] = proc do |object|
              !(block || symbol.to_proc).call(object)
            end
          end

          def applicable?(object)
            @applicable_procs ||= {}
            @applicable_procs[to_s].call(object)
          end
        end

        def initialize(object, value = nil)
          @object = object
          @value = value
        end

        # Returns a maximal score for the object.
        # The final score can not be higher than this.
        # @note Override this method to that a max_score for the evaluation.
        # @return [Float]
        def max_score
        end

        # Returns a minimal score for the object.
        # The final score can not be lower than this.
        # @note Override this method to that a min_score for the evaluation.
        # @return [Float]
        def min_score
        end

        # Returns a score that will be added to the associated object's
        # overall score.
        #
        # @note Override this method to assign a score for the role
        # @return [Float]
        def score
          @value.to_f
        end

        # Returns a potential score that would be added to the overall score
        # if the object had implemented the Role's subject.
        #
        # @see Role::Missing
        # @note Override this method to assign a potential score for the role
        # @return [Float]
        def potential_score
          nil
        end

        # Returns a priority that will be added to the associated object's
        # overall priority.
        #
        # @note Override this method to assign a priority for the role
        # @return [Fixnum]
        def priority
          0
        end

        # Returns a suggestion to achieve the potential score that would be
        # added to the overall score if the object had implemented the Role's
        # subject.
        #
        # @see Role::Missing
        # @return [Float]
        def suggestion
          nil
        end

        def object_type
          object.class.to_s.split('::').last.gsub(/Object$/, '').downcase
        end
      end
    end
  end
end
