RSpec.describe 'Lamy' do
  subject do
    LamyResult::Lamy
  end

  describe '.ok' do
    it 'creates an instance with an `ok` result' do
      result = subject.ok('This works')

      expect(result.status).to eq(:ok)
      expect(result.value).to eq('This works')
    end
  end

  describe '#ok?' do
    context 'has an `ok` status' do
      it 'returns true' do
        result = subject.ok('Lamy')

        expect(result.ok?).to be true
      end
    end

    context 'does not have an `ok` status' do
      it 'returns false' do
        result = subject.failed('Nami')
        expect(result.ok?).to be false
      end
    end
  end

  describe '#ok_then' do
    context 'has an `ok` status' do
      context 'has a block' do
        it 'yields the block' do
          result = subject.ok('Lamy')
          message_formatted = result.ok_then do |m|
            "#{m} is fucking A!"
          end

          expect(message_formatted).to eq('Lamy is fucking A!')
        end
      end

      context 'does not have a block' do
        it 'yields the block' do
          result = subject.ok('Lamy')
          message_formatted = result.ok_then

          expect(message_formatted).to eq('Lamy')
        end
      end
    end
  end

  describe '.success' do
    it 'creates an instance with a `success` result' do
      result = subject.success('Meta.')
      expect(result.status).to eq(:succeeded)
      expect(result.value).to eq('Meta.')
    end
  end

  describe '#success?' do
    context 'has a `success` status' do
      it 'returns true' do
        result = subject.success('Meta.')
        expect(result.success?).to be true
      end
    end

    context 'does not have a `success` status' do
      it 'returns false' do
        result = subject.failed('Meta.')
        expect(result.success?).to be false
      end
    end
  end

  describe '.true' do
    it 'create a instance with a `true` status' do
      result = subject.true('This is Ruby')
      expect(result.status).to eq :true
    end
  end

  describe '#true?' do
    context 'status is `true`' do
      it 'returns true' do
        result = subject.true('This is Ruby')
        expect(result.true?).to be true
      end
    end

    context 'status is not `true`' do
      it 'returns false' do
        result = subject.true('This is Ruby')
        expect(result.false?).to be false
      end
    end
  end

  describe '#true_then' do
    context 'status is `true`' do
      context 'has a block' do
        it 'yields the block' do
          result = subject.true('Lamy is from hololive 5th Gen')

          expect(result.true_then {|v| "#{v}!" }).to eq(
            'Lamy is from hololive 5th Gen!'
          )

          result.success_then do |v|
            raise StandardError.new 'Not supposed to be here.'
          end
        end
      end
    end
  end

  describe '#any?' do
    context 'one status' do
      context 'instance status matches' do
        it 'returns true' do
          status = subject.ok('Yukihana Lamy is awesome')
          expect(status.any?(:ok)).to be true
        end
      end

      context 'instance status does not match' do
        it 'returns false' do
          status = subject.ok('Yukihana Lamy is awesome')
          expect(status.any?(:error)).to be false
        end
      end
    end

    context 'more than one status' do
      context 'instance status matches' do
        it 'returns true' do
          status = subject.ok('Yukihana Lamy is awesome')
          expect(status.any?(:success, :ok, :true)).to be true
        end
      end

      context 'instance status does not match' do
        it 'returns false' do
          status = subject.ok('Yukihana Lamy is awesome')
          expect(status.any?(:error, :critical)).to be false
        end
      end
    end
  end

  describe 'any_then' do
    context 'status is among input statuses' do
      context 'does not pass a block' do
        it 'returns the value' do
          value = 'Lamy is awesome!'
          result = subject.ok(value)
          expect(result.any_then(:ok)).to eq(value)
        end
      end

      context 'passes a block' do
        it 'yields the value to the block' do
          value = 'Lamy is awesome.'
          result = subject.ok(value)
          return_value = result.any_then(:ok, :true, :success) do |v|
            value.sub(/\.$/, '!')
          end

          expect(return_value).to eq('Lamy is awesome!')
        end
      end
    end

    context 'status is not among input statuses' do
      context 'does not pass block' do
        it 'returns false' do
          result = subject.ok('Lamy is a half snow elf.')
          expect(result.any_then(:error)).to be false
        end
      end

      context 'passes a block' do
        it 'returns false' do
          result = subject.ok('Lamy is a half snow elf.')
          expect(result.any_then(:error) {|v| puts v }).to be false
        end
      end
    end
  end

  describe '#status_is?' do
    context 'object status matches the input' do
      it 'returns true' do
        result = subject.failed('Test')
        expect(result.status_is?(:failed)).to be true
      end
    end

    context 'object does not match the input' do
      it 'returns false' do
        result = subject.success('Test')
        expect(result.status_is?(:failed)).to be false
      end
    end
  end

  describe '#==' do
    context 'object status matches the rval' do
      it 'returns true' do
        expect(subject.failed('Test') == :failed).to be true
      end
    end

    context 'object does not match the rval' do
      it 'returns false' do
        expect(subject.success('Test') == :failed).to be false
      end
    end
  end

  describe '#==' do
    context 'object status matches the rval' do
      it 'returns true' do
        expect(subject.failed('Test') == :failed).to be true
      end
    end

    context 'object does not match the rval' do
      it 'returns false' do
        expect(subject.success('Test') == :failed).to be false
      end
    end
  end

  describe '#to_a' do
    context 'status is a boolean' do
      it 'returns an array of the result instance' do
        result = subject.true('Lamy is a VTuber').to_a
        expect(result).to eq(
          [
            true,
            'Lamy is a VTuber'
          ]
        )
      end
    end

    context 'status is not a boolean' do
      it 'returns an array of the result instance' do
        result = subject.ok('Lamy is a VTuber').to_a

        expect(result).to be_an(Array)
        expect(result).to eq(
          [
            :ok,
            'Lamy is a VTuber'
          ]
        )
      end
    end
  end

  describe '#to_h' do
    context 'status is a boolean' do
      it 'returns a hash of the result instance' do
        result = subject.false('Lamy is not a VTuber').to_h

        expect(result).to be_a(Hash)
        expect(result).to eq(
          {
            status: false,
            value: 'Lamy is not a VTuber'
          }
        )
      end
    end

    context 'status is not a boolean' do
      it 'returns a hash of the result instance' do
        result = subject.error('Lamy is not a VTuber').to_h

        expect(result).to be_a(Hash)
        expect(result).to eq(
          {
            status: :failed,
            value: 'Lamy is not a VTuber'
          }
        )
      end
    end
  end

  describe '.define_status_tags' do
    context 'a single tag is passed' do
      it 'creates a status tag for it' do
        expect(subject.respond_to?(:wammy)).to be false

        subject.define_status_tags('wammy')

        expect(subject.respond_to?(:wammy)).to be true

        result = subject.wammy('Hello')
        expect(result.wammy?).to be true
        expect(result.ok?).to be false
      end
    end

    context 'an array of tags is passed' do
      context 'does not specify aliases' do
        it 'creates a status tag for each one' do
          expect(subject.respond_to?(:botan)).to be false
          expect(subject.respond_to?(:nenechi)).to be false

          subject.define_status_tags(:botan, :nenechi)

          expect(subject.respond_to?(:botan)).to be true
          expect(subject.respond_to?(:nenechi)).to be true

          result = subject.botan('Hello')

          expect(result.botan?).to be true
          expect(result.ok?).to be false

          expect { result.polka? }.to raise_error(NoMethodError)
        end
      end

      context 'specifies aliases' do
        it 'creates a status tag with aliases for each one' do
          expect(subject.respond_to?(:polka)).to be false
          expect(subject.respond_to?(:omarun)).to be false

          subject.define_status_tags([:polka, :omarun])

          expect(subject.respond_to?(:polka)).to be true
          expect(subject.respond_to?(:omarun)).to be true

        end
      end
    end
  end

end
