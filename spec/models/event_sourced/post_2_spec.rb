require 'rails_helper'

RSpec.describe EventSourced::Post, type: :model do
  let(:aggregate_id) { SecureRandom.uuid }
  let(:event_sink)   { Potoroo::EventSink.new }

  context 'when post has not been created' do
    subject(:post) { described_class.new(aggregate_id, event_sink) }

    describe '#create' do
      specify { expect { post.create('1', 'Lol') }.to change { post.state }.from(nil).to(:hidden) }
      specify { expect { post.create('1', 'Lol') }.to change { post.created_at }.from(nil) }
      specify { expect { post.create('',  'Lol') }.to raise_error(ArgumentError) }
      specify { expect { post.create('1', '')    }.to raise_error(ArgumentError) }
    end

    describe '#update' do
      specify { expect { post.update('LMAO') }.to raise_error(StandardError) }
    end

    describe '#publish' do
      specify { expect { post.publish }.to raise_error(StandardError) }
    end

    describe '#unpublish' do
      specify { expect { post.unpublish }.to raise_error(StandardError) }
    end

    describe '#delete' do
      specify { expect { post.delete }.to raise_error(StandardError) }
    end
  end

  context 'when post is hidden' do
    subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol') }

    describe '#create' do
      specify { expect { post.create('1', 'Lol') }.to raise_error(StandardError) }
    end

    describe '#update' do
      specify { expect { post.update('LMAO') }.not_to change { post.state }.from(:hidden) }
      specify { expect { post.update('LMAO') }.not_to change { post.published? }.from(false) }
      specify { expect { post.update('LMAO') }.to change { post.body }.from('Lol').to('LMAO') }
      specify { expect { post.update('') }.to raise_error(ArgumentError) }
    end

    describe '#publish' do
      specify { expect { post.publish }.to change { post.state }.from(:hidden).to(:published) }
      specify { expect { post.publish }.to change { post.published_at }.from(nil) }
      specify { expect { post.publish }.to change { post.published? }.from(false).to(true) }
    end

    describe '#unpublish' do
      specify { expect { post.unpublish }.not_to change { post.state }.from(:hidden) }
      specify { expect { post.unpublish }.not_to change { post.published? }.from(false) }
    end

    describe '#delete' do
      specify { expect { post.delete }.to change { post.state }.from(:hidden).to(:deleted) }
      specify { expect { post.delete }.to change { post.deleted_at }.from(nil) }
      specify { expect { post.delete }.to change { post.deleted? }.from(false).to(true) }
    end
  end

  context 'when post is published' do
    subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol').publish }

    describe '#create' do
      specify { expect { post.create('1', 'Lol') }.to raise_error(StandardError) }
    end

    describe '#update' do
      specify { expect { post.update('LMAO') }.not_to change { post.state }.from(:published) }
      specify { expect { post.update('LMAO') }.not_to change { post.published? }.from(true) }
      specify { expect { post.update('LMAO') }.to change { post.body }.from('Lol').to('LMAO') }
      specify { expect { post.update('') }.to raise_error(ArgumentError) }
    end

    describe '#publish' do
      specify { expect { post.publish }.not_to change { post.state }.from(:published) }
      specify { expect { post.publish }.not_to change { post.published_at } }
      specify { expect { post.publish }.not_to change { post.published? }.from(true) }
    end

    describe '#unpublish' do
      specify { expect { post.unpublish }.to change { post.state }.from(:published).to(:hidden) }
      specify { expect { post.unpublish }.to change { post.published_at }.to(nil) }
      specify { expect { post.unpublish }.to change { post.published? }.from(true).to(false) }
    end

    describe '#delete' do
      specify { expect { post.delete }.to change { post.state }.from(:published).to(:deleted) }
      specify { expect { post.delete }.to change { post.deleted_at }.from(nil) }
      specify { expect { post.delete }.to change { post.deleted? }.from(false).to(true) }
    end
  end

  context 'when post is deleted' do
    subject(:post) { described_class.new(aggregate_id, event_sink).create('1', 'Lol').delete }

    describe '#create' do
      specify { expect { post.create('1', 'Lol') }.to raise_error(StandardError) }
    end

    describe '#update' do
      specify { expect { post.('LMAO') }.to raise_error(StandardError) }
    end

    describe '#publish' do
      specify { expect { post.publish('LMAO') }.to raise_error(StandardError) }
    end

    describe '#unpublish' do
      specify { expect { post.unpublish }.to raise_error(StandardError) }
    end

    describe '#delete' do
      specify { expect { post.delete }.not_to change { post.state }.from(:deleted) }
      specify { expect { post.delete }.not_to change { post.deleted_at } }
      specify { expect { post.delete }.not_to change { post.deleted? }.from(true) }
    end
  end
end
