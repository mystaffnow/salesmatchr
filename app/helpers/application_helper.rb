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
  def get_archetype_image_from_score(score)
    if !score
      return "rocket.png"
    end
    if score > 71
      return "aggressive-hunter.jpeg"
    elsif score > 31
      return "relaxed-hunter.jpeg"
    elsif score > 11
      return "aggressive-fisherman.jpeg"
    elsif score > -10
      return "balanced-fisherman.jpeg"
    elsif score > -30
      return "relaxed-fisherman.jpeg"
    elsif score > -70
      return "aggressive-farmer.jpeg"
    else
      return "relaxed-farmer.jpeg"
    end
  end
  def get_archetype_description_from_score(score)
    if !score
      return "n/a"
    end
    if score > 71
      return "Your SalesMatchr™ assessment shows that you are an Aggressive Hunter. <br/>An Aggressive Hunter is constantly burning through tasks and objectives, but sometimes he fails to think through all the details. Aggressive Hunters are CLOSERS, inside or outside - enough said!"
    elsif score > 31
      return 'Your SalesMatchr™ assessment shows that you are a Relaxed Hunter. <br/>A Relaxed Hunter quickly completes tasks and objectives and is collaborative in nature and thrives in both sales "hunting" and Account Management roles, but can fall short with the little details since they are more hungry for the thrill of the hunt!'
    elsif score > 11
      return "Your SalesMatchr™ assessment shows that you are an Aggressive Fisherman. <br/>An Aggressive Fisherman likes to tackle objectives head on, but is willing to sit down and think things through before throwing a wide net to catch new Leads."
    elsif score > -10
      return "Your SalesMatchr™ assessment shows that you are a Balanced Fisherman. <br/>A Balanced Fisherman likes to spend some time planning and strategizing, and then efficiently carries out the work at hand."
    elsif score > -30
      return "Your SalesMatchr™ assessment shows that you are a Relaxed Fisherman. <br/>A Relaxed Fisherman likes to sit down and think things through, but is not afraid to work fast when needed.  You thrive in business development type rolls where building long term relationships is crucial."
    elsif score > -70
      return "Your SalesMatchr™ assessment shows that you are an Aggressive Farmer. <br/>An Aggressive Farmer strengths lie in developing and maintaining relationships with customers.  You earn your Customer's trust by making sure all the details are handled well and that they're happy!"
    else
      return "Your SalesMatchr™ assessment shows that you are a Relaxed Farmer. <br/>A Relaxed Farmer works slowly and carefully, putting plenty of thought into every decision.  You thrive in account management and business development positions and have great relationships"
    end
  end
  def format_date(date)
    if date != nil
      date.strftime("%B %Y")
    end
  end
  def format_date_time(date_time)
    date_time.strftime("\ %I:%M%P")
  end
  def format_time(date)
    date.strftime("%I:%M%P")
  end
  def get_location(resource)
    if resource.state != nil
      resource.city + " " + resource.state.name + ", " + resource.zip
    end
  end
  def get_status_key_by_value(value)
    JobCandidate.statuses.keys[value]
  end
end
