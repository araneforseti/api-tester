require "spec_helper"

describe Api::Tester do
  it "has a version number" do
    expect(Api::Tester::VERSION).not_to be nil
  end
end
