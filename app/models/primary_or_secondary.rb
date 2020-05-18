class PrimaryOrSecondary < Base
  attribute :primary_or_secondary, :string

  validates :primary_or_secondary,inclusion: { in: %w(primary secondary) }

  def next_step
   "qualified_to_teach" 
  end

end 