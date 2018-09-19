RailsAdmin.config do |config|
  config.model SchoolTerm do
    create do
      field :term
      field :year
      field :date_start
      field :date_end
    end

    edit do
      field :term
      field :year
      field :date_start
      field :date_end
    end

    show do
      field :term
      field :year
      field :date_start
      field :date_end
      field :created_at
      field :updated_at
    end

    list do
      field :term
      field :year
      field :date_start
      field :date_end
      field :created_at
      field :updated_at
    end
  end
end
