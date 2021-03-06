module James

  class State

    # Transitions are internal transitions & external transitions.
    #
    def transitions
      @transitions
    end

    #
    #
    def expects
      transitions.keys
    end

    #
    #
    def internal_expects
      transitions.select { |phrase, target| target.respond_to?(:to_sym) || target == self.context }.keys
    end


    # Returns the next state for the given phrase.
    #
    # It accesses the context (aka Dialog) to get a full object state.
    #
    # If it is a Symbol, James will try to get the real state.
    # If not, it will just return it (a State already, or lambda).
    #
    def next_for phrase
      state = self.transitions[phrase]
      state.respond_to?(:id2name) ? context.state_for(state) : state
    end

    # The naughty privates.
    #

      # Called by the visitor visiting this state.
      #
      def __into__
        @into_block && context.instance_eval(&@into_block)
      end

      # Called by the visitor visiting this state.
      #
      def __exit__
        @exit_block && context.instance_eval(&@exit_block)
      end

      # Called by the visitor visiting this state.
      #
      def __transition__ &block
        context.instance_eval &block
      end

  end

end