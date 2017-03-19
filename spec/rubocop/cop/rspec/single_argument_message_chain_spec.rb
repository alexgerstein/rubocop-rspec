RSpec.describe RuboCop::Cop::RSpec::SingleArgumentMessageChain do
  subject(:cop) { described_class.new }

  describe 'receive_message_chain' do
    it 'reports single-argument calls' do
      expect_violation(<<-RUBY)
        before do
          allow(foo).to receive_message_chain(:one) { :two }
                        ^^^^^^^^^^^^^^^^^^^^^ Use `receive` instead of calling `receive_message_chain` with a single argument.
        end
      RUBY
    end

    include_examples(
      'autocorrect',
      'before { allow(foo).to receive_message_chain(:one) { :two } }',
      'before { allow(foo).to receive(:one) { :two } }'
    )

    it 'accepts multi-argument calls' do
      expect_no_violations(<<-RUBY)
        before do
          allow(foo).to receive_message_chain(:one, :two) { :three }
        end
      RUBY
    end

    it 'reports single-argument string calls' do
      expect_violation(<<-RUBY)
        before do
          allow(foo).to receive_message_chain("one") { :two }
                        ^^^^^^^^^^^^^^^^^^^^^ Use `receive` instead of calling `receive_message_chain` with a single argument.
        end
      RUBY
    end

    include_examples(
      'autocorrect',
      'before { allow(foo).to receive_message_chain("one") { :two } }',
      'before { allow(foo).to receive("one") { :two } }'
    )

    it 'accepts multi-argument string calls' do
      expect_no_violations(<<-RUBY)
        before do
          allow(foo).to receive_message_chain("one.two") { :three }
        end
      RUBY
    end

    context 'with single-key hash argument' do
      it 'reports an offence' do
        expect_violation(<<-RUBY)
          before do
            allow(foo).to receive_message_chain(bar: 42)
                          ^^^^^^^^^^^^^^^^^^^^^ Use `receive` instead of calling `receive_message_chain` with a single argument.
          end
        RUBY
      end

      include_examples(
        'autocorrect',
        'before { allow(foo).to receive_message_chain(bar: 42) }',
        'before { allow(foo).to receive(:bar) { 42 } }'
      )

      include_examples(
        'autocorrect',
        'before { allow(foo).to receive_message_chain("foo bar" => 42) }',
        'before { allow(foo).to receive("foo bar") { 42 } }'
      )
    end

    context 'with multiple keys hash argument' do
      it "doesn't report an offence" do
        expect_no_violations(<<-RUBY)
          before do
            allow(foo).to receive_message_chain(bar: 42, baz: 42)
          end
        RUBY
      end
    end

    context 'with empty hash' do
      it "doesn't report an offence" do
        expect_no_violations(<<-RUBY)
          before do
            allow(foo).to receive_message_chain({})
          end
        RUBY
      end
    end
  end

  describe 'stub_chain' do
    it 'reports single-argument calls' do
      expect_violation(<<-RUBY)
        before do
          foo.stub_chain(:one) { :two }
              ^^^^^^^^^^ Use `stub` instead of calling `stub_chain` with a single argument.
        end
      RUBY
    end

    include_examples(
      'autocorrect',
      'before { foo.stub_chain(:one) { :two } }',
      'before { foo.stub(:one) { :two } }'
    )

    it 'accepts multi-argument calls' do
      expect_no_violations(<<-RUBY)
        before do
          foo.stub_chain(:one, :two) { :three }
        end
      RUBY
    end

    it 'reports single-argument string calls' do
      expect_violation(<<-RUBY)
        before do
          foo.stub_chain("one") { :two }
              ^^^^^^^^^^ Use `stub` instead of calling `stub_chain` with a single argument.
        end
      RUBY
    end

    include_examples(
      'autocorrect',
      'before { foo.stub_chain("one") { :two } }',
      'before { foo.stub("one") { :two } }'
    )

    it 'accepts multi-argument string calls' do
      expect_no_violations(<<-RUBY)
        before do
          foo.stub_chain("one.two") { :three }
        end
      RUBY
    end
  end
end
