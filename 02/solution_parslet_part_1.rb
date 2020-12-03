require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'parslet'
end

class Parser < Parslet::Parser
  rule(:space) { match('\s') }
  rule(:newl?) { match('\n').maybe }
  rule(:dash) { str('-') }
  rule(:colon) { str(':') }

  rule(:num) { match('[0-9]').repeat(1).as(:num) }
  rule(:letter) { match('[a-z]').as(:letter) }
  rule(:string) { letter.repeat(1) }

  rule(:line) { num.as(:min) >> dash >> num.as(:max) >> 
    space >> letter.as(:target) >> 
    colon >> space >> string.as(:string) >> newl? }
  rule(:lines) { line.repeat(1).as(:lines) }
  root :lines
end

class Transform < Parslet::Transform
  rule(:num => simple(:int)) { Integer(int) }
  rule(:letter => simple(:char)) { char.to_s }
  rule(
    :min => simple(:min),
    :max => simple(:max),
    :target => simple(:target),
    :string => sequence(:letters)
  ) { frequency = letters.tally.fetch(target, 0); frequency >= min && frequency <= max ? 1 : 0 }
  rule(:lines => sequence(:lines)) { lines.sum }
end

parsed = Parser.new.parse(File.read('input'))
puts Transform.new.apply(parsed)