require 'rails_helper'

RSpec.describe Event, type: :model do
end

RSpec.describe PostCreated, type: :model do
  subject(:event) { described_class.new(payload: { author_id: '1', body: 'Lol' }) }

  specify { expect(event.author_id).to eq('1') }
  specify { expect(event.body).to eq('Lol') }
end
