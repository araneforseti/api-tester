require "spec_helper"

describe Api::Tester do
  it "has a version number" do
    expect(Api::Tester::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
