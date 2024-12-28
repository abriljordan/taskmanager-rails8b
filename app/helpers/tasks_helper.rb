module TasksHelper
  def completed_status(completed)
    completed ? "Yes" : "No"
  end
end
