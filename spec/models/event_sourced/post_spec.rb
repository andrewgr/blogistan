require 'rails_helper'

RSpec.describe EventSourced::Post, type: :model do
  let(:aggregate_id) { SecureRandom.uuid }
  let(:event_sink)   { Potoroo::EventSink.new }

  subject(:post) { described_class.new(aggregate_id, event_sink) }

  describe '#create' do
    specify do
      expect { post.create('1', 'Lol') }.to change { post.state }.from(nil).to(:hidden)
    end
  end
end
