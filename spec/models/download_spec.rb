require 'spec_helper'

describe Download do
  it { should belong_to(:downloadable) }
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:url) }
end
