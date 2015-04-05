module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-primary btn-full", data: {id: id, fields: fields.gsub("\n", "")})
  end
  def get_archetype_from_score(score)
    if !score
      return 'n/a'
    end
    if score > 71
      return "Aggressive Hunter"
    elsif score > 31
      return "Relaxed Hunter"
    elsif score > 11
      return "Aggressive Fisherman"
    elsif score > -10
      return "Balanced Fisherman"
    elsif score > -30
      return "Relaxed Fisherman"
    elsif score > -70
      return "Aggressive Farmer"
    else
      return "Relaxed Farmer"
    end
  end
  def format_date(date)
    date.strftime("%B %Y")
  end
  def format_date_time(date_time)
    date_time.strftime("%m/%d/%Y %I:%M%P")
  end
  def format_time(date)
    date.strftime("%I:%M%P")
  end
  def get_location(resource)
    resource.city + " " + resource.state.name + ", " + resource.zip
  end
end
