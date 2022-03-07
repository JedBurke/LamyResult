include LamyResult

RSpec.describe Lamy do
  describe '.ok' do
    it 'creates an instance with an `ok` result' do
      result = Lamy.ok('This works')

      expect(result.status).to eq(:ok)
      expect(result.value).to eq('This works')
    end
  end

  describe '#ok?' do
    context 'has an `ok` status' do
      it 'returns true' do
        result = Lamy.ok('Lamy')

        expect(result.ok?).to be true
      end
    end

    context 'does not have an `ok` status' do
      it 'returns false' do
        result = Lamy.failed('Nami')
        expect(result.ok?).to be false
      end
    end
  end

  describe '#ok_then' do
    context 'has an `ok` status' do
      context 'has a block' do
        it 'yields the block' do
          result = Lamy.ok('Lamy')
          message_formatted = result.ok_then do |m|
            "#{m} is fucking A!"
          end

          expect(message_formatted).to eq('Lamy is fucking A!')
        end
      end

      context 'does not have a block' do
        it 'yields the block' do
          result = Lamy.ok('Lamy')
          message_formatted = result.ok_then

          expect(message_formatted).to eq('Lamy')
        end
      end
    end
  end

  describe '.success' do
    it 'creates an instance with a `success` result' do
      result = Lamy.success('Meta.')
      expect(result.status).to eq(:succeeded)
      expect(result.value).to eq('Meta.')
    end
  end

  describe '#success?' do
    context 'has a `success` status' do
      it 'returns true' do
        result = Lamy.success('Meta.')
        expect(result.success?).to be true
      end
    end

    context 'does not have a `success` status' do
      it 'returns false' do
        result = Lamy.failed('Meta.')
        expect(result.success?).to be false
      end
    end
  end

  describe '.true' do
    it 'create a instance with a `true` status' do
      result = Lamy.true('This is Ruby')
      expect(result.status).to eq :true
    end
  end

  describe '#true?' do
    context 'status is `true`' do
      it 'returns true' do
        result = Lamy.true('This is Ruby')
        expect(result.true?).to be true
      end
    end

    context 'status is not `true`' do
      it 'returns false' do
        result = Lamy.true('This is Ruby')
        expect(result.false?).to be false
      end
    end
  end

  describe '#true_then' do
    context 'status is `true`' do
      context 'has a block' do
        it 'yields the block' do
          result = Lamy.true('Lamy is from hololive 5th Gen')

          expect(result.true_then { |v| "#{v}!" }).to eq(
            'Lamy is from hololive 5th Gen!'
          )

          result.success_then do |v|
            raise StandardError.new 'Not supposed to be here.'
          end
        end
      end
    end
  end


  describe '#status_is?' do
    context 'object status matches the input' do
      it 'returns true' do
        result = Lamy.failed('Test')
        expect(result.status_is?(:failed)).to be true
      end
    end

    context 'object does not match the input' do
      it 'returns false' do
        result = Lamy.success('Test')
        expect(result.status_is?(:failed)).to be false
      end
    end
  end

  describe '#==' do
    context 'object status matches the rval' do
      it 'returns true' do
        expect(Lamy.failed('Test') == :failed).to be true
      end
    end

    context 'object does not match the rval' do
      it 'returns false' do
        expect(Lamy.success('Test') == :failed).to be false
      end
    end
  end

  describe '#===' do
    context 'object status matches the rval' do
      it 'returns true' do
        expect(Lamy.failed('Test') === :failed).to be true
      end
    end

    context 'object does not match the rval' do
      it 'returns false' do
        expect(Lamy.success('Test') === :failed).to be false
      end
    end
  end

  describe '#to_a' do
    context 'status is a boolean' do
      it 'returns an array of the result instance' do
        result = Lamy.true('Lamy is a VTuber').to_a
        expect(result).to eq([
          true,
          'Lamy is a VTuber'
        ])
      end
    end

    context 'status is not a boolean' do
      it 'returns an array of the result instance' do
        result = Lamy.ok('Lamy is a VTuber').to_a

        expect(result).to be_an(Array)
        expect(result).to eq([
          :ok,
          'Lamy is a VTuber'
        ])
      end
    end
  end

  describe '#to_h' do
    context 'status is a boolean' do
      it 'returns a hash of the result instance' do
        result = Lamy.false('Lamy is not a VTuber').to_h

        expect(result).to be_a(Hash)
        expect(result).to eq({
          status: false,
          value: 'Lamy is not a VTuber'
        })
      end
    end

    context 'status is not a boolean' do
      it 'returns a hash of the result instance' do
        result = Lamy.error('Lamy is not a VTuber').to_h

        expect(result).to be_a(Hash)
        expect(result).to eq({
          status: :failed,
          value: 'Lamy is not a VTuber'
        })
      end
    end
  end

  describe '.add_status_tags' do
    context 'a single tag is passed' do
      it 'creates a status tag for it' do
        expect(Lamy.respond_to?(:wammy)).to be false

        Lamy.add_status_tags('wammy')

        expect(Lamy.respond_to?(:wammy)).to be true

        result = Lamy.wammy('Hello')
        expect(result.wammy?).to be true
        expect(result.ok?).to be false
      end
    end

    context 'an array of tags is passed' do
      it 'creates a status tag for each one' do
        expect(Lamy.respond_to?(:botan)).to be false
        expect(Lamy.respond_to?(:nenechi)).to be false

        Lamy.add_status_tags(:botan, :nenechi)

        expect(Lamy.respond_to?(:botan)).to be true
        expect(Lamy.respond_to?(:nenechi)).to be true

        result = Lamy.botan('Hello')
        expect(result.botan?).to be true
        expect(result.ok?).to be false
      end
    end
  end

end
