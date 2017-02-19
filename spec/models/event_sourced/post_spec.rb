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

  describe '#publish' do
    context 'when post is not created' do
      specify { expect { post.publish }.to raise_error(StandardError) }
    end

    context 'when post is created' do
      subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol') }

      specify { expect { post.publish }.to change { post.state }.from(:hidden).to(:published) }
      specify { expect { post.publish }.to change { post.published_at }.from(nil) }
      specify { expect { post.publish }.to change { post.published? }.from(false).to(true) }
    end
  end

  describe '#unpublish' do
    context 'when post is not created' do
      specify { expect { post.unpublish }.to raise_error(StandardError) }
    end

    context 'when post is created' do
      context 'when post is not published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol') }

        specify { expect { post.unpublish }.not_to change { post.state }.from(:hidden) }
        specify { expect { post.unpublish }.not_to change { post.published? }.from(false) }
      end

      context 'when post is published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol').publish }

        specify { expect { post.unpublish }.to change { post.state }.from(:published).to(:hidden) }
        specify { expect { post.unpublish }.to change { post.published_at }.to(nil) }
        specify { expect { post.unpublish }.to change { post.published? }.from(true).to(false) }
      end
    end
  end

  describe '#delete' do
    context 'when post is not created' do
      specify { expect { post.delete }.to raise_error(StandardError) }
    end

    context 'when post is created' do
      context 'when post is not published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol') }

        specify { expect { post.delete }.to change { post.state }.from(:hidden).to(:deleted) }
        specify { expect { post.delete }.to change { post.deleted_at }.from(nil) }
        specify { expect { post.delete }.to change { post.deleted? }.from(false).to(true) }
      end

      context 'when post is published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol').publish }

        specify { expect { post.delete }.to change { post.state }.from(:published).to(:deleted) }
        specify { expect { post.delete }.to change { post.deleted_at }.from(nil) }
        specify { expect { post.delete }.to change { post.deleted? }.from(false).to(true) }
      end
    end
  end
end
