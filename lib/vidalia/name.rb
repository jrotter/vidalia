# Extension to String to convert to Vidalia-compatible names
class String
  # Convert string to a Vidalia-compatible name, used for interface, entity, and
  # element lookups
  def to_vidalia_name
    downcase.gsub(' ', '_')
  end
end

# Extension to Symbol to convert to Vidalia-compatible names
class Symbol
  # Convert symbol to a Vidalia-compatible name, used for interface, entity, and
  # element lookups
  def to_vidalia_name
    to_s.to_vidalia_name
  end
end

