class CreateCorrelativeSubject < ActiveRecord::Migration[5.1]
  def change
    create_table :correlativities do |t|
      t.belongs_to :subject
      t.belongs_to :correlative_subject
      t.index [:subject_id, :correlative_subject_id],
              unique: true, name: 'index_cor_subjects_on_subject_id_and_cor_subject_id'
      t.timestamps
    end
  end
end
