class Deduplicator
  def call
    Image.where.not(similar_ids: [nil, "", "-"]).distinct.pluck(:similar_ids).each do |group|
      ids = group.split(",")
      Image.where(id: ids[1..]).destroy_all
    end
    Image.where.not(similar_ids: [nil, "", "-"]).update_all(similar_ids: nil)
  end
end