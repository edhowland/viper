# system_spec.rb - specs for system

require_relative 'spec_helper'

# TODO module documentation
module AssociationViper
  def association
    :viper
  end
end

describe 'set buffer association' do
  let(:buf) { Buffer.new '' }
  before { buf.extend AssociationViper }
  subject { buf.association }

  specify { subject.must_equal :viper }
end

describe 'check_lang_syntax' do
  let(:buf) { Buffer.new 'say hello' }
  before { buf.extend AssociationViper }
  subject { check_lang_syntax buf }

  specify { subject }
end

describe 'unknow syntax checker for :default association' do
  let(:buf) { Buffer.new '' }
  subject { check_lang_syntax buf }

  specify { subject }
end

describe 'bad syntax for viper command file' do
  let(:buf) { Buffer.new 'say "' }
  before { buf.extend AssociationViper }
  subject { check_lang_syntax buf }

  specify { subject }
end

describe 'lint no checker for association' do
  let(:buf) { Buffer.new '' }
  subject { check_lang_lint buf }

  specify { -> { subject }.must_raise LintCheckerNotFoundForAssociation  }
end
