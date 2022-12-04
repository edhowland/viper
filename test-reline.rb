#!/usr/bin/env ruby


require 'bundler'
Bundler.require

require 'reline'
require 'optparse'
require_relative 'termination_checker'

opt = OptionParser.new
opt.on('--prompt-list-cache-timeout VAL') { |v|
  Reline::LineEditor.__send__(:remove_const, :PROMPT_LIST_CACHE_TIMEOUT)
  Reline::LineEditor::PROMPT_LIST_CACHE_TIMEOUT = v.to_f
}
opt.on('--dynamic-prompt') {
  Reline.prompt_proc = proc { |lines|
    lines.each_with_index.map { |l, i|
      '[%04d]> ' % i
    }
  }
}
opt.on('--broken-dynamic-prompt') {
  Reline.prompt_proc = proc { |lines|
    range = lines.size > 1 ? (0..(lines.size - 2)) : (0..0)
    lines[range].each_with_index.map { |l, i|
      '[%04d]> ' % i
    }
  }
}
opt.on('--dynamic-prompt-returns-empty') {
  Reline.prompt_proc = proc { |l| [] }
}
opt.on('--dynamic-prompt-with-newline') {
  Reline.prompt_proc = proc { |lines|
    range = lines.size > 1 ? (0..(lines.size - 2)) : (0..0)
    lines[range].each_with_index.map { |l, i|
      '[%04d\n]> ' % i
    }
  }
}
opt.on('--auto-indent') {
  AutoIndent.new
}
opt.on('--dialog VAL') { |v|
  Reline.add_dialog_proc(:simple_dialog, lambda {
    return nil if v.include?('nil')
    if v.include?('simple')
      contents = <<~RUBY.split("\n")
        Ruby is...
        A dynamic, open source programming
        language with a focus on simplicity
        and productivity. It has an elegant
        syntax that is natural to read and
        easy to write.
      RUBY
    elsif v.include?('long')
      contents = <<~RUBY.split("\n")
        Ruby is...
        A dynamic, open
        source programming
        language with a
        focus on simplicity
        and productivity.
        It has an elegant
        syntax that is
        natural to read
