require 'rails_helper'

RSpec.describe EventSourced::Comment, type: :model do
  let(:aggregate_id) { SecureRandom.uuid }
  let(:event_sink)   { Potoroo::EventSink.new }

  subject(:comment) { described_class.new(aggregate_id, event_sink) }

  describe '#post' do
    specify { expect { comment.post('1', '2', 'Lol') }.to change { comment.body }.from(nil).to('Lol') }
  end
end
