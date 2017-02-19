require 'rails_helper'

RSpec.describe EventSourced::Post, type: :model do
  let(:aggregate_id) { SecureRandom.uuid }
  let(:event_sink)   { Potoroo::EventSink.new }

  subject(:post) { described_class.new(aggregate_id, event_sink) }

  describe '#create' do
    specify { expect { post.create('1', 'Lol') }.to change { post.state }.from(nil).to(:hidden) }
    specify { expect { post.create('', 'Lol') }.to raise_error(ArgumentError) }
    specify { expect { post.create('1', '') }.to raise_error(ArgumentError) }
  end
end
