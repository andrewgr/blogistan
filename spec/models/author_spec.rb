require 'rails_helper'

RSpec.describe Author, type: :model do
  describe '#valid?' do
    specify { expect(described_class.new(name: nil)).to be_invalid }
    specify { expect(described_class.new(name: 'alice')).to be_valid }
  end
end
