# association_spec.rb - specs for association

require_relative 'spec_helper'

describe 'ext_regex=' do
    let(:ass) { Association.new }
    subject { ass.ext_regex(%r{r.?}, :r2) }

  specify { subject }
end

describe 'ext_lit' do
  let(:ass) { Association.new }
  subject { ass.ext_lit 'rb', :ruby }




    specify { subject }
  
end

describe 'match_ext_regex' do
    let(:ass) { Association.new }
  before { ass.ext_regex %r{rb}, :ruby; ass.ext_regex %r{json}, :json }

  subject { ass.match_ext_regex 'rb' }

  specify { subject.must_equal :ruby }
end



describe 'match_ext_regex' do
    let(:ass) { Association.new }
  before { ass.ext_regex %r{rb}, :ruby; ass.ext_regex %r{json}, :json }

  subject { ass.match_ext_regex 'json' }

  specify { subject.must_equal :json }
end

describe 'match_ext' do
    let(:ass) { Association.new }
  before { ass.ext_regex %r{r.?}, :r2; ass.ext_lit 'rb', :ruby  }
  subject { ass.match_ext 'rb' }


  specify { subject.must_equal :ruby }



end



describe 'match_ext' do
    let(:ass) { Association.new }
  before { ass.ext_regex %r{r.?}, :r2; ass.ext_lit 'rb', :ruby  }
  subject { ass.match_ext 'rc' }


  specify { subject.must_equal :r2 }
end

