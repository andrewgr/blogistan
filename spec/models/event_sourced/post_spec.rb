require 'rails_helper'

RSpec.describe EventSourced::Post, type: :model do
  let(:aggregate_id) { SecureRandom.uuid }
  let(:event_sink)   { Potoroo::EventSink.new }

  subject(:post) { described_class.new(aggregate_id, event_sink) }

  describe '#publish' do
    context 'when post is not created' do
      specify { expect { post.publish }.to raise_error(StandardError) }
    end

    context 'when post is created' do
      subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol') }

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
      context 'when post is hidden' do
        subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol') }

        specify { expect { post.unpublish }.not_to change { post.state }.from(:hidden) }
        specify { expect { post.unpublish }.not_to change { post.published? }.from(false) }
      end

      context 'when post is published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol').publish }

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
      context 'when post is hidden' do
        subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol') }

        specify { expect { post.delete }.to change { post.state }.from(:hidden).to(:deleted) }
        specify { expect { post.delete }.to change { post.deleted_at }.from(nil) }
        specify { expect { post.delete }.to change { post.deleted? }.from(false).to(true) }
      end

      context 'when post is published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol').publish }

        specify { expect { post.delete }.to change { post.state }.from(:published).to(:deleted) }
        specify { expect { post.delete }.to change { post.deleted_at }.from(nil) }
        specify { expect { post.delete }.to change { post.deleted? }.from(false).to(true) }
      end
    end
  end

  describe '#update' do
    context 'when post is not created' do
      specify { expect { post.update('LMAO') }.to raise_error(StandardError) }
    end

    context 'when post is created' do
      context 'when post is hidden' do
        subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol') }

        specify { expect { post.update('2', 'LMAO') }.not_to change { post.state }.from(:hidden) }
        specify { expect { post.update('2', 'LMAO') }.not_to change { post.published? }.from(false) }
        specify { expect { post.update('2', 'LMAO') }.to change { post.body }.from('Lol').to('LMAO') }
        specify { expect { post.update('2', '') }.to raise_error(ArgumentError) }
      end

      context 'when post is published' do
        subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol').publish }

        specify { expect { post.update('2', 'LMAO') }.not_to change { post.state }.from(:published) }
        specify { expect { post.update('2', 'LMAO') }.not_to change { post.published? }.from(true) }
        specify { expect { post.update('2', 'LMAO') }.to change { post.body }.from('Lol').to('LMAO') }
        specify { expect { post.update('2', '') }.to raise_error(ArgumentError) }
      end
    end

    context 'when post is deleted' do
      subject(:post) { described_class.new(aggregate_id, event_sink).update('1', 'Lol').deleted }

      specify { expect { post.update('2', 'LMAO') }.to raise_error(StandardError) }
    end
  end
end
