begin
  require 'active_support/multibyte'
  require 'lib/transtable'
rescue LoadError
  require 'rubygems'
  require 'active_support/multibyte'
  require 'lib/transtable'
end

module Slugalizer
  extend self
  SEPARATORS = %w[- _ +]

  def slugalize(text, separator = "-")
    unless SEPARATORS.include?(separator)
      raise "Word separator must be one of #{SEPARATORS}"
    end
    word = []
    re_separator = Regexp.escape(separator)
    text.to_s.scan(/./).each do |c|
       word.push(!TRANSTABLE.invert.index(c).blank? ? TRANSTABLE.invert.index(c).to_s : c)
    end
    text = word.join.to_s
    result = text.to_s
    #result = ActiveSupport::Multibyte::Handlers::UTF8Handler.normalize(text.to_s, :kd)
    result.gsub!(/[^\x00-\x7F]+/, '')                      # Remove non-ASCII (e.g. diacritics).
    result.gsub!(/[^a-z0-9\-_\+]+/i, separator)            # Turn non-slug chars into the separator.
    result.gsub!(/#{re_separator}{2,}/, separator)         # No more than one of the separator in a row.
    result.gsub!(/^#{re_separator}|#{re_separator}$/, '')  # Remove leading/trailing separator.
    result.downcase!
    result
  end
end
