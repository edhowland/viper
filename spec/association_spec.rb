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
  before { ass.ext_regex %r{r.?}, :r2; ass.ext_lit 'rb', :ruby }
  subject { ass.match_ext 'rb' }

  specify { subject.must_equal :ruby }
end

describe 'match_ext' do
  let(:ass) { Association.new }
  before { ass.ext_regex %r{r.?}, :r2; ass.ext_lit 'rb', :ruby }
  subject { ass.match_ext 'rc' }

  specify { subject.must_equal :r2 }
end

describe 'match_file_regex' do
  let(:ass) { Association.new }
  before { ass.file_regex %r{.+_spec\.rb}, :spec; ass.file_regex %r{.+_rspec\.rb}, :rspec }
  subject { ass.match_file_regex 'myfile_spec.rb' }

  specify { subject.must_equal :spec }
end

describe 'match_file' do
  let(:ass) { Association.new }
  before { ass.file_regex %r{.+_spec\.rb}, :spec; ass.file_lit 'myfile_spec.rb', :myfile }
  subject { ass.match_file 'myfile_spec.rb' }

  specify { subject.must_equal :myfile }
end

describe 'match_dir' do
  let(:ass) { Association.new }
  before { ass.dir_regex %r{/h/b/.+\.rb}, :ruby; ass.dir_lit '/h/b/src', :source }
  subject { ass.match_dir '/h/b/src' }

  specify { subject.must_equal :source }
end

describe 'associate' do
  let(:ass) { Association.new }
  before { ass.ext_lit '.rb', :ruby; ass.file_regex %r{.+_spec\.rb}, :spec }
  subject { ass.associate '/h/b/src/spec/my_spec.rb' }

  specify { subject.must_equal :spec }
  specify { ass.associate('file.rb').must_equal :ruby }
end

describe 'assoc_file' do
  let(:ass) { Association.new }

end

describe 'ext' do
  let(:ass) { Association.new }
  before { ass.ext '.rb', :ruby; ass.ext '/\.r./', :rex }
  subject { ass.associate 'file.rb' }

  specify { subject.must_equal :ruby }
  specify { ass.associate('file.rx').must_equal :rex }
end

describe 'file' do
  let(:ass) { Association.new }
  before { ass.file '/.+_spec\.rb/', :spec; ass.file 'myfile_spec.rb', :nop; ass.ext '.rb', :ruby }
  subject { ass.associate 'my_spec.rb' }

  specify { subject.must_equal :spec }
  specify { ass.associate('file.rb').must_equal :ruby }
  specify { ass.associate('myfile_spec.rb').must_equal :nop }
end

describe 'dir' do
  let(:ass) { Association.new }
  before { ass.dir '/h/b/src/viper/spec', :spec }
  subject { ass.associate '/h/b/src/viper/spec' }

  specify { subject.must_equal :spec }
end

describe 'dir regex' do
  let(:ass) { Association.new }
  before { ass.dir '/.*/xxx/', :rex }
  subject { ass.associate '/h/b/src/viper/xxx/file.rb' }

  specify { subject.must_equal :rex }
end
