require 'rails_helper'

RSpec.describe EventSourced::Author, type: :model do
  let(:aggregate_id) { SecureRandom.uuid }
  let(:event_sink)   { Potoroo::EventSink.new }

  subject(:author) { described_class.new(aggregate_id, event_sink) }

  describe '#create' do
    specify { expect { author.create('Alice') }.to change { author.name }.from(nil).to('Alice') }
    specify { expect { author.create('') }.to raise_error(ArgumentError) }
    specify { expect { author.create(nil) }.to raise_error(ArgumentError) }
  end
end
