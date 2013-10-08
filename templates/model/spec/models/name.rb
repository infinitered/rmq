describe '<%= @name_camel_case %>' do

  before do
  end

  after do
  end

  it 'should create instance' do
    <%= @name_camel_case %>.create.is_a?(<%= @name_camel_case %>).should == true
  end
end
