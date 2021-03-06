require 'spec_helper'

describe Puppet::Type.type(:link_properties) do

  # Modify params inline to tests to change the resource
  # before it is generated
  let(:params) do
    {
      :name => 'net0',
      :properties => {'cpus' => '1',}
    }
  end

  # Modify the resource inline to tests when you modeling the
  # behavior of the generated resource
  let(:resource) { described_class.new(params) }
  let(:provider) { Puppet::Provider.new(resource) }
  let(:catalog) { Puppet::Resource::Catalog.new }


  let(:error_pattern) { /Invalid/ }

  it "has :link as its keyattribute" do
    expect( described_class.key_attributes).to be == [:link]
  end

  describe "has property" do
    [ :properties ].each { |prop|
      it prop do
        expect(described_class.attrtype(prop)).to be == :property
      end
    }
  end

  describe "parameter validation" do
    context "accepts temporary" do
      %w(true false).each do |thing|
        it thing.inspect do
          params[:temporary] = thing
          expect { resource }.not_to raise_error
        end
      end
    end # Rejects temporary
    context "rejects temporary" do
      %w(yes no).each do |thing|
        it thing.inspect do
          params[:temporary] = thing
          expect { resource }.to raise_error(Puppet::Error, error_pattern)
        end
      end
    end # Rejects temporary
    context "accepts properties" do
      [{"foo"=>"bar"}].each do |thing|
        it thing.inspect do
          params[:properties] = thing
          expect { resource }.not_to raise_error
        end
      end
    end # Accepts temporary
    context "rejects properties" do
      [["a"],{},"foo",:foo].each do |thing|
        it thing.inspect do
          error_pattern = /Hash/
          params[:properties] = thing
          expect { resource }.to raise_error(Puppet::Error, error_pattern)
        end
      end
    end # Rejects temporary
  end
end
